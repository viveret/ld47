PhysicalGameState = require "src.gamestates.PhysicalGameState"
local M = setmetatable({}, { __index = PhysicalGameState })
M.__index = M

function M.new(gamestate)
    local self = setmetatable(PhysicalGameState.new(gamestate, 'Swamp', gamestate.graphics.Swamp), M)
    self:addExteriorWorldBounds(4)
    self.renderBounds = true
    
    self.warps = {
        { -- Home
            x = 150, y = 85,
            w = 10, h = 25,
            path = 'Overworld,18,98,x'
        }
    }
    self.renderWarps = true
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
	-- self.gamestate.ensureBGMusic("overworld")
end

function M:save()
end


return M