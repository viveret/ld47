local M = {}

function M.new(text) 
	local ret = { type = "RoomTextEvent", text = text, fireOn = fireOn }

	return ret
end

function fireOn(self, gs)
    gs.showRoomText(self.text)
end

return M