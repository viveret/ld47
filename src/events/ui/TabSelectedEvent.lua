local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = BaseEvent })
M.__index = M

function M.new(id, tabGroup)
    if id == nil or id == '' then
        error('id cannot be empty or nil')
    end

    local self = setmetatable(lume.extend(BaseEvent.new(), {
        tabGroup = tabGroup,
        id = id,
    }), M)
    return self
end

function M:fireOn(el)
    self.tabGroup:selectTab(self.id)
    return true
end

return M