IndoorsGameState = require "src.gamestates.Interior.IndoorsGameState"
local M = setmetatable({}, { __index = IndoorsGameState })
M.__index = M

-- TODO: adam

function M.new(gamestate)
    local self = setmetatable(IndoorsGameState.new(gamestate, 'Library', gamestate.images.places.library), M)
	
    self:addWorldBounds({
        { -- Top
            x = 0, y = 17,
            w = self:getWidth(), h = 4
        },
        { -- Room divider top
            x = 60, y = 0,
            w = 5, h = 30
        },
        { -- Room divider bottom
            x = 60, y = 48,
            w = 5, h = 30
        },
        { -- table
            x = 11, y = 42,
            w = 26, h = 10
        }
    })

    self.warps = {
        { -- Main door
            x = 45, y = 70,
            w = 10, h = 10,
            path = 'Overworld,131,97,x'
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
        ropes = StaticObject.new(self.world, 63, 39, self.gamestate.images.decor.ropes),
        tome = StaticObject.new(self.world, 80, 40, self.gamestate.images.decor.tome)
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