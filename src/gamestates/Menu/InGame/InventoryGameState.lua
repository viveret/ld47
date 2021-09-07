local super = require "src.gamestates.Menu.MenuGameState"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new()
    local self = setmetatable(lume.extend(super.new('inventory-root', 'Inventory'), {
        navigateLeft = 'pause',
        navigateRight = 'notes',
    }), M)
    self.root.bg = game.images.ui.notes

    self.root:addSpace(25)
    
    local gs = game.stateMgr:currentPhysical()
    if gs == nil then
        error 'can only view inventory when in-game'
    end
    
    local inventory = gs.player.inventory
    self.inventory = uiComponents.InGame.Inventory.Inventory.new(inventory)
    self.root:addUiElement(self.inventory)
    self.root:addSpace(25)
    self.root:addReturnButton()

	return self
end

function M:keypressed( key, scancode, isrepeat )
    if not isrepeat then
        if lume.find({'p', 'i', 'escape'}, key) then
            self.root.returnButton:onClick()
            return
        elseif key == game.strings.keyBinds.moveRight then
            game.warpTo(self.navigateRight, gamestateTransitions.ToLeft)
            return
        elseif key == game.strings.keyBinds.moveLeft then
            game.warpTo(self.navigateLeft, gamestateTransitions.ToRight)
            return
        end
    end
    super.keypressed(self, key, scancode, isrepeat)
end

function M:keyreleased( key, scancode )
    super.keyreleased(self, key, scancode)
end

return M