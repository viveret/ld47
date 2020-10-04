local M = {}

function M.fireOn(self, gs) 
	print("ActorSpawnEvent firing "..self.scene.." "..self.name)

	local scene = gs.existingStates[self.scene]

	if not scene.isPhysicalGameState then
		print("Current state cannot spawn actors")
		return
	end

	local world = scene.world

	local spritesheetStill = gs.graphics[self.assetName.."Idle"]
	local spritesheetUp = gs.graphics[self.assetName.."Up"]
	local spritesheetDown = gs.graphics[self.assetName.."Down"]
	local spritesheetLeft = gs.graphics[self.assetName.."Left"]
	local spritesheetRight = gs.graphics[self.assetName.."Right"]

	local callback = self.callback

	local newActor = actor.new(world, gs, self.x, self.y, spritesheetStill, spritesheetUp, spritesheetDown, spritesheetLeft, spritesheetRight, callback)

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