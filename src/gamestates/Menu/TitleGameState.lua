local M = setmetatable({}, { __index = MenuGameState })
M.__index = M

function M.new(gamestate)
    local self = setmetatable(MenuGameState.new(gamestate, 'Title'), M)
    self.bg = self.gamestate.images.ui.title
    
    if gamestate.hasProgress() then
        self:addSpace(235)
        self:addButton('Continue', ContinueGameEvent.new())
    else
        self:addSpace(275)
    end
    
    self:addImageButton(gamestate.images.ui.start_btn, NewGameEvent.new())

    self.scene = "Title"

	return self
end

return M