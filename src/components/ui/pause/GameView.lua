local super = require "src.components.ui.GroupUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new(type)
    local self = setmetatable(super.new(type), M)
    self.title = "Game"
    self.justify = 'left'
    self:addButton('Inventory', events.WarpEvent.new('inventory'))
    self:addButton('Notes', events.WarpEvent.new('notes'))
    self:addButton('Quick Load', events.gamestate.QuickLoadEvent.new())
    self:addButton('Select Load', events.gamestate.LoadGameEvent.new())
	return self
end

return M