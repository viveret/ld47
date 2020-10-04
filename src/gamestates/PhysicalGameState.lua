local M = setmetatable({}, { __index = TimedGameState })
M.__index = M

function M.new(gamestate, name, graphics)
    local self = setmetatable(TimedGameState.new(gamestate, name), M)
    self.background = graphics.Bg
    self.world = lp.newWorld(0, 0, true)
    self.player = nil
    self.cameras = { }
    self:pushCamera(Camera.new())
    self.contactListeners = {}
    self.bounds = {}
    self.warps = {}
    self.renderBounds = false
    self.renderWarps = false
    self.toast = nil
    self.isPhysicalGameState = true
    self.actors = {}
    self.colors = {
        night = { r = 0.2, g = 0.2, b = 0.6 },
        day = { r = 1, g = 1, b = 1 }
    }
    self.sunriseHourStart = 8
    self.sunriseHourEnd = 8.5
    self.sunsetHourStart = 18
    self.sunsetHourEnd = 20

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

function M:addProximityListener()
end

function M:addProximityListeners()
    self:addProximityListener(
        function (a, b)
            return a.activated ~= true and a.type == 'sign' and b.type == 'player'
        end,
        function (a, b)
            local sign = a.sign
            if sign == nil then
                sign = b.sign
            end

            if sign ~= nil then
                sign:withinProximity(a, b)
            end
            a.activated = true
            b.activated = true
        end,
        function (a, b)
        end
    )

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

    drawList(self.actors)
    drawList(self.doors)
    drawList(self.animatedObjects)

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
    -- TimedGameState.draw(self)
    lg.push()
    self:drawInWorldView()
    lg.pop()

    local x = self.player.body:getX()
    local y = self.player.body:getY()

    toast.draw()

    local currentVx, currentVy = self.player.body:getLinearVelocity()
    lg.print("You are at " .. x .. ", " .. y .. " in " .. self.name, 0, 0)
    lg.print("Camera is at " .. self:currentCamera().x .. ", " .. self:currentCamera().y, 0, 16)
    lg.print("Player's velocity is " .. currentVx .. ", " .. currentVy, 0, 32)
    lg.print("Current time is " .. self.gamestate.time, 0, 48)
end

function M:update(dt)
    TimedGameState.update(self)
    self.world:update(dt)
    self:currentCamera():update(dt)

    self.player:update(dt)

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

function M:load()
    TimedGameState.load(self)
    self:setupWorldBounds()
    self:setupWarps()
    
    self.player = player.new(self.world, self.gamestate.graphics.Player, 0, 0)
    self:pushCamera(Camera.new(self.gamestate, self.player.body))
end

function M:switchTo(x, y)
    TimedGameState.switchTo(self, x, y)
    self.player:setPosition(x, y, 0, 0)
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
    end
end

function M:addActor(name, actor)
    self.actors[name] = actor

    if actor.callback ~= nil then

    end 
end

function M:getActor(name)
    return self.actors[name]
end

function M:removeActor(name)
    local oldActor = self.actors[name]

    self.actors[name] = nil

    return oldActor ~= nil
end

return M