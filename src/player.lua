local M = {}
M.__index = M

--[[
TODO:
    - location
]]

local animation = require "src.animation"

function M.new(world, gfx)
    local self = setmetatable({
        x = lg.getWidth() / 2,
        y = lg.getHeight() / 2,
        world = world,
	}, M)
    self.body = lp.newBody(world, self.x, self.y, "dynamic")
    self.shape = lp.newRectangleShape(64, 64)
    self.fixture = lp.newFixture(self.body, self.shape)
    self.idleAnimation = animation.new(gfx.Player, 0, 3, 0, 1)
	return self
end

function M:draw()
    self.idleAnimation:draw(self.body:getX(), self.body:getY())
end

function M:update(dt)
    self.idleAnimation:update(dt)

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