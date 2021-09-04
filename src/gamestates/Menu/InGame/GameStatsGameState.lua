local super = require "src.gamestates.Menu.MenuGameState"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new()
    local self = setmetatable(lume.extend(super.new('gameStats', 'GameStats'), {
    }), M)

    self.scroll = uiComponents.navs.Scrollable.new()
    self.scroll:addInspection(game.current())
    self.root:addUiElement(self.scroll)

    self.root:addSpace(25)
    self.root:addReturnButton()

	return self
end

function M:keypressed( key, scancode, isrepeat )
    if not isrepeat then
        if lume.find({'p', 'n', 'escape'}, key) then
            self.root.returnButton:onClick()
            return
        end
    end
    super.keypressed(self, key, scancode, isrepeat)
end

function M:keyreleased( key, scancode )
    super.keyreleased(self, key, scancode)
end

return M