IndoorsGameState = require "src.gamestates.Interior.IndoorsGameState"
local M = setmetatable({}, { __index = IndoorsGameState })
M.__index = M

function M.new(gamestate)
    local self = setmetatable(IndoorsGameState.new(gamestate, 'Antiques', gamestate.graphics.Antiques), M)
    
    self:addWorldBounds({
        { -- clothing racks
            x = 68, y = 47,
            w = 2, h = 23
        },
        { -- urns and such
            x = 63, y = 25,
            w = 4, h = 22
        },
        { -- piano
            x = 52, y = 0,
            w = 14, h = 25
        },
        { -- counter
            x = 9, y = 26,
            w = 28, h = 1
        }
    })

    self.warps = {
        { -- Main door
            x = 45, y = 68,
            w = 10, h = 10,
            path = 'Overworld,66,97,x'
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

    if self.shopkeeper == nil then
        self.shopkeeper = ActorSpawnEvent.new("Antiques", "AntiqueSeller", "Mary", 28, 20)
        self.gamestate.fire(self.shopkeeper)
    end

    -- todo: time of day check
    self.greeting = ActorTextEvent.new("Mary", "I've collected many things over the years. Please, browse at your leisure.")
end

function M.save()
end


return M