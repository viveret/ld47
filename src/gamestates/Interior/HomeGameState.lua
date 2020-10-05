IndoorsGameState = require "src.gamestates.Interior.IndoorsGameState"
local M = setmetatable({}, { __index = IndoorsGameState })
M.__index = M

-- TODO viv

function M.new(gamestate)
    local self = setmetatable(IndoorsGameState.new(gamestate, 'Home', gamestate.graphics.Home), M)
    
    self:addWorldBounds({
        { -- Left
            x = 15, y = 8,
            w = 4, h = 80
        },
        { -- Top
            x = 0, y = 12,
            w = 100, h = 4
        },
        { -- Right
            x = 85, y = 0,
            w = 4, h = 80
        },
        { -- Table
            x = 80, y = 21.5,
            w = 20, h = 13
        },
    })
    
    self.warps = {
        { -- Main door
            x = 45, y = 66,
            w = 10, h = 10,
            path = 'Overworld,175,130,x'
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

function M:activated()
    self.gamestate.ensureBGMusic("dreamSequence")
end

function M.save()
end


return M