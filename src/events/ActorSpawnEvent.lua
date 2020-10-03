local M = {}

function M:new(name, x, y) 
	return { name = name, x = x, y = y, fireOn = fireOn}
end

function fireOn(self, gs) 
	-- todo
end

return M