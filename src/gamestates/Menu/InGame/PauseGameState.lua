local super = require "src.gamestates.Menu.MenuGameState"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new()
    local self = setmetatable(lume.extend(super.new('pause', 'Pause'), {
        navigateLeft = 'notes',
        navigateRight = 'inventory',
    }), M)

    self.tabs = uiComponents.navs.TabGroup.new()
    local tgame = self.tabs:addTab('game', uiComponents.pause.Game.new())
    local tgamemeta = self.tabs:addTab('meta', uiComponents.pause.GameMeta.new())
    local tsystem = self.tabs:addTab('system', uiComponents.pause.System.new())

    self.root:addUiElement(self.tabs)

    self.root:addReturnButton()

	return self
end

function M:keypressed( key, scancode, isrepeat )
    if not isrepeat then
        if lume.find({'p', 'escape'}, key) then
            self.root.returnButton:onClick()
            return
        elseif key == 'q' then
            game.fire(QuitGameEvent.new(), true)
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