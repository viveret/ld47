local M = setmetatable({}, { __index = TimedGameState })
M.__index = M

local Player = require "src.actors.Player"

function M.new(gamestate, scene, graphics)
    if gamestate == nil then
        error ('gamestate must not be nil')
    elseif scene == nil or scene == '' then
        error ('scene must not be nil or empty')
    elseif graphics == nil then
        error ('graphics must not be nil')
    end

    local self = setmetatable(TimedGameState.new(gamestate, scene), M)
    self.background = graphics.bg
    self.bgMusicName = "theme"
    self.world = lp.newWorld(0, 0, true)
    self.player = nil
    self.cameras = { }
    self:pushCamera(Camera.new())
    self.contactListeners = {}
    self.proximityListeners = {}
    self.bounds = {}
    self.warps = {}
    self.proximityObjects = {}
    self.staticObjects = {}
    self.renderBounds = false
    self.renderWarps = false
    self.isPhysicalGameState = true
    self.actors = {}
    self.colors = {
        night = { r = 0.5, g = 0.5, b = 0.6 },
        day = { r = 1, g = 1, b = 1 }
    }
    self.sunriseHourStart = 8
    self.sunriseHourEnd = 9
    self.sunsetHourStart = 19
    self.sunsetHourEnd = 20

    self.interactProximity = 18

    -- hook up warps and what not
    self:addContactListeners()
    self:addProximityListeners()

    -- hook up actor collisions
    local contactFilter = function(a,b)
        return a.callback ~= nil or b.callback ~= nil
    end

    local contactOnStart = function(a,b)
        if a.callback ~= nil then
            a.callback(gamestate, a, "collision", b)
        end

        if b.callback ~= nil then
            b.callback(gamestate, b, "collision", a)
        end
    end

    local contactOnEnd = function(a,b)
        if a.callback ~= nil then
            a.callback(gamestate, a, "end collision", b)
        end

        if b.callback ~= nil then
            b.callback(gamestate, b, "end collision", a)
        end
    end

    self:addContactListener(contactFilter, contactOnStart, contactOnEnd)

    local physBeginContact = function (a, b, coll)
        
        if a == nil or b == nil then
            return
        end
        local aUserData = a:getUserData()
        local bUserData = b:getUserData()

        if aUserData ~= nil and bUserData ~= nil then
            self:physContactBetweenStart(aUserData, bUserData)
        end
    end
    
    local physEndContact = function (a, b, coll)
        if a == nil or b == nil then
            return
        end
        local aUserData = a:getUserData()
        local bUserData = b:getUserData()
        
        if aUserData ~= nil and bUserData ~= nil then
            self:physContactBetweenEnd(aUserData, bUserData)
        end
    end
     
    local physPreSolve = function (a, b, coll)
    end
     
    local physPostSolve = function (a, b, coll, normalimpulse, tangentimpulse)
    end    

    self.world:setCallbacks(physBeginContact, physEndContact, physPreSolve, physPostSolve)

	return self
end

function M:keypressed( key, scancode, isrepeat )
end

function M:keyreleased( key, scancode )
end

function M:getColorRightNow()
    local ticksPerHour = 60 * 60
    local ticksOffset = 8 * ticksPerHour
    local timeOfDay = (self.gamestate.time + ticksOffset) % (ticksPerHour * 24)
    if timeOfDay < self.sunriseHourStart * ticksPerHour then
        return self.colors.night
    elseif timeOfDay < self.sunriseHourEnd * ticksPerHour then
        local sunriseDuration = self.sunriseHourEnd - self.sunriseHourStart
        return interpolateValues(self.colors.night, self.colors.day, (timeOfDay - self.sunriseHourStart * ticksPerHour) / (sunriseDuration * ticksPerHour))
    elseif timeOfDay < self.sunsetHourStart * ticksPerHour then
        return self.colors.day
    elseif timeOfDay < self.sunsetHourEnd * ticksPerHour then
        local sunsetDuration = self.sunsetHourEnd - self.sunsetHourStart
        return interpolateValues(self.colors.day, self.colors.night, (timeOfDay - self.sunsetHourStart * ticksPerHour) / (sunsetDuration * ticksPerHour))
    else
        return self.colors.night
    end
