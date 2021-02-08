local super = require "src.events.TimeLineEvent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M:fireOn(gs)
	local scene = gs:current().scene

	if scene == self.scene then
		game.toast(self.text)
    end
end

function M.new(scene, text)
    local self = setmetatable(super.new(scene, "RoomTextEvent"), M)
	self.text = text
	return self
end

return M