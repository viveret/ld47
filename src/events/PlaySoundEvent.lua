local M = {}

function M.fireOn(self, gs)
	local toPlay = gs.audio[self.name]
    love.audio.play(toPlay)
end

function M.new(name) 
	local ret = { type = "PlaySoundEvent", name = name, fireOn = M.fireOn }

	return ret
end

return M