local M = {}
M.__index = M

--[[
    TODO/Nice to have:
        - variable animation speed
        - changes like flipping horizontally once in a while
]]

function M.new(world, spritesheet, x, y, frameWidth, frameHeight, frameCount, duration)
    local self = setmetatable({
        spritesheet = spritesheet,
        x = x,
        y = y,
        hasNotInteractedWith = false
    }, M)

    self.animation = animation.new(self.spritesheet, frameWidth, frameHeight, 0, frameCount, 0, duration or 1)
    self.body = lp.newBody(world, self.x, self.y, "static")
    self.shape = lp.newRectangleShape(frameWidth / 8, frameHeight / 8)
    self.fixture = lp.newFixture(self.body, self.shape)

    return self
end

function M:draw()
    self.animation:draw(self.body:getX(), self.body:getY())
    if self.inProximity or self.canInteractWith then
        lg.setColor(0, 1, 0)
        lg.rectangle('line', self.body:getX(), self.body:getY(), self.animation.frameWidth / 8, self.animation.frameHeight / 8)
        lg.setColor(1, 1, 1)
    end
end

function M:interact()
    print('Turned off / on beer sign')
    self.canInteractWith = false
    self.animation.pause = not self.animation.pause
    self.animation.currentTime = 0
end

function M:update(dt)
    self.animation:update(dt)
end

return M