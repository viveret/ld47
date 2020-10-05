local M = {}

function M.fireOn(self, gs)
	local currentScene = gs:current().scene

	print("ActorSpeakEvent firing"..currentScene)

	if currentScene == self.scene then
		print("ActorSpeakEvent inserting dialog")

    	local dialogState = gs.createStates.DialogGame.new(gs, self.name, self.text)

    	gs.push(dialogState)
    else
    	print("skipping dialog, not in scene "..self.scene)
    end
end

function M.new(scene, name, text) 
	return { scene = scene, type="ActorSpeakEvent", name = name, text = text, fireOn = M.fireOn }
end

return M