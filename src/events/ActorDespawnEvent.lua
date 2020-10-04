local M = {}

function M.fireOn(self, gs) 
	local scene = gs.existingStates[self.scene]

	if not scene.isPhysicalGameState then
		print("Current state cannot have actors")
		return
	end

	scene:removeActor(self.name)
end

function M.new(scene, name) 
	return { scene = scene, type="ActorDespawnEvent", name = name, fireOn = M.fireOn }
end

return M