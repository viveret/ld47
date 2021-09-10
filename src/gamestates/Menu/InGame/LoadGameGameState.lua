local super = require "src.gamestates.Menu.MenuGameState"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new()
    local self = setmetatable(lume.extend(super.new('loadGame', 'LoadGame'), {
    }), M)
    self.root.bg = game.images.ui.notes

    self.root:addSpace(25)
    
    local saves = game.saveData.notes
    if saves ~= nil and #saves > 0 then
        self.saves = uiComponents.widgets.SavedGames.new(notes)
        self.root:addUiElement(self.saves)
    else
        self.root:addUiElement(uiComponents.inputs.TextButton.new("No saves yet", {}))
    end

    self.root:addSpace(25)
    self.root:addReturnButton()

	return self
end

function M:onKeyPressed( key, scancode, isrepeat )
    if not isrepeat then
        if lume.find({'p', 'n', 'escape'}, key) then
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
    super.onKeyPressed(self, key, scancode, isrepeat)
end

function M:onKeyReleased( key, scancode )
    super.onKeyReleased(self, key, scancode)
end

return M