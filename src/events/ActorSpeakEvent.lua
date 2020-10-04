local M = {}

function M.fireOn(self, gs)
	local currentScene = gs:current()

	if currentScene.name == self.scene then
    	local dialogState = gs.createStates.DialogGame.new(gs, self.name, self.text)

    	gs.push(dialogState)
    end
end

function M.new(scene, name, text) 
	return { scene = scene, type="ActorSpeakEvent", name = name, text = text, fireOn = M.fireOn }
end

return M