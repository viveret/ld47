local M = {}

function M.fireOn(self, gs) 
	-- todo
end

function M.new(name, toX, toY) 
	return { type="ActorMoveEvent", name = name, toX = x, toY = y, fireOn = M.fireOn }
end

return M