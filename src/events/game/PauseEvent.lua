local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = BaseEvent })
M.__index = M

function M.new()
    local self = setmetatable(BaseEvent.new(), M)
    self.type = "Pause"
    return self
end

function M:fireOn(gs)
    game.warpTo('pause', gamestateTransitions.Regular)
    return true
end

return M