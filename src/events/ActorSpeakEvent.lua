local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = BaseEvent })
M.__index = M

function M.new(scene, name, text) 
    if scene == nil or scene == '' then
        error('scene cannot be nil or empty')
    end
    local self = setmetatable(BaseEvent.new(), M)
	
	self.scene = scene
	self.type="ActorSpeakEvent"
	self.name = name
	self.text = text

    return self
end

function M:fireOn(gs)
	-- print('self.scene: ')
	-- print(self.scene)

	local scene = gs.current()
	local currentScene = scene.scene

	--print("ActorSpeakEvent firing"..currentScene)
	
	if currentScene == self.scene then
		-- print("ActorSpeakEvent inserting dialog")
		local actor = scene:getActor(self.name)

		if actor == nil then
			print("Actor not found "..self.name)
			return
		end

		local assetName = nil
		if actor ~= nil then
			assetName = actor.assetName
		end

    	local dialogState = gs.createStates.DialogGame.new(gs, assetName, self.name, self.text)

    	gs.push(dialogState)
    --else
    	--print("skipping dialog, not in scene "..self.scene)
    end
end

return M