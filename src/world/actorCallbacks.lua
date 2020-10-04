local M = {}

-- each callback is of the form
--   function M.<eventName>(gamestate, actor, type)
--
-- gamestate = gamestate.lua ref
-- actor = actor.lua ref
-- eventType = one of "collision" "end collision" "action"
-- param = some type dependent value
--   * when type == "collision" or "end collision"
--     - param = other agent
--   * when type == "action"
--     - param = nil
function M.cultist(gs, actor, eventType, param) 
	if eventType == "collision" then
		local hasToldOff = gs.hasFlag("ToldOff")
		local isPlayer = param.type == "player"

		if not hasToldOff and isPlayer then
			gs.setFlag("ToldOff")
			local dialog = gs.states.DialogGame.new(gs, "Cultist", "Best watch where you are walking.")
			gs.push(dialog)
		end
	end
end

return M