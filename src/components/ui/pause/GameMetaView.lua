local super = require "src.components.ui.GroupUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new(type)
    local self = setmetatable(super.new(type), M)
    self.title = "Meta"
    self.justify = "left"
    self:addButton('Game Stats', events.WarpEvent.new('GameStats'))
	return self
end

return M