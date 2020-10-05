local AnimatedActor = require "src.actors.AnimatedActor"
local M = setmetatable({}, { __index = AnimatedActor })
M.__index = M

function M.new(world, name, gamestate, x, y, w, h, anims, callback)
    local self = setmetatable(AnimatedActor.new(
        world, name, gamestate, x, y, w, h, anims, callback
    ), M)
    
    self.type = "npc"
    
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

return M