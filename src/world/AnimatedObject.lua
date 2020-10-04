local M = {}
M.__index = M

--[[
    TODO/Nice to have:
        - variable animation speed
        - changes like flipping horizontally once in a while
]]

function M.new(world, spritesheet, x, y, frameWidth, frameHeight, frameCount)
    local self = setmetatable({
        spritesheet = spritesheet,
        x = x,
        y = y
    }, M)

    self.animation = animation.new(self.spritesheet, frameWidth, frameHeight, 0, frameCount, 0, 1)
    self.body = lp.newBody(world, self.x, self.y, "static")
    self.shape = lp.newRectangleShape(frameWidth / 8, frameHeight / 8)
    self.fixture = lp.newFixture(self.body, self.shape)

    return self
end

function M:draw()
    self.animation:draw(self.body:getX(), self.body:getY())
end

function M:update(dt)
    self.animation:update(dt)
end

return M