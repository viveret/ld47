local super = require "src.gamestates.Menu.MenuGameState"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new()
    local self = setmetatable(lume.extend(super.new('inventory-root', 'Inventory'), {
        navigateLeft = 'pause',
        navigateRight = 'pause',
    }), M)
    self.bg = game.images.ui.notes

    self:addSpace(50)
    
    local inventory = game.current().player.inventory
    self.inventory = uiComponents.Inventory.new(inventory)
    self:addUiElement(self.inventory)

	return self
end

function M:keypressed( key, scancode, isrepeat )
    if not isrepeat then
        if lume.find({'p', 'i', 'escape'}, key) then
            game.fire(events.game.ContinueGameEvent.new(), true)
            return
        elseif key == game.keyBinds.moveRight then
            game.warpTo(self.navigateRight, game.stackTransitions.ToLeft)
            return
        elseif key == game.keyBinds.moveLeft then
            game.warpTo(self.navigateLeft, game.stackTransitions.ToRight)
            return
        end
    end
    super.keypressed(self, key, scancode, isrepeat)
end

function M:keyreleased( key, scancode )
    super.keyreleased(self, key, scancode)
end

return M