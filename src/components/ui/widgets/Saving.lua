local super = require "src.components.ui.BaseUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new()
    local self = setmetatable(lume.extend(super.new('saving'), {
        textBase = "Saving",
        bgColor = { r = 0, g = 0, b = 0, a = 0.5 },
        positioning = 'relative',
        offsetX = 100,
        offsetY = 0,
        w = 115,
        h = 40,
        charsToShow = 0,
        charsPerSecond = 2
    }), M)
	self.text = self.textBase

	return self
end

function M:draw()
    self.offsetX = lg.getWidth() / 2 - self:getWidth() / 2
    self.offsetY = lg.getHeight() - self:getHeight()
	self.text = self.textBase
    for i = 1, floor(self.charsToShow) do
        self.text = self.text .. "."
    end
    super.draw(self)
end

function M:update(dt)
	self.charsToShow = self.charsToShow + dt * self.charsPerSecond
    if self.charsToShow > 4 then
        self.charsToShow = 0
    end
end

return M