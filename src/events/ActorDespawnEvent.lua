local M = {}

function M:new(name) 
	return { name = name, fireOn = fireOne }
end

function fireOn(self, gs) 
	-- todo
end

return M