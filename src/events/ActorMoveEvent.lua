local super = require "src.events.TimeLineEvent"
local M = setmetatable({ aliases = { "Move" } }, { __index = super })
M.__index = M

function M:fireOn(gs) 
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
    local self = setmetatable(super.new(scene, "ActorMoveEvent"), M)
	self.scene = scene
	self.name = name
	self.toX = tonumber(toX)
	self.toY = tonumber(toY)
	self.speed = speed
	return self
end

return M