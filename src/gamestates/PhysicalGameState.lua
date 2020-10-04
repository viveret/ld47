local M = setmetatable({}, { __index = TimedGameState })
M.__index = M

function M.new(gamestate, name, bg)
    local self = setmetatable(TimedGameState.new(gamestate, name), M)
    self.background = bg
    self.world = lp.newWorld(0, 0, true)
    self.player = nil
    self.cameras = { }
    self:pushCamera(Camera.new())
    self.renderBounds = false
    self.renderWarps = false
    self.toast = nil
    self.isPhysicalGameState = true

    local physBeginContact = function (a, b, coll)
        if a == nil or b == nil then
            return
        end
        local aUserData = a:getUserData()
        local bUserData = b:getUserData()
        
        if aUserData ~= nil and bUserData ~= nil then
            self:physContactBetween(aUserData, bUserData)
        end
    end
    
    local physEndContact = function (a, b, coll)
        
    end
     
    local physPreSolve = function (a, b, coll)
    end
     
    local physPostSolve = function (a, b, coll, normalimpulse, tangentimpulse)
    end    

    self.world:setCallbacks(physBeginContact, physEndContact, physPreSolve, physPostSolve)

	return self
end

function M:touchWarp(warp)
    self.gamestate.fire(WarpEvent.new(warp.path), true)
end

function M:getWidth()
    return 16 * 10 --self.background:getWidth() / 64
end

function M:getHeight()
    return 12 * 10 -- self.background:getHeight() / 64
end

function M:drawInWorldView()
    if self:currentCamera() ~= nil then
        self:currentCamera():draw()
    end

    if self.gamestate ~= nil then
        self.gamestate.graphics.drawObject(self.background, 0, 0, 16 * 10, 12 * 10)
        self.player:draw()
    end

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

    if self.doors ~= nil then
        for _, door in pairs(self.doors) do
            door:draw()
        end
    end
end

function M:physContactBetween(a, b)
    if a.type ~= nil then
        if a.type == 'warp' then
            self:touchWarp(a)
        end
    elseif b.type ~= nil then
        if b.type == 'warp' then
            self:touchWarp(b)
        end
    else
        error('Unknown user data type')
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
end

function M:update(dt)
    TimedGameState.update(self, dt)
    self.world:update(dt)
    self.player:update(dt)
    self:currentCamera():update(dt)
end

function M:load(x, y)
    TimedGameState.load(self)
    self:setupWorldBounds()
    self:setupWarps()
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

return M