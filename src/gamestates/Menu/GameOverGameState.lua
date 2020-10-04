local M = setmetatable({}, { __index = MenuGameState })
M.__index = M

function M.new(gamestate)
    local self = setmetatable(MenuGameState.new(gamestate, 'Game Over'), M)

    self.journal = journal.new(gamestate)
    self:addUiElement(self.journal)

    self:addButton('Continue', ContinueGameEvent.new())
    self:addButton('Quit', QuitGameEvent.new())

	return self
end

return M