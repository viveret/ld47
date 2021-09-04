local super = require "src.components.ui.BaseUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new(text, eventToFire)
    local self = setmetatable(lume.extend(super.new('text button'), {
        text = text,
        event = eventToFire,
        padding = {
            t = 8,
            b = 8,
            l = 8,
            r = 8,
        },
        w = 170,
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

    game.graphics:drawObject(game.images.ui.button_bg, self.padding.l, self.padding.t, self:getWidth(), self:getHeight())

    if self.clicked or self.hover then
        lg.setColor(1, 1, 1)
    end

    super.draw(self)
end

function M:activated()
    self.clicked = nil
    self.hover = nil
end

return M