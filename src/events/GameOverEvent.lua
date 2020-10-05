local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = BaseEvent })
M.__index = M

function M.new()
    return setmetatable(BaseEvent.new(), M)
end

function M:fireOn(gs)
    if gs.hasFlag("ServedAllCustomers") and gs.hasFlag("has-reserved-room") and gs.hasFlag("SawSickCultist") and gs.hasFlag("HearMirror") then
        gs.setFlag("defeated-cultists")
    end

    gs.gameOver()
end

return M