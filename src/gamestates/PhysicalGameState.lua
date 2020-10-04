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
    self.toast = nil

	return self
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
end

function M:draw()
    -- TimedGameState.draw(self)
    lg.push()
    self:drawInWorldView()
    lg.pop()

    local x = self.player.body:getX()
    local y = self.player.body:getY()

    toast.draw()

    lg.print("You are at " .. x .. ", " .. y .. " in " .. self.name, 0, 0)
    lg.print("Camera is at " .. self:currentCamera().x .. ", " .. self:currentCamera().y, 0, 16)
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
        local body = lp.newBody(self.world, bound.x + bound.w / 2, bound.y + bound.h / 2, "static")
        local shape = lp.newRectangleShape(bound.w, bound.h)
        lp.newFixture(body, shape)
    end
end

return M