end

function M:addContactListener(filterFn, startFn, endFn)
    table.insert(self.contactListeners,
    {
        filter = filterFn,
        onStart = startFn,
        onEnd = endFn
    })
end

function M:onContactFireEvent(filterFn, contactEvent)
    self:addContactListener(
        function (a, b)
            return a.activated ~= true and filterFn(a, b)
        end,
        function (a, b)
            self.gamestate.fire(contactEvent, true)

            a.activated = true
            b.activated = true
        end,
        function (a, b)
        end
    )
end

function M:addContactListeners()
    self:addContactListener(
        function (a, b)
            return a.activated ~= true and a.type == 'warp' and b.type == 'player'
        end,
        function (a, b)
            local path = a.path
            local door = a.door
            if path == nil then
                path = b.path
                door = b.door
            end

            if door ~= nil then
                door:animateAndWarp(self.gamestate, path)
            else
                self.gamestate.fire(WarpEvent.new(path), true)
            end
            a.activated = true
            b.activated = true
        end,
        function (a, b)
        end
    )

    self:onContactFireEvent(
        function (a, b) return a.type == 'sign' and b.type == 'player' end
    )
end

function M:getActiveObjects()
    return lume.concat(self.actors, { self.player }, self.proximityObjects, lume.filter(self.staticObjects, { isInteractable = true }))
end

function M:addProximityListener(proximity, filterFn, onEnterFn, onLeaveFn)
    table.insert(self.proximityListeners,
    {
        proximity = proximity,
        filter = filterFn,
        onEnter = onEnterFn,
        onLeave = onLeaveFn
    })
end

function M:addProximityListeners()
    self:addProximityListener(
        self.interactProximity,
        function (a, b)
            return a.isInteractable and b.type == 'player'
        end,
        function (a, b)
            local interactable = a
            local player = b
            if not interactable.isInteractable then
                interactable = b
                player = a
            end

            if interactable.hasInteractedWith then
                return
            end

            interactable.hasInteractedWith = true
            interactable.canInteractWith = true
            if lume.find(player.interactWith, interactable) == nil then
                table.insert(player.interactWith, interactable)
            end
        end,
        function (a, b)
            if a.isInteractable then
                if b.interactWith ~= nil then
                    lume.remove(b.interactWith, a)
                end
                a.hasInteractedWith = false
                a.canInteractWith = false
            else
                if b.interactWith ~= nil then
                    lume.remove(b.interactWith, a)
                end
                b.hasInteractedWith = false
                b.canInteractWith = false
            end
        end
    )


    -- self:addProximityListener(
    --     10,
    --     function (a, b)
    --         return a.type == 'sign' and b.type == 'player'
    --     end,
    --     function (a, b)
    --         local sign = a
    --         if sign.type ~= 'sign' then
    --             sign = b
    --         end

    --         if sign ~= nil then
    --             sign.inProximity = true
    --         end
    --     end,
    --     function (a, b)
    --         if a.type == 'sign' then
    --             a.inProximity = false
    --         else
    --             b.inProximity = false
    --         end
    --     end
    -- )

    -- self:onProximityFireEvent(
    --     function (a, b) return a.type == 'sign' and b.type == 'player' end,
    -- )
end

