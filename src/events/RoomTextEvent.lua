local M = {}

function M.fireOn(self, gs)
    gs.showRoomText(self.text)
end

function M.new(text) 
	local ret = { type = "RoomTextEvent", text = text, fireOn = M.fireOn }

	return ret
end

return M