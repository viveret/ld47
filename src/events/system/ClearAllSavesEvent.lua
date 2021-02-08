local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = BaseEvent })
M.__index = M

function M.new(saveData)
    return setmetatable(lume.extend(BaseEvent.new("ClearAllSaves"), saveData), M)
end

function M:fireOn(gs)
    game.saves:clearAll()
end

return M