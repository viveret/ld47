local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = BaseEvent })
M.__index = M

function M.new()
    local self = setmetatable(BaseEvent.new(), M)
    self.type = "Inventory"
    return self
end

function M:fireOn(gs)
    game.warpTo('inventory', game.stackTransitions.Regular)
    return true
end

return M