local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = BaseEvent })
M.__index = M

function M.new()
    local self = setmetatable(BaseEvent.new(), M)
    self.type = "NewGame"
    return self
end

function M:fireOn(gs)
    game.saveData = {
        dirty = true
    }
    game.warpTo('start', gamestateTransitions.FadeInOut)
    return true
end

return M