IndoorsGameState = require "src.gamestates.Interior.IndoorsGameState"
local M = setmetatable({}, { __index = IndoorsGameState })
M.__index = M

function M.new()
    local self = setmetatable(IndoorsGameState.new('Bar', game.images.places.bar), M)
	
    self.warps = {
        { -- Main door
            x = 45, y = 68,
            w = 10, h = 10,
            path = 'Overworld,30,100,x'
        }
    }

    self:addWorldBounds({
        { -- Divider
            x = 0, y = 30,
            w = self:getWidth(), h = 4
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

function M:load()
    IndoorsGameState.load(self)
end

function M:switchTo(x, y)
    IndoorsGameState.switchTo(self, x, y)
end

function M.save()
end


return M