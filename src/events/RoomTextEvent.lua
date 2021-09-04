local super = require "src.events.TimeLineEvent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M:fireWhenInScene()
	game.toast(self.text)
    return true
end

function M:fireWhenOutOfScene()
	print("skipping room text " .. self.text .. " for scene " .. self.scene)
end

function M.new(scene, text)
    local self = setmetatable(super.new(scene, "RoomTextEvent"), M)
	self.text = text
	return self
end

return M