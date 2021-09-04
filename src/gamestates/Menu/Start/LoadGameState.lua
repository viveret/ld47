local super = require "src.gamestates.Menu.MenuGameState"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new()
    local self = setmetatable(lume.extend(super.new('loadgame', 'LoadGame'), {
    }), M)
    
    self.slots = game.saves.getAll()
    if #self.slots > 0 then
        self.slotsView = uiComponents.SaveSlots.new(self.slots)
        self:addUiElement(self.slotsView)
        
        self:addButton('Clear All', ClearAllSavesEvent.new())
    else
        self:addSpace(240)
        self:addImageButton(game.images.ui.start_btn, NewGameEvent.new())
    end

    self:addBackButton()

	return self
end

return M