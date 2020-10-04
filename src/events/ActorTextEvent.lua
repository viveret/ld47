local M = {}

function M.fireOn(self, gs)
    local scene = gs:current().name

	if scene == self.name then
    	toast.showToast(self.text, self.name)
    end
end

function M.new(scene, name, text) 
	return { type="ActorTextEvent", scene = scene, name = name, text = text, fireOn = M.fireOn }
end

return M