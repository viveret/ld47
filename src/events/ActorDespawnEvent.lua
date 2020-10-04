local M = {}

function M.fireOn(self, gs) 
	local currentGS = gs:current()

	if not currentGS.isPhysicalGameState then
		print("Current state cannot move actors")
		return
	end

	currentGS:removeActor(self.name)
end

function M.new(name) 
	return { type="ActorDespawnEvent", name = name, fireOn = M.fireOn }
end

return M