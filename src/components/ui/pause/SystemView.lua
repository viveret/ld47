local super = require "src.components.ui.GroupUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new(type)
    local self = setmetatable(super.new(type), M)
    self.title = "System"
    self.justify = 'left'
    self:addButton('Options', events.WarpEvent.new('options'))
    self:addButton('To Title', events.WarpEvent.new('title'))
    self:addButton('Quit', events.system.QuitGameEvent.new())
	return self
end

return M