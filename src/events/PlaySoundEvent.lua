local M = {}

function M.fireOn(self, gs)
	local currentScene = gs:current().name

	if name == self.scene then
		local toPlay = gs.audio[self.name]
    	love.audio.play(toPlay)
    end
end

function M.new(scene, name) 
	local ret = { scene, type = "PlaySoundEvent", name = name, fireOn = M.fireOn }

	return ret
end

return M