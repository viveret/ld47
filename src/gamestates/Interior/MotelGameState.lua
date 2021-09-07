local super = require "src.gamestates.Physical.IndoorsGameState"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new()
    local self = setmetatable(super.new('Motel', game.images.places.motel), M)
	
    self.warps = {
        { -- Main door
            x = 45, y = 68,
            w = 10, h = 10,
            path = 'Overworld,30,40,x'
        }
    }
    
    local left, right, up, down = self:detectWorldBounds()
    local bottomLeft, bottomRight = self:splitBoundHorizontal(down, self.warps[1])
    self:addWorldBounds({
        left, right, up, bottomLeft, bottomRight,
        { -- table
            x = 80, y = 45,
            w = 20, h = 13
        },
    })

	return self
end

return M