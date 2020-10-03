local M = {}

function M:new(path) 
	return { path = path, fireOn = fireOn }
end

function fireOn(self, gs)
    gs.warpTo(self.path)
end

return M