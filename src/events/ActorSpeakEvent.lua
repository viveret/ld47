local M = {}

function M.fireOn(self, gs)
    local dialogState = gs.states.DialogGame.new(gs, self.name, self.text)

    gs.push(dialogState)
end

function M.new(name, text) 
	return { type="ActorSpeakEvent", name = name, text = text, fireOn = M.fireOn }
end

return M