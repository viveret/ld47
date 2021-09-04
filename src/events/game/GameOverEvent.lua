local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = BaseEvent })
M.__index = M

function M.new()
    local self = setmetatable(BaseEvent.new(), M)
    self.type = "GameOver"
    return self
end

function M:fireOn(gs)
    if game.hasFlag("ServedAllCustomers") and game.hasFlag("has-reserved-room") and game.hasFlag("SawSickCultist") and game.hasFlag("HearMirror") then
        game.setFlag("defeated-cultists")
    end

    game.warpTo('gameover')
    return true
end

return M