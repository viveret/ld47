local super = require "src.gamestates.Physical.PhysicalGameState"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new()
    local self = setmetatable(PhysicalGameState.new('Cemetery', game.images.places.cemetery), M)
    self.bgMusicName = "dreamSequence"
    self:addExteriorWorldBounds(8)
    
    self:addWorldBounds({
        { -- Building
            x = 130, y = 0,
            w = 80, h = 50
        },
    })
    
    self.warps = {
        { -- Gate to overworld
            x = 88, y = 133,
            w = 25, h = 10,
            path = 'Overworld,100,30,x'
        }
    }
    
	return self
end

function M:setupPhysics()
    super.setupPhysics(self)

    local rows = 5
    local cols = 6
    local xoff = 15
    local yoff = 15

    for r = 0,rows,1 do
        for c = 0,cols,1 do
            local x = xoff + c * (self:getWidth() - 100) / cols + random(1, 2)
            local y = yoff + r * (self:getHeight() - 70) / rows + random(1, 2)

            table.insert(self.staticObjects, StaticObject.new(self.world, x, y, game.images.places.cemetery['grave' .. random(1,8)]))

            if random() < 0.05 then
                table.insert(self.staticObjects, StaticObject.new(self.world, x, y + 8, game.images.places.cemetery.bones))
            elseif random() < 0.1 then
                table.insert(self.staticObjects, StaticObject.new(self.world, x, y + 8, game.images.places.cemetery.dugUp))
            elseif random() < 0.1 then
                table.insert(self.staticObjects, StaticObject.new(self.world, x, y + 8, game.images.places.cemetery.fresh))
            end
        end
    end
end

return M