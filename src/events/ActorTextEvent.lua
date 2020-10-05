local M = {}

local toast = require "src.components.toast"

function M.fireOn(self, gs)
    local scene = gs:current().scene

	if scene == self.scene then
		gs.toast = toast.new(gs, self.text, self.name)
		gs.toast:showToast()
    end
end

function M.new(scene, name, text) 
	return { type="ActorTextEvent", scene = scene, name = name, text = text, fireOn = M.fireOn }
end

return M