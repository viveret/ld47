local M = {}

function M.fireOn(self, gs)
	local scene = gs.existingStates[self.scene]

	if not scene.isPhysicalGameState then
		print("Current state cannot spawn static objects")
		return
	end

	local img = gs.images.timelineObjs[self.assetName]
	if img == nil then
		error('could not find ' .. self.assetName .. ' in images.timelineObjs')
	end
	
	local newObj = StaticObject.new(scene.world, self.x, self.y, img, self.callback, name)

	scene:addStaticObject(self.name, newObj)
end

function M.new(scene, name, assetName, x, y, callback) 
	return { 
		scene = scene,
		type = "StaticObjectSpawnEvent", 
		name = name, 
		assetName = assetName,
		x = x, 
		y = y, 
		callback = callback,
		fireOn = M.fireOn 
	}
end

return M