local super = require "src.components.ui.BaseUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new(img, eventToFire)
    local self = setmetatable(lume.extend(super.new('image button'), {
        img = img,
        event = eventToFire,
        itemPad = 8,
        itemGap = 8,
        w = 230,
        h = 60,
    }), M)
	return self
end

function M:draw()
    if self.clicked then
        lg.setColor(0.6, 0.6, 0.6)
    elseif self.hover then
        lg.setColor(0.8, 0.8, 0.8)
    end
    game.graphics:drawObject(self.img, 0, 0, self:getWidth(), self:getHeight())
    if self.clicked or self.hover then
        lg.setColor(1, 1, 1)
    end
end

function M:update(dt)
end

function M:activated()
    self.clicked = nil
    self.hover = nil
end

return M