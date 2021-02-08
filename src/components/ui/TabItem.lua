local super = require "src.components.ui.GroupUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new()
    local self = setmetatable(super.new('tab-item'), M)

	return self
end

return M