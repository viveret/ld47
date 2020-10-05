local M = {}

local toast = require "src.components.toast"

function M.fireOn(self, gs)
	local scene = gs:current().scene

	if scene == self.scene then
		gs.toast = toast.new(gs, self.text)
		gs.toast:showToast()
    end
end

function M.new(scene, text) 
	local ret = { scene = scene, type = "RoomTextEvent", text = text, fireOn = M.fireOn }

	return ret
end

return M