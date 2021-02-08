local super = require "src.components.ui.BaseUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new(type)
    local self = setmetatable(lume.extend(super.new(type or 'scrollable'), {
        scroll = 0.5,
        scrollVel = 0,
        scrollAccel = 0,
        pageSize = 2,
        itemWidth = 420,
        itemHeight = 28 * 3,
        itemPad = 8,
        itemGap = 8,
        iconSize = 32,
        items = {},
    }), M)

	return self
end

function M:draw()
    lg.push()
    lg.setColor(1, 1, 1)
    --lg.rectangle('line', 0, 0, self.itemWidth, (self.itemHeight + self.itemGap) * self.pageSize)
    
    local scrolli, scrollf = modf(self.scroll)

    lg.translate(0, (-scrollf) * (self.itemHeight + self.itemGap))
    for i,v in pairs(self.items) do
        if i >= self.scroll and i <= self.scroll + self.pageSize + 1 then
            self:drawItem(v)
            lg.translate(0, self.itemHeight + self.itemGap)
        end
    end
    lg.setColor(1, 1, 1)
    lg.pop()
end

function M:drawItem(el)
    -- local icon = nil
    -- if el.has then
    --     icon = game.images.ui.success
    -- else
    --     icon = game.images.ui.failure
    -- end
    
    -- game.graphics:drawObject(icon, 0, self.itemHeight / 2 - self.iconSize / 2, self.iconSize, self.iconSize)
	-- game.graphics:drawTextInBox(el.text, self.itemPad + self.iconSize, self.itemPad, self.itemWidth - (self.itemPad + self.iconSize) * 2, self.itemHeight - self.itemPad * 2, game.images.ui.dialog_font)
end

function M:update(dt)
    local scrollMax = #self.items - self.pageSize + .5
    self.scrollVel = self.scrollVel + self.scrollAccel * dt
    self.scroll = min(max(self.scroll + self.scrollVel * dt, 0.5), scrollMax)
    if self.scroll == 0.5 and self.scrollVel < 0 then
        self.scrollVel = 0
    elseif self.scroll == scrollMax and self.scrollVel > 0 then
        self.scrollVel = 0
    else
        self.scrollVel = self.scrollVel - self.scrollVel * dt
    end
end

function M:keypressed( key, scancode, isrepeat )
    if not isrepeat then
        if key == 'w' then
            self.scrollAccel = -1
        elseif key == 's' then
            self.scrollAccel = 1
        end
    end
end

function M:keyreleased( key, scancode )
    if key == 'w' or key == 's' then
        self.scrollAccel = 0
    end
end

function M:getWidth()
    return self.itemWidth
end

function M:getHeight()
    return self.itemHeight + self.itemPad
end

return M