local M = {}

function M:new(path) 
	return { path = path, fireOn = fireOn }
end

function fireOn(self, gs)
    love.audio.play(self.path)
end

return M