local M = {}

function M.fireOn(self, gs)
    local scene = gs:current().name

    if scene ~= self.scene then
        print("Skipping flag "..self.flagName..", not in scene")
        return
    end

	local flagName = self.flagName

    if gs.hasFlag(flagName) then
    	gs.clearFlag(flagName)
		-- remove this once we have multiple states
    	gs.ensureBGMusic("theme")
    else
    	gs.setFlag(flagName)
    	-- remove this once we have multiple states
    	gs.ensureBGMusic("chill")
    end
end

function M.new(scene, flagName) 
	local ret = { scene = scene, type = "ToggleFlagEvent", flagName = flagName, fireOn = M.fireOn }

	return ret
end

return M