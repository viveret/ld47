local super = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M:fireOn(gs)
	game.stateMgr:switchToNew(gameStates.DevConsole, nil, gamestateTransitions.DialogIn)
end

function M.new()
    return setmetatable(super.new("DevConsoleEvent"), M)
end

return M