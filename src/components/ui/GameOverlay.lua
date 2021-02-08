local super = require "src.components.ui.GroupUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new()
    local self = setmetatable(lume.extend(super.new('overlay'), {
        toasts = super.new('toasts'),
        toastsOffsetY = 54,
        toastsOffsetX = 4,
    }), M)
    self.toasts.offsetY = lg.getHeight() - self.toastsOffsetY
    self.toasts.offsetX = self.toastsOffsetX
    self.toasts.itemGap = 13
    self:addUiElement(self.toasts)
	return self
end

function M:addUiElement(el)
    if el.type == 'toast' then
        self.toasts:addUiElement(el)
    else
        super.addUiElement(self, el)
    end
end

function M:update(dt)
    super.update(self, dt)
end

function M:tick(ticks)
    super.tick(self, ticks)
end

function M:draw()
    self.toasts.offsetY = lg.getHeight() - self.toastsOffsetY - self.toasts:getHeight()
    self.toasts.offsetX = self.toastsOffsetX
    self.toasts:draw()

    if game.saves.saving then
        lg.push()
        local alpha = (game.saves.elapsedTime % 3) / 3
        lg.setColor(1, 1, 1, sin(alpha * pi))
        local angle = alpha * pi * 2
        lg.draw(game.images.ui.icons.saving, lg.getWidth() - 32 - 6, 32 + 6, angle, 1, 1, 32, 32)
        lg.setColor(1, 1, 1, 1)
        lg.pop()
    end
end

function M:getWidth()
    return lg.getWidth()
end

function M:getHeight()
    return lg.getHeight()
end

return M