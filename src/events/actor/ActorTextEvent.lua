local super = require "src.events.TimeLineEvent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M:fireWhenInScene()
	game.toast(self.name .. ': ' .. self.text)
end

function M:fireWhenOutOfScene()
	print('skipping actor text "' .. self.text .. '" for name/scene ' .. self.name .. '/' .. self.scene)
end

function M.new(scene, name, text)
    local self = setmetatable(super.new(scene, "ActorTextEvent"), M)
	self.name = name or '???'
	self.text = text
	return self
end

return M