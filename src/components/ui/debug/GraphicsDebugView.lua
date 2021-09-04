local super = require "src.components.ui.GroupUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new(type)
    local self = setmetatable(super.new(type), M)
    self.title = "Graphics"
    self.justify = "left"
    -- self:addButton("test", events.game.GameOverEvent.new())
	return self
end

return M