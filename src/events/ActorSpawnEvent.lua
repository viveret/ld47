local M = {}

function M.fireOn(self, gs) 
	-- todo
end

function M.new(name, x, y) 
	return { type="ActorSpawnEvent", name = name, x = x, y = y, fireOn = M.fireOn }
end

return M