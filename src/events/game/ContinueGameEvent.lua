local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = BaseEvent })
M.__index = M

function M.new()
    return setmetatable(BaseEvent.new("ContinueGame"), M)
end

function M:fireOn(gs)
    local lastType = game.current().type
    
    if lastType == 'GameOver' then
        game.clear()
        game.init()
    else
        game.pop(game.stackTransitions.Regular)
    end
end

return M