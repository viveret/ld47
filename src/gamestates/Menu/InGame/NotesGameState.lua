local super = require "src.gamestates.Menu.MenuGameState"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new()
    local self = setmetatable(lume.extend(super.new('notes', 'Notes'), {
        navigateLeft = 'inventory',
        navigateRight = 'pause',
    }), M)
    self.root.bg = game.images.ui.notes

    self.root:addSpace(25)
    
    local notes = game.saveData.notes
    if notes ~= nil and #notes > 0 then
        self.notes = uiComponents.widgets.Notes.new(notes)
        self.root:addUiElement(self.notes)
    else
        self.root:addUiElement(uiComponents.inputs.TextButton.new("No notes yet", {}))
    end

    self.root:addSpace(25)
    self.root:addReturnButton()

	return self
end

function M:keypressed( key, scancode, isrepeat )
    if not isrepeat then
        if lume.find({'p', 'n', 'escape'}, key) then
            self.root.returnButton:onClick()
            return
        elseif key == game.strings.keyBinds.moveRight then
            game.warpTo(self.navigateRight, game.stackTransitions.ToLeft)
            return
        elseif key == game.strings.keyBinds.moveLeft then
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