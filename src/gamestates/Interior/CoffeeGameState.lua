IndoorsGameState = require "src.gamestates.Interior.IndoorsGameState"
local M = setmetatable({}, { __index = IndoorsGameState })
M.__index = M

function M.new()
    local self = setmetatable(IndoorsGameState.new('Coffee', game.images.places.coffee), M)
    self.bgMusicName = "chill"
    
    self.warps = {
        { -- Main door
            x = 45, y = 69.5,
            w = 10, h = 10,
            path = 'Overworld,96,97,x'
        }
    }

    self:addWorldBounds({
        { -- subrooms
            x = 0, y = 0,
            w = 40, h = 65
        },
        { -- back wall
            x = 40, y = 0,
            w = 60, h = 10
        },
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

    self:addStaticObjects({
        freezer1 = AnimatedObject.new(self.world, 3.5, 5, game.animations.decor.freezer),
        freezer2 = AnimatedObject.new(self.world, 15.5, 5, game.animations.decor.freezer),
        freezer3 = AnimatedObject.new(self.world, 27.5, 5, game.animations.decor.freezer),
        backcounter = StaticObject.new(self.world, 70, 10, game.images.decor.back_counter),
        counter = StaticObject.new(self.world, 71, 35, game.images.decor.counter)
    })
end

function M:switchTo(x, y)
    IndoorsGameState.switchTo(self, x, y)
end

function M.save()
end


return M