function M:addExteriorWorldBounds(paddingx, paddingy)
    if paddingx == nil then
        paddingx = 2
    end
    if paddingy == nil then
        paddingy = paddingx
    end
    
    table.insert(
        self.bounds,
        { -- Top
            x = 0, y = -paddingy,
            w = self:getWidth(), h = paddingy * 2
        }
    )
    table.insert(
        self.bounds,
        { -- Bottom
            x = 0, y = self:getHeight() - paddingy * 2,
            w = self:getWidth(), h = paddingy * 2
        }
    )
    table.insert(
        self.bounds,
        { -- Left
            x = -paddingx, y = -paddingy * 2,
            w = paddingx * 2, h = self:getHeight() + paddingy * 2
        }
    )
    table.insert(
        self.bounds,
        { -- Right
            x = self:getWidth() - paddingx, y = -paddingy * 2,
            w = paddingx * 2, h = self:getHeight() + paddingy * 2
        }
    )
end

function M:addWorldBounds(bounds)
    for k,v in pairs(bounds) do
        table.insert(
            self.bounds,
            v
        )
    end
end

function M:getWidth()
    return self.background:getWidth() / 8
end

function M:getHeight()
    return self.background:getHeight() / 8
end

function M:drawInWorldView()
    if self:currentCamera() ~= nil then
        self:currentCamera():draw()
    end

    local ambientColor = self.gamestate.saveData.globalAmbientColor
    if ambientColor == nil then
        ambientColor = self:getColorRightNow()
    end
    lg.setColor(ambientColor.r, ambientColor.g, ambientColor.b)

    lg.draw(self.background, 0, 0, 0, 1 / 8, 1 / 8)

    local drawList = function(list)
        if list ~= nil then
            for _, e in pairs(list) do
                e:draw()
            end
        end
    end

    drawList(self.doors)
    drawList(self.animatedObjects)
    drawList(self.staticObjects)
    drawList(self.actors)

    self.player:draw()

    if self.renderBounds then
        lg.setColor(1, 0, 0)
        for k, bound in pairs(self.bounds) do
            lg.rectangle('line', bound.x, bound.y, bound.w, bound.h)
        end
        lg.setColor(1, 1, 1)
    end

    if self.renderWarps then
        lg.setColor(0, 1, 0)
        for k, warp in pairs(self.warps) do
            lg.rectangle('line', warp.x, warp.y, warp.w, warp.h)
        end
        lg.setColor(1, 1, 1)
    end

    lg.setColor(1, 1, 1)
end

function M:physContactBetweenStart(a, b)
    for k,listener in pairs(self.contactListeners) do
        if listener.filter(a, b) or listener.filter(b, a) then
            listener.onStart(a, b)
        end
    end
end

function M:physContactBetweenEnd(a, b)
    for k,listener in pairs(self.contactListeners) do
        if listener.filter(a, b) or listener.filter(b, a) then
            listener.onEnd(a, b)
        end
    end
end

function M:draw()
    lg.push()
    self:drawInWorldView()
    lg.pop()

    -- local x = self.player.body:getX()
    -- local y = self.player.body:getY()

    -- local currentVx, currentVy = self.player.body:getLinearVelocity()
    -- lg.print("You are at " .. x .. ", " .. y .. " in " .. self.scene, 0, 0)
    -- lg.print("Camera is at " .. self:currentCamera().x .. ", " .. self:currentCamera().y, 0, 16)
    -- lg.print("Player's velocity is " .. currentVx .. ", " .. currentVy, 0, 32)
    -- lg.print("Current time is " .. self.gamestate.time, 0, 48)

    TimedGameState.draw(self)
end

function M:realTimeUpdate(dt)
    self.world:update(dt)
end

function M:update(dt)
    TimedGameState.update(self)
    self:currentCamera():update(dt)

    if self.topmost then
        self.player:update(dt)
    end 

    self:updateProximityListeners()

    local updateList = function(list)
        if list ~= nil then
            for _, e in pairs(list) do
                e:update(dt)
            end
        end
    end

    updateList(self.animatedObjects)
    updateList(self.actors)
    updateList(self.doors)
end

