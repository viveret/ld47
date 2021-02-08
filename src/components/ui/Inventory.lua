local super = require "src.components.ui.BaseUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new(inventory)
    local self = setmetatable(lume.extend(super.new('inventory'), {
        inventory = inventory or error('missing inventory')
    }), M)

	return self
end

function M:draw()
    self.inventory:drawUI()
	--game.graphics:drawTextInBox(el, self.itemPad + self.iconSize, self.itemPad, self.itemWidth - (self.itemPad + self.iconSize) * 2, self.itemHeight - self.itemPad * 2, game.images.ui.dialog_font)
end

function M:keypressed(key, scancode, isrepeat)
    if not isrepeat then
        if key == 'space' then
            local id = self.inventory:selectedItem()
            if id ~= nil then
                self.inventory:activateSelected()
            end
            return
        elseif key == 'left' then
            self.inventory:selectLeft()
            return
        elseif key == 'right' then
            self.inventory:selectRight()
            return
        elseif key == 'up' then
            self.inventory:selectUp()
            return
        elseif key == 'down' then
            self.inventory:selectDown()
            return
        end

        local activeItem = self:activeItem()
        if activeItem ~= nil then
            for i,item in pairs(activeItem.keyBinds) do

            end
        end
    end
    super.keypressed(self, key, scancode, isrepeat)
end

return M