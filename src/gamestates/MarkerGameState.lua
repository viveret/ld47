local super = require "src.gamestates.BaseGameState"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new(scene)
    local self = setmetatable(lume.extend({}, super.new(scene)), M)
	return self
end

function M:quicksave()
end

function M:quickload(state)
end

function M:reload()
end

return M