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
        self:addButton('Back', WarpEvent.new('title'))
    else
        self:addSpace(240)
        self:addImageButton(game.images.ui.start_btn, NewGameEvent.new())
    end

    self.scene = "LoadGame"

	return self
end

function M:keypressed( key, scancode, isrepeat )
    -- if not isrepeat then
    --     if lume.find({'space', 'return'}, key) then
    --         game.fire(NewGameEvent.new(), true)
    --         return
    --     end
    -- end
    super.keypressed(self, key, scancode, isrepeat)
end

return M