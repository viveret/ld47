local super = require "src.gamestates.Physical.IndoorsGameState"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new()
    local self = setmetatable(super.new('Doctor', game.images.places.doctor), M)
	
    self.warps = {
        { -- Main door
            x = 45, y = 75,
            w = 10, h = 10,
            path = 'Overworld,176,40,x'
        }
    }

    local left, right, up, down = self:detectWorldBounds()
    local bottomLeft, bottomRight = self:splitBoundHorizontal(down, self.warps[1])
    self:addWorldBounds({
        left, right, up,
        bottomLeft, bottomRight,
    })

	return self
end

function M:setupPhysics(args)
    super.setupPhysics(self, args)

    self:addStaticObjects({
        construction = StaticObject.new(self.world, 40, 40, game.images.decor.construction),
    })
end

return M