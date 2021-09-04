local super = require "src.gamestates.Menu.MenuGameState"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new()
    local self = setmetatable(lume.extend(super.new('sceneselect', 'SceneSelect'), {
    }), M)
    
    self.slots = game.saves:getAll()
    if #self.slots > 0 then
        self.slotsView = uiComponents.SaveSlots.new(self.slots)
        self:addUiElement(self.slotsView)
    else
        self:addText("No scenes to select from")
    end

    self:addBackButton()

	return self
end

return M