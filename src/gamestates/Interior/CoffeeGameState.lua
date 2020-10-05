IndoorsGameState = require "src.gamestates.Interior.IndoorsGameState"
local M = setmetatable({}, { __index = IndoorsGameState })
M.__index = M

function M.new(gamestate)
    local self = setmetatable(IndoorsGameState.new(gamestate, 'Coffee', gamestate.images.places.coffee), M)
	
    self.warps = {
        { -- Main door
            x = 45, y = 69.5,
            w = 10, h = 10,
            path = 'Overworld,96,97,x'
        }
    }
    self.renderWarps = true
    self.renderBounds = true

    self:addWorldBounds({
        { -- subrooms
            x = 0, y = 0,
            w = 40, h = 65
        },
        { -- back wall
            x = 40, y = 0,
            w = 55, h = 10
        },
        { -- counters
            x = 40, y = 10,
            w = 55, h = 18
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

function M:load()
    IndoorsGameState.load(self)

    self.indoorObjects = {
        freezer1 = AnimatedObject.new(self.world, 3.5, 5, self.gamestate.animations.decor.freezer),
        freezer2 = AnimatedObject.new(self.world, 15.5, 5, self.gamestate.animations.decor.freezer),
        freezer3 = AnimatedObject.new(self.world, 27.5, 5, self.gamestate.animations.decor.freezer),
        backcounter = StaticObject.new(self.world, 56, 5, self.gamestate.images.decor.back_counter),
        counter = StaticObject.new(self.world, 46.5, 20, self.gamestate.images.decor.counter)
    }
end

function M:switchTo(x, y)
    IndoorsGameState.switchTo(self, x, y)
end

function M:activate()
    self.gamestate.ensureBGMusic("chill")
end

function M.save()
end


return M