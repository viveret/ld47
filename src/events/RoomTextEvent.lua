local M = {}

function M:new(text) 
	return { text = text }
end

function M.fireOn(self, gs)
    gs.showSubtitle(self.text)
end

return M