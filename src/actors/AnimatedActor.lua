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
    self.animation:update(dt)
end

function M:draw()
    if self.animation == nil then
        self.animation = self.animations.idle
    end

    lg.push()
    self.animation:draw(self.body:getX() - self.width, self.body:getY() - self.height)
    lg.pop()
end

return M