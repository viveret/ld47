local super = require "src.gamestates.Physical.PhysicalGameState"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new()
    local self = setmetatable(super.new('Swamp', game.images.places.swamp), M)
    self.bgMusicName = "nightSpooky"
    self:addExteriorWorldBounds(4)
    
    self.warps = {
        { -- Home
            x = 193, y = 105,
            w = 10, h = 30,
            path = 'Overworld,18,120,x'
        }
    }
    
	return self
end

return M