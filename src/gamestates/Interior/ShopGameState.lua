IndoorsGameState = require "src.gamestates.Interior.IndoorsGameState"
local M = setmetatable({}, { __index = IndoorsGameState })
M.__index = M

function M.new(gamestate)
    local self = setmetatable(IndoorsGameState.new(gamestate, 'Shop', gamestate.images.places.shop), M)
	
    self.warps = {
        { -- Main door
            x = 45, y = 68,
            w = 10, h = 10,
            path = 'Overworld,48,135,x'
        }
    }
    self.renderWarps = false
    self.renderBounds = false

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

    self:addStaticObjects({
        construction = StaticObject.new(self.world, 40, 40, self.gamestate.images.decor.construction),
    })
end

function M:switchTo(x, y)
    IndoorsGameState.switchTo(self, x, y)
end

function M.save()
end

return M