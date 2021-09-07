local M = {}
M.__index = M
M.__file = __file__()

local GameSaveSlotStateValue = require "src.components.system.GameSaveSlotStateValue"

function M.new(path, id)
    local self = setmetatable({
        path = path,
        id = id,
    }, M)
    lfs.createDirectory(path)
    return self
end

function M:computeHash()
end

function M:readHash()
end

function M:getEntry(key)
    return GameSaveSlotStateValue.new(key, self)
end

return M