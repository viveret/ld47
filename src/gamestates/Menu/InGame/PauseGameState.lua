local super = require "src.gamestates.Menu.MenuGameState"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new()
    local self = setmetatable(lume.extend(super.new('pause', 'Pause'), {
        navigateLeft = 'notes',
        navigateRight = 'notes',
    }), M)

    self:addButton('Continue', ContinueGameEvent.new())
    self:addButton('Quick Load', QuickLoadEvent.new())
    self:addButton('Load Previous', LoadGameEvent.new())
    self:addButton('Settings', GameSettingsEvent.new())
    self:addButton('Game Stats', GameStatsEvent.new())
    self:addButton('Quit', QuitGameEvent.new())

    self:addSpace(110)

    self.journal = uiComponents.Journal.new()
    self:addUiElement(self.journal)

	return self
end

function M:keypressed( key, scancode, isrepeat )
    if not isrepeat then
        if lume.find({'p', 'escape'}, key) then
            game.fire(ContinueGameEvent.new(), true)
            return
        elseif key == 'q' then
            game.fire(QuitGameEvent.new(), true)
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