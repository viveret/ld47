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

function M.customerServed(gs, actorName, customerName, type, param, text) 
	if type ~= "action" then
		return
	end

	local notDoneJob = gs.hasFlag("NotDoneJob")
	if notDoneJob then
		gs.clearFlag("NotDoneJob")
	end

	local customerFlag = "Served"..customerName
	local notCustomerFlag = "Not"..customerFlag

	local served = gs.hasFlag(customerFlag)
	if not served then
		gs.setFlag(customerFlag)

		print("showing dialog")

		local currentScene = gs.current().scene
		print("currentScene "..currentScene)

		local dialog = gs.createStates.DialogGame.new(gs, "Cultist", "Best watch where you are walking.")
		gs.push(dialog)
	end

	if gs.hasFlag(notCustomerFlag) then
		gs.clearFlag(notCustomerFlag)
	end

	local a =  gs.hasFlag("ServedcustomerOne")
	local b = gs.hasFlag("ServedcustomerTwo") 
	local c = gs.hasFlag("ServedcustomerThree")

	if a and b and c then
		gs.setFlag("ServedAllCustomers")
	end
end

function M.customerOne(gs, actor, eventType, param)
	M.customerServed(gs, actor.name, "customerOne", eventType, param, "Ah, a nice cup of joe.  Thanks for the coffee, kid.")
end

function M.customerTwo(gs, actor, eventType, param)
	M.customerServed(gs, actor.name,"customerTwo", eventType, param, "Soy latte's are my favorite.  Though I always wonder, how does one milk a soy?")
end

function M.customerThree(gs, actor, eventType, param)
	M.customerServed(gs, actor.name,"customerThree", eventType, param, "Caffeine is life.  Therefore, I owe you mine.")
end

function M.customerFour(gs, actor, eventType, param)
	M.customerServed(gs, actor.name,"customerFour", eventType, param, "You must have a rather banal existence.")
end

function M.customerCultist(gs, actor, eventType, param)
	-- todo
end

return M