local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = BaseEvent })
M.__index = M

function M.new()
    return setmetatable(BaseEvent.new("ContinueGame"), M)
end

function M:fireOn(gs)
    local lastType = game.stateMgr:current().type
    
    if lastType == 'GameOver' then
        game.clear()
        game.init()
    else
        game.stateMgr:popTop(gamestateTransitions.Regular)
    end
    return true
end

return M