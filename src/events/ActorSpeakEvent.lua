local M = {}

function M.fireOn(self, gs)
    -- todo
end

function M.new(name, text) 
	return { type="ActorSpeakEvent", name = name, text = text, fireOn = M.fireOn }
end

return M