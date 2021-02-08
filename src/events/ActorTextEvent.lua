local super = require "src.events.TimeLineEvent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M:fireOn()
    local scene = game.current().scene

	if scene == self.scene then
		game.toast((self.name or '???') .. ': ' .. self.text)
    end
end

function M.new(scene, name, text)
    local self = setmetatable(super.new(scene, "ActorTextEvent"), M)
	self.name = name
	self.text = text
	return self
end

return M