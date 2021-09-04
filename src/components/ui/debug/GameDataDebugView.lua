local super = require "src.components.ui.GroupUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new(type)
    local self = setmetatable(super.new(type), M)
    self.title = "Game"
    self:addButton("Scene Select", events.Warp.new("sceneselect"))
	return self
end

return M