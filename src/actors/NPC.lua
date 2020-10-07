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

return M