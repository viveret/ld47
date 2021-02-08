local super = require "src.events.TimeLineEvent"
local M = setmetatable({ aliases = { "Spawn" } }, { __index = super })
M.__index = M

local NPC = require "src.actors.NPC"

function M:fireOn(gs) 
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
    local self = setmetatable(super.new(scene, "ActorSpawnEvent"), M)
	self.name = name
	self.assetName = assetName
	self.x = tonumber(x)
	self.y = tonumber(y)
	
	if callback ~= nil then
		self.callback = timelineCallbacks[callback]
		if self.callback == nil then
			error("could find timelineCallbacks." .. callback)
		end
	end

	return self
end

function M:tostring()
	return '[' .. self.scene .. '] spawn ' .. self.name .. ' with ' .. self.assetName .. ' assets at ' .. self.x .. ', ' .. self.y
end

return M