PhysicalGameState = require "src.gamestates.PhysicalGameState"
local M = setmetatable({}, { __index = PhysicalGameState })
M.__index = M

local timeline = require "src.timeline"

function M.new(gamestate)
    local self = setmetatable(PhysicalGameState.new(gamestate, 'Overworld', gamestate.graphics.Overworld), M)
    self.bounds = {
        { -- Top
            x = 0, y = -2,
            w = self.getWidth(), h = 4
        },
        { -- Bottom
            x = 0, y = self.getHeight() - 4,
            w = self.getWidth(), h = 4
        },
        { -- Left
            x = -2, y = -4,
            w = 4, h = self.getHeight() + 4
        },
        { -- Right
            x = self.getWidth() - 4, y = -4,
            w = 4, h = self.getHeight() + 4
        },
        { -- Building 1
            x = 0, y = 0,
            w = 54, h = 38
        }
    }
    self.renderBounds = true
	return self
end

function M:draw()
    PhysicalGameState.draw(self)
end

function M:drawInWorldView()
    PhysicalGameState.drawInWorldView(self)
end

function M:update(dt)
    PhysicalGameState.update(self, dt)
end

function M:load(x, y)
    PhysicalGameState.load(self, x, y)

	self.gamestate.ensureBGMusic("overworld")
end

function M:save()
end


return M