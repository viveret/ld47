local super = require "src.components.ui.BaseUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new(i, r, c, inventory)
    local self = setmetatable(lume.extend(super.new('inventory-item'), {
        inventory = inventory or error('missing inventory'),
        itemIndex = i,
        bgColorRegular = {
            r = 0.2,
            g = 0.2,
            b = 0.2,
            a = 1,
        },
        bgColorHover = {
            g = 0,
            a = 1,
        },
        margin = {
            l = 8,
            r = 8,
            t = 8,
            b = 8,
        },
        w = 100,
        h = 100
    }), M)
    self.bgColorHover.r = c / inventory.itemWidth
    self.bgColorHover.b = r / inventory.itemHeight
    self:mousemoved(false, -1, -1, -1, -1)

	return self
end

function M:mousemoved(isClicked, x, y, elx, ely)
    super.mousemoved(self, isClicked, x, y, elx, ely)

    if self.hover then
        self.wasHovering = true
        self.isSelected = true
    elseif self.wasHovering then
        self.wasHovering = false
        self.isSelected = false
    end

    if self.isSelected then
        self.bgColor = self.bgColorHover
    else
        self.bgColor = self.bgColorRegular
    end
end

function M:drawUIside()
    lg.push()
    lg.translate(self.itemWidth * self.itemSize / -2 - self.sideWidth + self.sidePad, 0)
    local id = self:selectedItem()
    if id ~= nil then
        local selectedItem = game.items[id]
        selectedItem:drawUISideInfo()
    end
    lg.pop()
end

return M