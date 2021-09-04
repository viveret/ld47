local super = require "src.gamestates.TimedGameState"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

local AnimatedObject = require "src.world.AnimatedObject"
local Player = require "src.actors.Player"

function M.new(scene, graphics)
    if scene == nil or scene == '' then
        error ('scene must not be nil or empty')
    elseif graphics == nil then
        error ('graphics must not be nil')
    end

    local self = setmetatable(lume.extend(super.new(scene), {
        isPhysicalGameState = true,
        background = graphics.bg or error ('missing graphics.bg'),
        bgMusicName = "theme",
        world = lp.newWorld(0, 0, true),
        player = nil,
        cameras = {},
        contactListeners = {},
        proximityListeners = {},
        bounds = {},
        warps = {},
        proximityObjects = {},
        animatedObjects = {},
        staticObjects = {},
        actors = {},
        interactProximity = 18
    }), M)

    self:pushCamera(Camera.new())

    self.drawDebugUIEnabled = true

    -- hook up warps and what not
    self:addContactListeners()
    self:addProximityListeners()

    -- hook up actor collisions
    self:setupCollisionCallbacks()

	return self
end

function M:setupCollisionCallbacks()
    local contactHandler = function(a, b, msg)
        if a.callback ~= nil then
            a.callback(game, a, msg, b)
        end

        if b.callback ~= nil then
            b.callback(game, b, msg, a)
        end
    end

    local contactOnStart = function(a, b) return contactHandler(a, b, "collision") end
    local contactOnEnd = function(a, b) return contactHandler(a, b, "end collision") end
    local contactFilter = function(a,b) return a.callback ~= nil or b.callback ~= nil end

    self:addContactListener(contactFilter, contactOnStart, contactOnEnd)

    local physContactHandler = function (a, b, coll, handler)
        if a == nil or b == nil then
            return
        end
        local aUserData = a:getUserData()
        local bUserData = b:getUserData()

        if aUserData ~= nil and bUserData ~= nil then
            handler(aUserData, bUserData)
        end
    end

    local physBeginContact = function (a, b, coll)
        physContactHandler(a, b, coll, function(aUserData, bUserData) self:physContactBetweenStart(aUserData, bUserData) end)
    end
    
    local physEndContact = function (a, b, coll)
        physContactHandler(a, b, coll, function(aUserData, bUserData) self:physContactBetweenEnd(aUserData, bUserData) end)
    end
     
    local physPreSolve = function (a, b, coll) end
     
    local physPostSolve = function (a, b, coll, normalimpulse, tangentimpulse) end

    self.world:setCallbacks(physBeginContact, physEndContact, physPreSolve, physPostSolve)
end

function M:keypressed( key, scancode, isrepeat )
    if not isrepeat then
        if lume.find({game.strings.keyBinds.pause, 'escape'}, key) then
            game.fire(events.game.PauseEvent.new(), true)
            return
        elseif key == game.strings.keyBinds.notes then
            game.fire(events.game.NotesEvent.new(), true)
            return
        elseif key == game.strings.keyBinds.inventory then
            game.fire(events.game.InventoryEvent.new(), true)
            return
        elseif key == ',' then
            game.timeWarpBumpDown()
            return
        elseif key == '.' then
            game.timeWarpBumpUp()
            return
        elseif key == 'h' then
            game.fire(events.actor.ActorTextEvent.new(game.current().scene, 'player', 'Hello'))
        elseif key == 'f4' then
            game.debug.renderWarps = not game.debug.renderWarps
        elseif key == 'f5' then
            game.debug.renderBounds = not game.debug.renderBounds
        elseif key == 'f6' then
            game.debug.renderObjects = not game.debug.renderObjects
        elseif key == 'f7' then
            game.debug.renderActors = not game.debug.renderActors
        elseif key == 'f8' then
            game.fire(events.gamestate.QuickLoadEvent.new(), true)
        elseif key == 'f9' then
            game.fire(events.gamestate.QuickSaveEvent.new(), true)
        elseif key == '`' then
            game.fire(events.dev.DevConsoleEvent.new(), true)
        end

        if game.debug.camera.enabled then
            if key == 'j' then
                game.debug.camera.vx = -1
                return
            elseif key == 'l' then
                game.debug.camera.vx = 1
                return
            elseif key == 'i' then
                game.debug.camera.vy = -1
            elseif key == 'k' then
                game.debug.camera.vy = 1
            end
        end
    end

    if self.player ~= nil then
        self.player:keypressed(key, scancode, isrepeat)
    end
