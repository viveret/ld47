PhysicalGameState = require "src.gamestates.PhysicalGameState"
local M = setmetatable({}, { __index = PhysicalGameState })
M.__index = M

function M.new(gamestate)
    local self = setmetatable(PhysicalGameState.new(gamestate, 'Swamp', gamestate.images.places.swamp), M)
    self.bgMusicName = "nightSpooky"
    self:addExteriorWorldBounds(4)
    self.renderBounds = false
    
    self.warps = {
        { -- Home
            x = 193, y = 105,
            w = 10, h = 30,
            path = 'Overworld,18,120,x'
        }
    }
    self.renderWarps = false
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

function M:load()
    PhysicalGameState.load(self)
end

function M:switchTo(x, y)
    PhysicalGameState.switchTo(self, x, y)
end

function M:save()
end

return M