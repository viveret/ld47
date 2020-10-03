local M = {}
M.__index = M

--[[
TODO:
    - location
]]

function M.new(world)
    local self = setmetatable({
        x = lg.getWidth() / 2,
        y = lg.getHeight() / 2,
        world = world,
	}, M)
    self.body = lp.newBody(world, self.x, self.y, "dynamic")
    self.shape = lp.newRectangleShape(64, 64)
    self.fixture = lp.newFixture(self.body, self.shape)
    self.time = 0
    self.duration = 1
	return self
end

function M:draw(gfx)
    
    local animation = {}
    animation.quads = {}

    for f = 0, 2 do
        y = 64 * f
        table.insert(animation.quads, lg.newQuad(0, y, 64, 64, gfx.Player:getDimensions()))
    end

    local sprite = math.floor(self.time / self.duration * #animation.quads) + 1
    lg.draw(gfx.Player, animation.quads[sprite], self.body:getX(), self.body:getY())

end

function M:update(dt)
    self.time = self.time + dt
    if self.time >= self.duration then
        self.time = self.time - self.duration
    end

    if lk.isDown('w') then
        if self.body:getY() > 0 then
            self.body:applyLinearImpulse(0, -50)
        else
            self.body:setLinearVelocity(0, 0)
        end
    elseif lk.isDown('a') then
        if self.body:getX() > 0 then
            self.body:applyLinearImpulse(-50, 0)
        else
            self.body:setLinearVelocity(0, 0)
        end
    elseif lk.isDown('s') then
        if self.body:getY() < lg.getHeight() - 64 then
            self.body:applyLinearImpulse(0, 50)
        else
            self.body:setLinearVelocity(0, 0)
        end
    elseif lk.isDown('d') then
        if self.body:getX() < lg.getWidth() - 64 then
            self.body:applyLinearImpulse(50, 0)
        else
            self.body:setLinearVelocity(0, 0)
        end
    else
        self.body:setLinearVelocity(0, 0)
    end

end

return M