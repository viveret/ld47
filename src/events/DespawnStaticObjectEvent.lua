local super = require "src.events.TimeLineEvent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M:fireWhenInScene(gs) 
	local scene = game.current()

	if not scene.isPhysicalGameState then
		print("Current state cannot have static objects")
		return
	end

	scene:removeStaticObject(self.name)
end

function M:fireWhenOutOfScene()
	print("skipping despawn static object " .. self.name .. " for scene " .. self.scene)
end

function M.new(scene, name)
    local self = setmetatable(super.new(scene, "StaticObjectDespawnEvent"), M)
	self.name = name
	return self
end

return M