IndoorsGameState = require "src.gamestates.Physical.IndoorsGameState"
local M = setmetatable({}, { __index = IndoorsGameState })
M.__index = M
M.__file = __file__()

function M.new()
    local self = setmetatable(IndoorsGameState.new('Motel', game.images.places.motel), M)
	
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

function M:draw()
    IndoorsGameState.draw(self)
end

function M:update(dt)
    IndoorsGameState.update(self, dt)
end

function M:load(x, y)
    IndoorsGameState.load(self, x, y)
end

function M:switchTo(x, y)
    IndoorsGameState.switchTo(self, x, y)
end

function M.save()
end

return M