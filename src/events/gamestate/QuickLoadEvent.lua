local super = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new()
    return setmetatable(super.new("QuickLoad"), M)
end

function M:fireOn()
    game.quickload()
end

return M