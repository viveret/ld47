local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = BaseEvent })
M.__index = M

function M.new()
    return setmetatable(BaseEvent.new("QuickLoad"), M)
end

function M:fireOn()
    game.saves:quickload()
end

return M