local super = require "src.gamestates.Menu.MenuGameState"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new()
    local self = setmetatable(lume.extend(super.new('Options'), {
        justify = 'left'
    }), M)

    self.tabs = uiComponents.TabGroup.new()
    local tsystem = self.tabs:addTab('system', uiComponents.options.System.new())
    local taudio = self.tabs:addTab('audio', uiComponents.options.Audio.new())
    local tgraphics = self.tabs:addTab('graphics', uiComponents.options.Graphics.new())

    self:addUiElement(self.tabs)

	return self
end

return M