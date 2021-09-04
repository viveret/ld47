local super = require "src.components.ui.GroupUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new()
    local self = setmetatable(lume.extend(super.new('overlay'), {
        toasts = super.new('toasts'),
        toastsOffsetY = 54,
        toastsOffsetX = 4,
        itemGap = 13,
    }), M)
    self.toasts.positioning = 'relative'
    --self.toasts.offsetY = lg.getHeight() - self.toastsOffsetY
    --self.toasts.offsetX = self.toastsOffsetX
    
    self:addUiElement(self.toasts)
    
	return self
end

function M:addUiElement(el)
    if el.type == 'toast' then
        self.toasts:addUiElement(el)
        el.padding.b = self.itemGap
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
    --self.toasts:draw()

    super.draw(self)
end

function M:getWidth()
    return lg.getWidth()
end

function M:getHeight()
    return lg.getHeight()
end

return M