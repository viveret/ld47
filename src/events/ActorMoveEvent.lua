local M = {}

function M.fireOn(self, gs) 
	local scene = gs.existingStates[self.scene]

	if not scene.isPhysicalGameState then
		print("Current state cannot move actors")
		return
	end

	local actor = scene:getActor(self.name)

	if actor == nil then
		print("Actor not found "..self.name)
		return
	end

	actor:moveTo(self.toX, self.toY, self.speed)
end

function M.new(scene, name, toX, toY, speed) 
	return { scene = scene, type="ActorMoveEvent", name = name, toX = toX, toY = toY, speed = speed, fireOn = M.fireOn }
end

return M