local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = BaseEvent })
M.__index = M

function M.new()
    return setmetatable(BaseEvent.new("QuickSave"), M)
end

function M:fireOn()
    game.saves:quicksave(self.autosave or false)
end

return M