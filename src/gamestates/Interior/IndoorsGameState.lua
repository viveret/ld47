PhysicalGameState = require "src.gamestates.PhysicalGameState"
local M = setmetatable({}, { __index = PhysicalGameState })
M.__index = M

function M.new(gamestate, name, graphics)
    local self = setmetatable(PhysicalGameState.new(gamestate, name, graphics), M)
	-- self.field = field
    self:addExteriorWorldBounds()
	return self
end

function M:draw()
    PhysicalGameState.draw(self)
end

function M:update(dt)
    PhysicalGameState.update(self, dt)
end

function M:load(x, y)
    PhysicalGameState.load(self, x, y)
end

function M.save()
end


return M