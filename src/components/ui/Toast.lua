local super = require "src.components.ui.BaseUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new(text, name)
    local self = setmetatable(lume.extend(super.new('toast'), {
		name = name or "???",
		text = text or error ('missing text'),
		duration = text:len(),
		charsToShow = 0,
		charsPerSecond = game.options.textSpeed,
		w = 200, h = 10,
		color = { r = 1, g = 1, b = 1, a = 1 },
	}), M)
	
	return self
end

function M:draw()
	local text = self.text:sub(0, floor(self.charsToShow))
	if self.duration < 1 then
		self.color.a = self.duration
	end
	game.graphics:drawTextInBox(text, 0, 0, self.w, self.h, game.images.ui.dialog_font, self.color)
end

function M:update(dt)
	self.charsToShow = min(self.charsToShow + dt * self.charsPerSecond, #self.text)
	self.duration = self.duration - dt
	if self.duration <= 0 then
		self.parent:removeUiElement(self)
	end
end

return M