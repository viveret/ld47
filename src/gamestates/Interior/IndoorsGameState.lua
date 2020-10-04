PhysicalGameState = require "src.gamestates.PhysicalGameState"
local M = setmetatable({}, { __index = PhysicalGameState })
M.__index = M

local timeline = require "src.timeline"

function M.new(gamestate)
    local self = setmetatable(PhysicalGameState.new(gamestate, 'Indoors', gamestate.graphics.Overworld), M)
	-- self.field = field
	return self
end

function M:draw()
    PhysicalGameState.draw(self)
end

function M:update()
    PhysicalGameState.update(self)
end

function M:load()
    PhysicalGameState.load(self)
end

function M.save()
end


return M