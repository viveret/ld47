local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = BaseEvent })
M.__index = M
M.__file = __file__()

function M.new(options)
    local self = setmetatable(lume.extend(BaseEvent.new(), options), M)
    self.type = "Pop"
    return self
end

function M:fireOn()
    if self.popToInclusive then
        game.stateMgr:popToInclusive(self.popToInclusive, gamestateTransitions.Game)
    elseif self.popToExclusive then
        game.stateMgr:popToExclusive(self.popToExclusive, gamestateTransitions.Game)
    else
        game.stateMgr:popTop(gamestateTransitions.Game)
    end
end

return M