function M:updateProximityListeners()
    local withinProximity = function(r, a, b)
        local ax = a.x
        local ay = a.y
        local bx = b.x
        local by = b.y
        
        if ax == nil then
            ax = a:getX()
            ay = a:getY()
        end

        if bx == nil then
            bx = b:getX()
            by = b:getY()
        end

        local dx = bx - ax
        local dy = by - ay
        local d2 = dx * dx + dy * dy
        local r2 = r * r
        return d2 < r2
    end

    local allObjects = self:getActiveObjects()
    for ia,a in pairs(allObjects) do
        for ib,b in pairs(allObjects) do
            if ia ~= ib and a ~= nil and b ~= nil then
                for _,li in pairs(self.proximityListeners) do
                    if li.filter(a, b) or li.filter(b, a) then
                        if withinProximity(li.proximity, a, b) then
                            li.onEnter(a, b)
                        else
                            li.onLeave(a, b)
                        end
                    end
                end
            end
        end
    end
end

function M:load()
    TimedGameState.load(self)
    self:setupWorldBounds()
    self:setupWarps()
    
    self.player = Player.new(self.world, 'player', self.gamestate, 0, 0, 4, 4, self.gamestate.animations.actors.player)
    self:pushCamera(Camera.new(self.gamestate, self.player.body))
end

function M:switchTo(x, y)
    TimedGameState.switchTo(self, x, y)
    self.player:setPosition(x, y, 0, 0)

    for _,warp in pairs(self.warps) do
        warp.activated = false
    end
    self.player.activated = false
end

function M:activated()
    if self.bgMusicName ~= nil then
        self.gamestate.audio:play(self.bgMusicName)
    else
        self.gamestate.audio:fadeAllOut()
    end
end

function M:save()
end

function M:currentCamera()
    return lume.last(self.cameras)
end

function M:pushCamera(camera)
    if camera ~= nil then
        table.insert(self.cameras, camera)
    else
        error('camera must not be nil')
    end
end

function M:popCamera()
    table.remove(self.cameras)
end

function M:replaceCamera(camera)
    if camera ~= nil then
        self.cameras[-1] = camera
    else
        error('camera must not be nil')
    end
end

function M:removeCamera(camera)
    for ix, c in pairs(self.cameras) do
        if c == camera then
            self.cameras[ix] = nil
            break
        end
    end
end

function M:setupWorldBounds()
    for k, bound in pairs(self.bounds) do
        bound.type = 'world-bound'
        local body = lp.newBody(self.world, bound.x + bound.w / 2, bound.y + bound.h / 2, "static")
        local shape = lp.newRectangleShape(bound.w, bound.h)
        local fixture = lp.newFixture(body, shape)
        fixture:setUserData(bound)
    end
end

function M:setupWarps()
    for k, warp in pairs(self.warps) do
        warp.type = 'warp'
        warp.body = lp.newBody(self.world, warp.x + warp.w / 2, warp.y + warp.h / 2, "static")
        warp.shape = lp.newRectangleShape(warp.w, warp.h)
        warp.fixture = lp.newFixture(warp.body, warp.shape)
        warp.fixture:setUserData(warp)

        if warp.door ~= nil then
            warp.door.path = warp.path
        end
    end
end

function M:addActor(name, actor)
    self.actors[name] = actor
end

function M:addStaticObject(name, staticObject)
    self.staticObjects[name] = staticObject
end

function M:getActor(name)
    if name == "player" then
        return self.player
    else
        return self.actors[name]
    end
end

function M:removeActor(name)
    local oldActor = self.actors[name]

    if oldActor ~= nil then
        self.actors[name] = nil
        oldActor:onRemove(self)
    end

    return oldActor ~= nil
end

function M:getStaticObject(name)
    return self.staticObjects[name]
end

function M:removeStaticObject(name)
    local oldObj = self.staticObjects[name]

    if oldObj ~= nil then
        self.staticObjects[name] = nil
        oldObj:onRemove(self)
    end

    return oldObj ~= nil
end

function M:addStaticObjects(list)
    for k,v in pairs(list) do
        table.insert(
            self.staticObjects,
            v
        )
    end
end

return M