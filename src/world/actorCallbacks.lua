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
			local dialog = gs.createStates.DialogGame.new(gs, "Cultist", "Best watch where you are walking.")
			gs.push(dialog)
		end
	end
end

function M.customerServed(gs, customerName, type, param) 
	if param.type ~= "player" then
		return
	end

	local notDoneJob = gs.hasFlag("NotDoneJob")
	if notDoneJob then
		gs.clearFlag("NotDoneJob")
	end

	local customerFlag = customerName.."Served"

	local served = gs.hasFlag(customerFlag)
	if not served then
		gs.setFlag(customerFlag)
	end
end

function M.customerOne(gs, actor, eventType, param)
	M.customerServed(gs, "customerOne", eventType, param)
end

function M.customerTwo(gs, actor, eventType, param)
	M.customerServed(gs, "customerTwo", eventType, param)
end

function M.customerThree(gs, actor, eventType, param)
	M.customerServed(gs, "customerThree", eventType, param)
end

function M.customerFour(gs, actor, eventType, param)
	M.customerServed(gs, "customerFour", eventType, param)
end

return M