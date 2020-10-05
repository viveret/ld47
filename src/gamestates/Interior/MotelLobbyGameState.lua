IndoorsGameState = require "src.gamestates.Interior.IndoorsGameState"
local M = setmetatable({}, { __index = IndoorsGameState })
M.__index = M

function M.new(gamestate)
    local self = setmetatable(IndoorsGameState.new(gamestate, 'MotelLobby', gamestate.graphics.MotelLobby), M)
    
    self:addWorldBounds({
        { -- Left
            x = 15, y = 8,
            w = 4, h = 80
        },
        { -- Top
            x = 0, y = 20,
            w = 100, h = 4
        },
        { -- Right
            x = 85, y = 0,
            w = 4, h = 80
        },
        { -- Chairs Right
            x = 80, y = 45,
            w = 20, h = 13
        },
        { -- Chairs Bottom Right
            x = 60, y = 60,
            w = 20, h = 13
        },
        { -- file cabinet
            x = 62, y = 24,
            w = 22, h = 5
        },
        { -- table
            x = 26, y = 36,
            w = 23, h = 1
        }
    })
	
    self.warps = {
        { -- Main door
            x = 45, y = 68,
            w = 10, h = 10,
            path = 'Overworld,30,40,x'
        }
    }
    self.renderWarps = true
    self.renderBounds = true

	return self
end

function M:draw()
    IndoorsGameState.draw(self)
    if self.greeting ~= nil then
        self.gamestate.fire(self.greeting)
        self.greeting = nil
    end
end

function M:update(dt)
    IndoorsGameState.update(self, dt)
end

function M:load()
    IndoorsGameState.load(self)
end

function M:switchTo(x, y)
    IndoorsGameState.switchTo(self, x, y)

    if self.guy == nil then
        self.guy = ActorSpawnEvent.new("MotelLobby", "MotelGuy", "MotelGuy", 37, 29)
        self.gamestate.fire(self.guy)
    end

    -- todo: time of day check
    self.greeting = ActorTextEvent.new("MotelLobby", "MotelGuy", "'sup. Are you here for the convention?")
end

function M.save()
end


return M