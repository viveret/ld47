local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = BaseEvent })
M.__index = M

function M.new()
    return setmetatable(BaseEvent.new("LoadGame"), M)
end

function M:fireOn(gs)
    gs.warpTo('loadgame')
end

return M