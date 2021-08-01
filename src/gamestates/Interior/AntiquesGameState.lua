IndoorsGameState = require "src.gamestates.Interior.IndoorsGameState"
local M = setmetatable({}, { __index = IndoorsGameState })
M.__index = M

function M.new()
    local self = setmetatable(IndoorsGameState.new('Antiques', game.images.places.antiques), M)
    
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

	return self
end

function M:draw()
    IndoorsGameState.draw(self)
    if self.greeting ~= nil then
        game.fire(self.greeting)
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
        self.shopkeeper = events.actor.ActorSpawnEvent.new("Antiques", "AntiqueSeller", "mary", 28, 20)
        game.fire(self.shopkeeper)
    end

    -- todo: time of day check
    self.greeting = events.actor.ActorTextEvent.new("Antiques", "mary", "I've collected many things over the years. Please, browse at your leisure.")
end

function M.save()
end


return M