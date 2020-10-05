IndoorsGameState = require "src.gamestates.Interior.IndoorsGameState"
local M = setmetatable({}, { __index = IndoorsGameState })
M.__index = M

-- TODO: adam

function M.new(gamestate)
    local self = setmetatable(IndoorsGameState.new(gamestate, 'Library', gamestate.graphics.Library), M)
	
    self.warps = {
        { -- Main door
            x = 45, y = 140,
            w = 10, h = 10,
            path = 'Overworld,96,97,x'
        }
    }
    self.renderWarps = true
    self.renderBounds = true

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