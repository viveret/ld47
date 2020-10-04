local M = {}

function M.fireOn(self, gs) 
	local currentGS = gs:current()

	if not currentGS.isPhysicalGameState then
		print("Current state cannot move actors")
		return
	end

	local actor = currentGS:getActor(self.name)

	if actor == nil then
		print("Actor not found "..self.name)
		return
	end

	actor:moveTo(self.toX, self.toY, self.speed)
end

function M.new(name, toX, toY, speed) 
	return { type="ActorMoveEvent", name = name, toX = toX, toY = toY, speed = speed, fireOn = M.fireOn }
end

return M