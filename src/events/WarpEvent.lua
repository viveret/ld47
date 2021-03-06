local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = BaseEvent })
M.__index = M

function M.new(path) 
    if path == nil or path == '' then
        error('path cannot be nil or empty')
    end
    local self = setmetatable(BaseEvent.new(), M)
    self.path = path;
    return self
end

function M:fireOn(gs)
    gs.warpTo(self.path)
end

return M