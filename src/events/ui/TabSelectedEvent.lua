local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = BaseEvent })
M.__index = M

function M.new(id, tabGroup)
    local self = setmetatable(BaseEvent.new(), M)
    self.tabGroup = tabGroup
    return self
end

function M:fireOn()
    self.tabGroup:selectTab(self.id)
end

return M