local super = require "src.components.ui.BaseUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new(distance)
    local self = setmetatable(lume.extend(super.new('space'), {
        h = distance,
    }), M)
	return self
end

function M:draw()
end

return M