local super = require "src.gamestates.Physical.IndoorsGameState"
local M = setmetatable({}, { __index = IndoorsGameState })
M.__index = M
M.__file = __file__()

local AnimatedObject = require "src.world.AnimatedObject"

function M.new()
    local self = setmetatable(super.new('Coffee', game.images.places.coffee), M)
    self.bgMusicName = "chill"
    
    self.warps = {
        { -- Main door
            x = 45, y = 75,
            w = 10, h = 10,
            path = 'Overworld,96,97,x'
        }
    }

    local left, right, up, down = self:detectWorldBounds()
    local bottomLeft, bottomRight = self:splitBoundHorizontal(down, self.warps[1])
    self:addWorldBounds({
        left, right, up,
        bottomLeft, bottomRight,
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
    super.draw(self)
end

function M:update(dt)
    super.update(self, dt)
end

function M:load(x, y)
    super.load(self, x, y)

    self:addStaticObjects({
        freezer1 = AnimatedObject.new(self.world, 3.5, 5, game.animations.decor.freezer),
        freezer2 = AnimatedObject.new(self.world, 15.5, 5, game.animations.decor.freezer),
        freezer3 = AnimatedObject.new(self.world, 27.5, 5, game.animations.decor.freezer),
        backcounter = StaticObject.new(self.world, 70, 10, game.images.decor.back_counter),
        counter = StaticObject.new(self.world, 71, 35, game.images.decor.counter)
    })
end

function M:switchTo(x, y)
    super.switchTo(self, x, y)
end

function M.save()
end


return M