end

function M:keyreleased( key, scancode )
    if game.debug.camera.enabled then
        if key == 'j' or key == 'l' then
            game.debug.camera.vx = 0
            return
        elseif key == 'i' or key == 'k' then
            game.debug.camera.vy = 0
        end
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
            game.fire(contactEvent, true)

            a.activated = true
            b.activated = true
        end, donothing
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
                door:animateAndWarp(game, path)
            else
                game.fire(events.WarpEvent.new(path), true)
            end
            a.activated = true
            b.activated = true
        end, donothing
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

function M:splitBoundHorizontal(bound, split)
    if bound == nil then
        error ("bound must not be nil")
    elseif split == nil then
        error ("split must not be nil")
    end

    local left = {
        x = bound.x, y = bound.y,
        w = split.x - bound.x, h = bound.h
    }
    local right = {
        x = split.x + split.w, y = bound.y,
        w = bound.w - (split.w + left.w), h = bound.h
    }
    return left, right
end

function M:addExteriorWorldBounds(paddingx, paddingy)
    if paddingx == nil then
        paddingx = 2
    end
    if paddingy == nil then
        paddingy = paddingx
    end

    print('self:getHeight(): ' .. self:getHeight())
    
    self:addWorldBounds({
        { -- Top
            x = 0, y = -paddingy,
            w = self:getWidth(), h = paddingy * 2
        },
        { -- Bottom
            x = 0, y = self:getHeight() - paddingy * 2,
            w = self:getWidth(), h = paddingy * 2
        },
        { -- Left
            x = -paddingx, y = -paddingy * 2,
            w = paddingx * 2, h = self:getHeight() + paddingy * 2
        },
        { -- Right
            x = self:getWidth() - paddingx, y = -paddingy * 2,
            w = paddingx * 2, h = self:getHeight() + paddingy * 2
        }
    })
end

function M:addWorldBounds(bounds)
    for k,v in pairs(bounds) do
        table.insert(
            self.bounds,
            v
        )
    end
end

function M:addInteractDialog(x, y, image, animated, label, name, text)
    local obj = self:CreateAndAddDrawableObject(x, y, image, animated, function()
		game.toast((name or '???') .. ': ' .. text)
    end, label)

    obj.type = 'dialog'
    obj.isInteractable = true
    table.insert(self.proximityObjects, obj)
    return obj
end

function M:getWidth()
    return self.background:getWidth() / 8
end

function M:getHeight()
    return self.background:getHeight() / 8
end

function M:drawInWorldView()
    lg.push()

    if self:currentCamera() ~= nil then
        self:currentCamera():draw()
    end

    if game.debug.camera.enabled then
        lg.translate(game.debug.camera.x * -8, game.debug.camera.y * -8)
    end

    local ambientColor = game.saveData.globalAmbientColor
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

    if game.debug.renderBounds then
        lg.setColor(1, 0, 0)
        for k, bound in pairs(self.bounds) do
            lg.rectangle('line', bound.x, bound.y, bound.w, bound.h)
        end
        lg.setColor(1, 1, 1)
    end

    if game.debug.renderWarps then
        lg.setColor(0, 1, 0)
        for k, warp in pairs(self.warps) do
            lg.rectangle('line', warp.x, warp.y, warp.w, warp.h)
        end
        lg.setColor(1, 1, 1)
    end

    lg.setColor(1, 1, 1)
    lg.pop()
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
    self:drawInWorldView()

    self:drawUI()
    self:drawDebugUI()

    TimedGameState.draw(self)
