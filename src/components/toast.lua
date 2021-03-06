local M = {}
M.__index = M

function M.new(gamestate, text, name)
    local self = setmetatable({
		visible = false,
		name = name or "???",
		text = text,
		duration = text:len() * 10,
		gamestate = gamestate
	}, M)
	
	return self
end

function M:showToast()
	self.visible = true
end

function M:draw()
	if not self.visible then
		return
	end

	self.gamestate.images:drawDialogBox(self.name, self.name, self.text, nil)
end

function M:tick()
	if not self.visible then
		return
	end

	self.duration = self.duration - 1
	if self.duration == 0 then
		self.visible = false
	end
end

return M