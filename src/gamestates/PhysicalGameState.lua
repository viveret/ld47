local M = setmetatable({}, { __index = TimedGameState })
M.__index = M

function M.new(gamestate, name, bg)
    local self = setmetatable(TimedGameState.new(gamestate, name), M)
    self.background = bg
    self.world = lp.newWorld(0, 0, true)
    self.player = nil
    self.cameras = { }
    self:pushCamera(Camera.new())
	return self
end

function M:draw()
    -- TimedGameState.draw(self)
    lg.push()
    if self:currentCamera() ~= nil then
        self:currentCamera():draw()
    end

    if self.gamestate ~= nil then
        self.gamestate.graphics.drawObject(self.background, 0, 0, 16 * 16, 12 * 16)
        self.player:draw()
    end

    lg.pop()

    local x = self:currentCamera().x
    local y = self:currentCamera().y
    lg.print("You are at " .. x .. ", " .. y .. " in " .. self.name, 0, 0)
end

function M:update(dt)
    TimedGameState.update(self)
    self.world:update(dt)
    self.player:update(dt)
    self:currentCamera():update(dt)
end

function M:load(x, y)
    TimedGameState.load(self)
    self.player = player.new(self.world, self.gamestate.graphics, x, y)
    self:pushCamera(Camera.new(self.player.body))
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


return M