local super = require "src.components.ui.GroupUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new(type)
    local self = setmetatable(super.new(type), M)
    self.title = "Graphics"
    self.justify = "left"
    self:addButton("test", GameOverEvent.new())
	return self
end

return M