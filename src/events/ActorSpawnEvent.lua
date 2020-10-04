local M = {}

function M.fireOn(self, gs) 
	local currentGS = gs:current()

	if not currentGS.isPhysicalGameState then
		print("Current state cannot spawn actors")
		return
	end

	local world = currentGS.world

	local spritesheetStill = gs.graphics[self.name.."Idle"]
	local spritesheetUp = gs.graphics[self.name.."Up"]
	local spritesheetDown = gs.graphics[self.name.."Down"]
	local spritesheetLeft = gs.graphics[self.name.."Left"]
	local spritesheetRight = gs.graphics[self.name.."Right"]

	local newActor = actor.new(world, gs, self.x, self.y, spritesheetStill, spritesheetUp, spritesheetDown, spritesheetLeft, spritesheetRight)

	currentGS:addActor(self.name, newActor)
end

function M.new(name, x, y) 
	return { type="ActorSpawnEvent", name = name, x = x, y = y, fireOn = M.fireOn }
end

return M