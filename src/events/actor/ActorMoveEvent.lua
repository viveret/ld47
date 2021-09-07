local super = require "src.events.TimeLineEvent"
local M = setmetatable({ aliases = { "Move" } }, { __index = super })
M.__index = M

function M:fireOn(gs) 
	local scene = game.stateMgr:current()

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

function M:fireWhenOutOfScene()
	print("skipping actor move for name/scene " .. self.name .. '/' .. self.scene)
end

function M.new(scene, name, toX, toY, speed) 
    local self = setmetatable(lume.extend(super.new(scene, "ActorMoveEvent"),{
		name = name,
		toX = tonumber(toX),
		toY = tonumber(toY),
		speed = speed,
	}), M)
	return self
end

return M