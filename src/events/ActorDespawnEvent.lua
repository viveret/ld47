local M = {}

function M.fireOn(self, gs) 
	-- todo
end

function M.new(name) 
	return { type="ActorDespawnEvent", name = name, fireOn = M.fireOn }
end

return M