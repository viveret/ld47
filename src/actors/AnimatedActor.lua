local BaseActor = require "src.actors.BaseActor"
local M = setmetatable({}, { __index = BaseActor })
M.__index = M

function M.new(world, name, gamestate, x, y, w, h, anims, callback)
    if anims == nil then
        error('anims must not be nil')
    end

    local self = setmetatable(BaseActor.new(
        world, name, gamestate, x, y, w, h, callback
    ), M)
    
    self.animations = anims
    self.animation = self.animations.still
    
    return self
end

function M:updateMovingTo(dt)
    local ret = BaseActor.updateMovingTo(self, dt)
    if ret then
        self.animation = self.animations.still
    end
    return ret
end

function M:update(dt)
    BaseActor.update(self, dt)
    self:updateAnimation(dt)
end

function M:updateAnimation(dt)
    local currentVx, currentVy = self.body:getLinearVelocity()
    if abs(currentVx) + abs(currentVy) < self.walkForce / 4 then
        self.animation = self.animations.still
    end

    if self.animation ~= nil then
        self.animation:update(dt)
    end
end

function M:draw()
    lg.push()
    lg.translate(floor(self.body:getX() - self.width), floor(self.body:getY() - self.height))
    self.animation:draw(0, 0)
    if self.inProximity or self.canInteractWith then
        lg.setColor(0, 1, 0)
        lg.rectangle('line', 0, 0, self.animation.frameWidth / 8, self.animation.frameHeight / 8)
        lg.setColor(1, 1, 1)
    end
    lg.pop()
end

return M