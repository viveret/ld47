PhysicalGameState = require "src.gamestates.PhysicalGameState"
local M = setmetatable({}, { __index = PhysicalGameState })
M.__index = M

local timeline = require "src.timeline"

function M.new(gamestate)
    local self = setmetatable(PhysicalGameState.new(gamestate, 'Overworld', gamestate.graphics.Overworld), M)
	-- self.field = field
	return self
end

function M:draw()
    PhysicalGameState.draw(self)
end

function M:update(dt)
    PhysicalGameState.update(self, dt)
end

function M:load()
    PhysicalGameState.load(self)
end

function M.save()
end


return M