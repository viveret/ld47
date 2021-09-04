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
        game.popToInclusive(self.popToInclusive, game.stackTransitions.Game)
    elseif self.popToExclusive then
        game.popToExclusive(self.popToExclusive, game.stackTransitions.Game)
    else
        game.popTop(game.stackTransitions.Game)
    end
end

return M