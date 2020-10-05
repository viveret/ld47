local M = setmetatable({}, { __index = MenuGameState })
M.__index = M

function M.new(gamestate)
    local self = setmetatable(MenuGameState.new(gamestate, 'Title'), M)
    self.bg = self.gamestate.graphics.ui.title

    if gamestate.hasProgress() then
        self:addButton('Continue', ContinueGameEvent.new())
    end
    
    self:addSpace(275)
    self:addImageButton(gamestate.graphics.ui.start_btn, NewGameEvent.new())

    self.scene = "Title"

	return self
end

return M