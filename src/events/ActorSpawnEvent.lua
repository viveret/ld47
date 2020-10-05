local M = {}

local NPC = require "src.actors.NPC"

function M.fireOn(self, gs) 
	-- print("ActorSpawnEvent firing "..self.scene.." "..self.name)

	local scene = gs.existingStates[self.scene]

	if not scene.isPhysicalGameState then
		print("Current state cannot spawn actors")
		return
	end

	local anims = gs.animations.actors[self.assetName]
	if anims == nil then
		error('could not find ' .. self.assetName .. ' in animations.actors')
	end
	
	local newActor = NPC.new(scene.world, name, gs, self.x, self.y, 5, 5, anims, self.callback)
	newActor.assetName = self.assetName

	scene:addActor(self.name, newActor)
end

function M.new(scene, name, assetName, x, y, callback) 
	return { 
		scene = scene,
		type="ActorSpawnEvent", 
		name = name, 
		assetName = assetName,
		x = x, 
		y = y, 
		callback = callback,
		fireOn = M.fireOn 
	}
end

return M