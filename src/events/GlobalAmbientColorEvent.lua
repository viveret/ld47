local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = BaseEvent })
M.__index = M

function M.new(r, g, b)
    local self = setmetatable(BaseEvent.new(), M)
    self.r = r;
    self.g = g;
    self.b = b;
    return self
end

function M:fireOn(gs)
    gs.saveData.globalAmbientColor = self
end

return M