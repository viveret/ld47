local M = {}

function M:new(path) 
	return { path }
end

function M.fireOn(self, gs)
    love.audio.play(self.path)
end

return M