PhysicalGameState = require "src.gamestates.PhysicalGameState"
local M = setmetatable({}, { __index = PhysicalGameState })
M.__index = M

function M.new(gamestate)
    local self = setmetatable(PhysicalGameState.new(gamestate, 'Cemetery', gamestate.graphics.Cemetery), M)
    self:addExteriorWorldBounds(8)
    self.renderBounds = true
    
    self.warps = {
        { -- Home
            x = 88, y = 130,
            w = 30, h = 10,
            path = 'Overworld,85,30,x'
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