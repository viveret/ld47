PhysicalGameState = require "src.gamestates.Physical.PhysicalGameState"
local M = setmetatable({}, { __index = PhysicalGameState })
M.__index = M
M.__file = __file__()

function M.new()
    local self = setmetatable(PhysicalGameState.new('Swamp', game.images.places.swamp), M)
    self.bgMusicName = "nightSpooky"
    self:addExteriorWorldBounds(4)
    
    self.warps = {
        { -- Home
            x = 193, y = 105,
            w = 10, h = 30,
            path = 'Overworld,18,120,x'
        }
    }
	return self
end

function M:draw()
    PhysicalGameState.draw(self)
end

function M:drawInWorldView()
    PhysicalGameState.drawInWorldView(self)
end

function M:update(dt)
    PhysicalGameState.update(self, dt)
end

function M:load(x, y)
    PhysicalGameState.load(self, x, y)
end

function M:switchTo(x, y)
    PhysicalGameState.switchTo(self, x, y)
end

function M:save()
end

return M