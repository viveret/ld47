local super = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new()
    return setmetatable(super.new("QuickSave"), M)
end

function M:fireOn()
    local saving = uiComponents.widgets.Saving.new()
    game.ui.overlay:addUiElement(saving)
    local promise = game.quicksave() -- self.autosave or false
    if promise then
        promise:next(
                    function()
                        saving:transitionThenRemoveFromParent()
                    end
                )
    else
        saving:transitionThenRemoveFromParent()
    end
end

return M