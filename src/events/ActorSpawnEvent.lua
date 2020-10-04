local M = {}

function M.fireOn(self, gs) 
	local currentGS = gs:current()

	if not currentGS.isPhysicalGameState then
		print("Current state cannot spawn actors")
		return
	end

	local world = currentGS.world

	local spritesheetStill = gs.graphics[self.assetName.."Idle"]
	local spritesheetUp = gs.graphics[self.assetName.."Up"]
	local spritesheetDown = gs.graphics[self.assetName.."Down"]
	local spritesheetLeft = gs.graphics[self.assetName.."Left"]
	local spritesheetRight = gs.graphics[self.assetName.."Right"]

	local callback = self.callback

	local newActor = actor.new(world, gs, self.x, self.y, spritesheetStill, spritesheetUp, spritesheetDown, spritesheetLeft, spritesheetRight, callback)

	currentGS:addActor(self.name, newActor)
end

function M.new(name, assetName, x, y, callback) 
	return { 
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