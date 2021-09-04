IndoorsGameState = require "src.gamestates.Physical.IndoorsGameState"
local M = setmetatable({}, { __index = IndoorsGameState })
M.__index = M
M.__file = __file__()

function M.new()
    local self = setmetatable(IndoorsGameState.new('Antiques', game.images.places.antiques), M)
    
    self.warps = {
        { -- Main door
            x = 45, y = 68,
            w = 10, h = 10,
            path = 'Overworld,66,97,x'
        }
    }

    local left, right, up, down = self:detectWorldBounds()
    local bottomLeft, bottomRight = self:splitBoundHorizontal(down, self.warps[1])
    self:addWorldBounds({
        left, right, up, bottomLeft, bottomRight,
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

	return self
end

function M:load(x, y)
    IndoorsGameState.load(self, x, y)
    self:showGreeting()
end

function M:switchTo(x, y)
    IndoorsGameState.switchTo(self, x, y)

    if self.shopkeeper == nil then
        self.shopkeeper = events.actor.ActorSpawnEvent.new("Antiques", "AntiqueSeller", "mary", 28, 20)
        game.fire(self.shopkeeper):next(function() self:showGreeting() end)
    else
        self:showGreeting()
    end
end

--function M:

function M:showGreeting()
    -- todo: time of day check
    self.greeting = events.actor.ActorTextEvent.new("Antiques", "mary", "I've collected many things over the years. Please, browse at your leisure.")

    if self.greeting ~= nil then
        game.fire(self.greeting)
        self.greeting = nil
    end
end

function M.save()
end


return M