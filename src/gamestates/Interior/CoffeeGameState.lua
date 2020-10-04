IndoorsGameState = require "src.gamestates.Interior.IndoorsGameState"
local M = setmetatable({}, { __index = IndoorsGameState })
M.__index = M

local timeline = require "src.timeline"

function M.new(gamestate)
    local self = setmetatable(IndoorsGameState.new(gamestate, 'Coffee', gamestate.graphics.Coffee), M)
	-- self.field = field
	return self
end

function M:draw()
    IndoorsGameState.draw(self)
end

function M:update()
    IndoorsGameState.update(self)
end

function M:load()
    IndoorsGameState.load(self)
end

function M.save()
end


return M