local super = require "src.events.TimeLineEvent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M:fireOn(gs)
	local currentScene = gs:current().scene

	if currentScene == self.scene then
		local toPlay = gs.audio[self.name]
    	love.audio.play(toPlay)
    end
end

function M.new(scene, name)
    local self = setmetatable(super.new(scene, "PlaySoundEvent"), M)
	self.name = name
	return self
end

return M