end

function M:drawDebugUI()
    local x = self.player.body:getX()
    local y = self.player.body:getY()

    if self.drawDebugUIEnabled then
        local currentVx, currentVy = self.player.body:getLinearVelocity()
        local msg = ""
        if game.debug.renderFilenames then
            msg = msg .. "<" .. self.__file .. ">\n"
        end
        msg = msg .. "You are at " .. x .. ", " .. y .. "\n"
        msg = msg .. "Camera is at " .. self:currentCamera().x .. ", " .. self:currentCamera().y .. "\n"
        msg = msg .. "Player's velocity is " .. currentVx .. ", " .. currentVy .. "\n"
        msg = msg .. "Current time is " .. game.time:tostring()
        lg.print(msg, 0, 0)
    end
end

function M:drawUI()
    -- Show what scene the user in
    local sceneWidth = 16 * (#self.scene + 1)
	game.graphics:drawObject(game.images.ui.clock_bg, lg.getWidth() - sceneWidth, 0, sceneWidth, 64)
    game.graphics:drawTextInBox(self.scene, lg.getWidth() - sceneWidth, 0, sceneWidth, 64, game.images.ui.dialog_font, nil, true)

    game.ui.interactionTray:draw()
end

function M:tick(ticks)
    TimedGameState.tick(self, ticks)
end

function M:update(dt)
    TimedGameState.update(self, dt)
    self.world:update(dt)
    self:currentCamera():update(dt)

    if game.debug.camera.enabled then
        game.debug.camera.x = game.debug.camera.x + game.debug.camera.vx * dt
        game.debug.camera.y = game.debug.camera.y + game.debug.camera.vy * dt
    end

    self.player:update(dt)

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

function M:load(x, y)
    TimedGameState.load(self)
    self:setupWorldBounds()
    self:setupWarps()
    
    self.player = Player.new(self.world, 'player', game, x, y, nil, nil, game.animations.actors.player)
    self:pushCamera(Camera.new(self, self.player))
    print('added camera attached to player: ' .. inspect({ self:currentCamera().x, self:currentCamera().y }))
    print('player is at: ' .. inspect({ self.player.x, self.player.y }))
    self:currentCamera():refresh()
end

function M:switchTo(x, y)
    TimedGameState.switchTo(self, x, y)
    self.player:setPosition(x, y, 0, 0)
    self:currentCamera():refresh()

    for _,warp in pairs(self.warps) do
        warp.activated = false
    end
    self.player.activated = false
end

function M:activated()
    if self.bgMusicName ~= nil then
        game.audio:play(self.bgMusicName)
    else
        game.audio:fadeAllOut()
    end

    game.saves:quicksave(true)
    self:currentCamera():refresh()
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

function M:CreateDrawableObject(x, y, drawable, animated, onInteract, label)
    local constructor = StaticObject.new
    if animated then
        constructor = AnimatedObject.new
    end
    return constructor(self.world, x, y, drawable, onInteract, label)
end

function M:CreateAndAddDrawableObject(x, y, drawable, animated, onInteract, label)
    local obj = self:CreateDrawableObject(x, y, drawable, animated, onInteract, label)
    if animated then
        table.insert(self.animatedObjects, obj)
    else
        table.insert(self.staticObjects, obj)
    end
    return obj
end

function M:onWait()
    print('waiting...')
end

function M:addWaitableObject(x, y, drawable, animated, label)
    local obj = self:CreateAndAddDrawableObject(x, y, drawable, animated, self.onWait, label)
    obj.type = 'wait'
    obj.isInteractable = true
    table.insert(self.proximityObjects, obj)
    return obj
end

return M