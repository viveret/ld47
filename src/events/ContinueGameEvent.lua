local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = BaseEvent })
M.__index = M

function M.new()
    return setmetatable(BaseEvent.new(), M)
end

function M:fireOn(gs)
    gs.continueGame()
end

return M