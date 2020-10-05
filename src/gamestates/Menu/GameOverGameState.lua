local M = setmetatable({}, { __index = MenuGameState })
M.__index = M

local journal = require "src.components.journal"

function M.new(gamestate)
    local self = setmetatable(MenuGameState.new(gamestate, 'Game Over'), M)
    self.bg = self.gamestate.images.ui.end_bg

    if not gamestate.hasFlag('defeated-cultists') then
        self:addButton('Continue', ContinueGameEvent.new())
    end
    self:addButton('Quit', QuitGameEvent.new())

    self.journal = journal.new(gamestate)
    self:addUiElement(self.journal)

	return self
end

return M