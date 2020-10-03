local M = {}

function M.fireOn(self, gs)
	local flagName = self.flagName

    if gs.hasFlag(flagName) then
    	gs.clearFlag(flagName)
    else
    	gs.setFlag(flagName)
    end
end

function M.new(flagName) 
	local ret = { type = "ToggleFlagEvent", flagName = flagName, fireOn = M.fireOn }

	return ret
end

return M