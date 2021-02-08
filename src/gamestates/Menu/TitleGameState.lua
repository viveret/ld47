local super = require "src.gamestates.Menu.MenuGameState"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new()
    local self = setmetatable(lume.extend(super.new('title', 'Title'), {
    }), M)
    self.bg = game.images.ui.title
    
    if #game.saves:getAll() > 0 then
        self:addSpace(190)
        self:addButton('Continue', ContinueGameEvent.new())
        self:addButton('Load', WarpEvent.new('loadgame'))
    else
        self:addSpace(240)
    end
    
    self:addImageButton(game.images.ui.start_btn, NewGameEvent.new())

    self:addButton('Options', WarpEvent.new('options'))

    self.scene = "Title"

	return self
end

function M:keypressed( key, scancode, isrepeat )
    if not isrepeat then
        if lume.find({'space', 'return'}, key) then
            game.fire(NewGameEvent.new(), true)
            return
        end
    end
    super.keypressed(self, key, scancode, isrepeat)
end

return M