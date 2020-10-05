IndoorsGameState = require "src.gamestates.Interior.IndoorsGameState"
local M = setmetatable({}, { __index = IndoorsGameState })
M.__index = M

-- TODO: adam

function M.new(gamestate)
    local self = setmetatable(IndoorsGameState.new(gamestate, 'Library', gamestate.images.places.library), M)
	
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
            x = 55, y = 0,
            w = 20, h = 150
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

    self.indoorObjects = {
        ropes = StaticObject.new(self.world, self.gamestate.images.decor.ropes, 50, 32),
        tome = StaticObject.new(self.world, self.gamestate.images.decor.tome, 70, 34)
    }
end

function M:switchTo(x, y)
    IndoorsGameState.switchTo(self, x, y)

    if self.librarian == nil then
        self.librarian = ActorSpawnEvent.new("Library", "Librarian", "librarian", 23, 46)
        self.gamestate.fire(self.librarian)
    end
end

function M.save()
end


return M