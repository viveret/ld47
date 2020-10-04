local M = {}

function M.fireOn(self, gs)
	local scene = gs:current().scene

	if scene == self.scene then
    	toast.showToast(self.text)
    end
end

function M.new(scene, text) 
	local ret = { scene = scene, type = "RoomTextEvent", text = text, fireOn = M.fireOn }

	return ret
end

return M