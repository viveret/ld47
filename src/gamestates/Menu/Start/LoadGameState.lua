local super = require "src.gamestates.Menu.MenuGameState"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new()
    local self = setmetatable(lume.extend(super.new('loadgame', 'LoadGame'), {
    }), M)
    
    self.slots = game.saves:getAll()
    print("slots: " .. inspect(self.slots))
    if #self.slots > 0 then
        self.slotsView = uiComponents.SaveSlots.new(self.slots)
        self.root:addUiElement(self.slotsView)
        
        self.root:addButton('Clear All', ClearAllSavesEvent.new())
    end

    self.root:addBackButton()

	return self
end

return M