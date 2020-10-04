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

    self:addContactListeners()

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

function M:addContactListener(filterFn, startFn, endFn)
    table.insert(self.contactListeners,
    {
        filter = filterFn,
        onStart = startFn,
        onEnd = endFn
    })
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

    lg.draw(self.background, 0, 0, 0, 1 / 8, 1 / 8)

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
    TimedGameState.update(self, dt)
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

    if lk.isDown('p') then
        self.gamestate.warpTo('Pause,0,0,x')
    end
end

function M:load(x, y)
    TimedGameState.load(self)
    self:setupWorldBounds()
    self:setupWarps()
    
    if type(x) == "string" then
        x = tonumber(x)
    end
    if type(y) == "string" then
        y = tonumber(y)
    end

    if type(x) == "number" and x < 0 then
        x = x + self:getWidth()
    end
    if type(y) == "number" and y < 0 then
        y = y + self:getHeight()
    end

    self.player = player.new(self.world, self.gamestate.graphics.Player, x, y)
    self:pushCamera(Camera.new(self.gamestate, self.player.body))
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