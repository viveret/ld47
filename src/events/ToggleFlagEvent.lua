local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = BaseEvent })
M.__index = M

function M.new(scene, flagName) 
    local self = setmetatable(BaseEvent.new('ToggleFlag'), M)
    self.scene = scene
    self.flagName = flagName
	return self
end

function M:fireOn(gs)
    local scene = gs:current().name

    if scene ~= self.scene then
        print("Skipping flag "..self.flagName..", not in scene")
        return
    end

	local flagName = self.flagName

    if gs.hasFlag(flagName) then
    	gs.clearFlag(flagName)
    else
    	gs.setFlag(flagName)
    end
end

return M