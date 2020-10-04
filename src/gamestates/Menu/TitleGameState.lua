local M = setmetatable({}, { __index = MenuGameState })
M.__index = M

function M.new(gamestate)
    local self = setmetatable(MenuGameState.new(gamestate, 'Title'), M)

    if gamestate.hasProgress() then
        self:addButton('Continue', ContinueGameEvent.new())
    end
    
    self:addButton('New Game', NewGameEvent.new())

	return self
end

return M