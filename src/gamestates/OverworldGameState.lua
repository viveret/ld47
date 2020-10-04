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
            x = 0, y = self.getHeight() - 2,
            w = self.getWidth(), h = 4
        },
        { -- Left
            x = -2, y = -4,
            w = 4, h = self.getHeight() + 4
        },
        { -- Right
            x = self.getWidth() - 2, y = -4,
            w = 4, h = self.getHeight() + 4
        },
        { -- Building 1a
            x = 0, y = 2,
            w = 32, h = 15
        },
        { -- Building 1b
            x = 30, y = 15,
            w = 18, h = 6
        },
        { -- Cemetary left
            x = 45, y = 2,
            w = 30, h = 4
        },
        { -- Cemetary right
            x = 45 + 35 + 10, y = 2,
            w = 30, h = 4
        },
        { -- Building 2
            x = 130, y = 2,
            w = 28, h = 20
        },
        { -- Building 3
            x = 125, y = 40,
            w = 35, h = 23
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