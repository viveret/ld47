local super = require "src.gamestates.Menu.MenuGameState"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new()
    local self = setmetatable(lume.extend(super.new('Game Over'), {
    }), M)
    self.bg = game.images.ui.end_bg

    if not game.hasFlag('defeated-cultists') then
        self:addButton('Continue', ContinueGameEvent.new())
    end
    self:addButton('Quit', QuitGameEvent.new())

    self.journal = uiComponents.Journal.new()
    self:addUiElement(self.journal)

	return self
end

return M