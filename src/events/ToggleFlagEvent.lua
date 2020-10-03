local M = {}

function M.fireOn(self, gs)
	local flagName = self.flagName

    if gs.hasFlag(flagName) then
    	gs.clearFlag(flagName)
		-- remove this once we have multiple states
    	gs.ensureBGMusic("overworld")
    else
    	gs.setFlag(flagName)
    	-- remove this once we have multiple states
    	gs.ensureBGMusic("other")
    end
end

function M.new(flagName) 
	local ret = { type = "ToggleFlagEvent", flagName = flagName, fireOn = M.fireOn }

	return ret
end

return M