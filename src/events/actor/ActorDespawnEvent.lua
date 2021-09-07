local super = require "src.events.TimeLineEvent"
local M = setmetatable({ aliases = { "Despawn" } }, { __index = super })
M.__index = M

function M:fireOn() 
	local scene = game.stateMgr:current()

	if not scene.isPhysicalGameState then
		print("Current state cannot have actors")
		return
	end

	scene:removeActor(self.name)
end

function M:fireWhenOutOfScene()
	print("skipping despawn actor for name/scene " .. self.name .. '/' .. self.scene)
end

function M.new(scene, name)
    local self = setmetatable(super.new(scene, "ActorDespawnEvent"), M)
	self.name = name or error ('Name must not be nil')
	return self
end

return M