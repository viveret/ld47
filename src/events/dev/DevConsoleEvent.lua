local super = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M:fireOn(gs)
	local consoleWindow = gameStates.DevConsole.new()
	game.stateMgr:push(consoleWindow, nil, gamestateTransitions.DialogIn)
end

function M.new()
    local self = setmetatable(super.new("DevConsoleEvent"), M)
	return self
end

return M