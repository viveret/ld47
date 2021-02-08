local super = require "src.events.TimeLineEvent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M:fireOn(gs)
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
    local self = setmetatable(super.new(scene, "StaticObjectSpawnEvent"), M)
	self.name = name
	self.assetName = assetName
	self.x = x
	self.y = y
	
	if callback ~= nil then
		self.callback = timelineCallbacks[callback]
		if self.callback == nil then
			error("could find timelineCallbacks." .. callback)
		end
	end
	
	return self
end

return M