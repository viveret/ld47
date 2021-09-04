local super = require "src.events.TimeLineEvent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M:fireWhenInScene()
	local toPlay = game.audio[self.name]
	love.audio.play(toPlay)
end

function M:fireWhenOutOfScene()
	print("skipping play sound " .. self.name .. " for scene " .. self.scene)
end

function M.new(scene, name)
    local self = setmetatable(super.new(scene, "PlaySoundEvent"), M)
	self.name = name
	return self
end

return M