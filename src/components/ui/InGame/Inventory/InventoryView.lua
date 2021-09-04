local super = require "src.components.ui.GroupUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new(inventory)
    local self = setmetatable(lume.extend(super.new('inventory'), {
        inventory = inventory or error('missing inventory'),
        rowViews = {},
        itemViews = {},
    }), M)

    local h = self.inventory.itemHeight
    local w = self.inventory.itemWidth
    for r = 1, h do
        local rowView = uiComponents.GroupUIComponent.new('inventory-row')
        rowView.direction = 'horizontal'
        for c = 1, w do
            local i = (r - 1) * w + c
            local itemView = uiComponents.InGame.Inventory.Item.new(i, r, c, inventory)
            table.insert(self.itemViews, itemView)
            rowView:addUiElement(itemView)
        end
        self:addUiElement(rowView)
        table.insert(self.rowViews, rowView)
    end

	return self
end

-- function M:draw()
--     self:drawUIitems()
--     self:drawUIside()
-- 	--game.graphics:drawTextInBox(el, self.itemPad + self.iconSize, self.itemPad, self.itemWidth - (self.itemPad + self.iconSize) * 2, self.itemHeight - self.itemPad * 2, game.images.ui.dialog_font)
-- end

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

function M:keypressed(key, scancode, isrepeat)
    if not isrepeat then
        local previouslySelectedItem = self.itemViews[self.inventory.selectedIndex]
        if key == 'space' then
            local id = self.inventory:selectedItem()
            if id ~= nil then
                self.inventory:activateSelected()
            end
            return
        elseif key == 'left' then
            self.inventory:selectLeft()
            previouslySelectedItem.isSelected = false
            self.itemViews[self.inventory.selectedIndex].isSelected = true
            return
        elseif key == 'right' then
            self.inventory:selectRight()
            previouslySelectedItem.isSelected = false
            self.itemViews[self.inventory.selectedIndex].isSelected = true
            return
        elseif key == 'up' then
            self.inventory:selectUp()
            previouslySelectedItem.isSelected = false
            self.itemViews[self.inventory.selectedIndex].isSelected = true
            return
        elseif key == 'down' then
            self.inventory:selectDown()
            previouslySelectedItem.isSelected = false
            self.itemViews[self.inventory.selectedIndex].isSelected = true
            return
        end
    end
    super.keypressed(self, key, scancode, isrepeat)
end

return M