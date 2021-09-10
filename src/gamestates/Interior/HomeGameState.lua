local super = require "src.gamestates.Physical.IndoorsGameState"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new()
    local self = setmetatable(super.new('Home', game.images.places.home), M)
    self.bgMusicName = "chill"
    
    self.warps = {
        { -- Main door
            x = 45, y = 75,
            w = 10, h = 10,
            path = 'Overworld,175,130,x'
        }
    }

    local left, right, up, down = self:detectWorldBounds()
    local bottomLeft, bottomRight = self:splitBoundHorizontal(down, self.warps[1])
    self:addWorldBounds({
        left, right, up,
        bottomLeft, bottomRight,
        { -- table
            x = 80, y = 21.5,
            w = 20, h = 13
        },
    })

	return self
end

function M:setupPhysics(args)
    super.setupPhysics(self, args)

    self:addWaitableObject(10, 20, game.animations.decor.beer_sign, true, 'Sleep')
    self:addLightSwitch(30, 10, game.images.decor.tome)
    self:addInteractDialog(82, 25, game.images.decor.radio, false, 'Listen to Radio', 'Radio', 'Beep boop bop')
end

return M