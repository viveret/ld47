local M = {}
M.__index = M

--[[
    TODO/Nice to have:
        - variable animation speed
        - changes like flipping horizontally once in a while
]]

function M.new(world, x, y, anim, onInteract)
    local self = setmetatable({
        x = x,
        y = y,
        hasNotInteractedWith = false,
        onInteract = onInteract,
        animation = anim,
    }, M)
    
    self.body = lp.newBody(world, self.x, self.y, "static")
    self.shape = lp.newRectangleShape(self.animation.frameWidth / 8, self.animation.frameHeight / 8)
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

function M:interact(player)
    if self.onInteract ~= nil then
        self.onInteract(self, player)
    else
        self.animation.pause = not self.animation.pause
        self.animation.currentTime = self.animation.duration * 0.5
    end
end

function M:update(dt)
    self.animation:update(dt)
end

return M