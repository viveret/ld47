IndoorsGameState = require "src.gamestates.Physical.IndoorsGameState"
local M = setmetatable({}, { __index = IndoorsGameState })
M.__index = M
M.__file = __file__()

function M.new()
    local self = setmetatable(IndoorsGameState.new('Library', game.images.places.library), M)

    self.warps = {
        { -- Main door
            x = 45, y = 74,
            w = 10, h = 10,
            path = 'Overworld,131,97,x'
        }
    }
	
    local left, right, up, down = self:detectWorldBounds()
    up.h = 8
    local bottomLeft, bottomRight = self:splitBoundHorizontal(down, self.warps[1])
    self:addWorldBounds({
        left, right, up,
        bottomLeft, bottomRight,
        { -- Room divider top
            x = 60, y = 0,
            w = 5, h = 30
        },
        { -- Room divider bottom
            x = 60, y = 48,
            w = 5, h = 30
        },
        { -- table
            x = 11, y = 39,
            w = 26, h = 13
        }
    })

	return self
end

function M:draw()
    IndoorsGameState.draw(self)
end

function M:update(dt)
    IndoorsGameState.update(self, dt)
end

function M:load(x, y)
    IndoorsGameState.load(self, x, y)

    self:addStaticObjects({
        ropes = StaticObject.new(self.world, 63, 39, game.images.decor.ropes),
        tome = StaticObject.new(self.world, 80, 40, game.images.decor.tome)
    })
end

function M:switchTo(x, y)
    IndoorsGameState.switchTo(self, x, y)

    if self.librarian == nil then
        self.librarian = events.actor.ActorSpawnEvent.new("Library", "Librarian", "librarian", 23, 46)
        game.fire(self.librarian)
    end
end

function M.save()
end

return M