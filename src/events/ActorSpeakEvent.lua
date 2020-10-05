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

	local currentScene = gs.current().scene

	--print("ActorSpeakEvent firing"..currentScene)
	
	if currentScene == self.scene then
		-- print("ActorSpeakEvent inserting dialog")

    	local dialogState = gs.createStates.DialogGame.new(gs, self.name, self.text)

    	gs.push(dialogState)
    --else
    	--print("skipping dialog, not in scene "..self.scene)
    end
end

return M