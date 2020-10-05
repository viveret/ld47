local M = {}

function M.fireOn(self, gs) 
	local scene = gs.existingStates[self.scene]

	if not scene.isPhysicalGameState then
		print("Current state cannot have static objects")
		return
	end

	scene:removeStaticObject(self.name)
end

function M.new(scene, name)
	return { scene = scene, type="StaticObjectDespawnEvent", name = name, fireOn = M.fireOn }
end

return M