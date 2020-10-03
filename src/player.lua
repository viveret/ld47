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
	return self
end

function M:draw()
    lg.rectangle("fill", self.body:getX(), self.body:getY(), 64, 64)
end

function M:update(dt)
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