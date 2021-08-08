local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = BaseEvent })
M.__index = M

function M.new()
    local self = setmetatable(BaseEvent.new(), M)
    self.type = "QuitGame"
    return self
end

function M:fireOn(gs)
    love.event.quit()
end

return M