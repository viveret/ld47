local super = require "src.gamestates.Menu.MenuGameState"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new()
    local self = setmetatable(lume.extend(super.new(nil, 'Debug'), {
    }), M)

    self.tabs = uiComponents.navs.TabGroup.new()
    local tsystem = self.tabs:addTab('system', uiComponents.debug.SystemDebug.new())
    local tgamedata = self.tabs:addTab('gamedata', uiComponents.debug.GameDataDebug.new())
    local tgraphics = self.tabs:addTab('graphics', uiComponents.debug.GraphicsDebug.new())

    self.root:addUiElement(self.tabs)

    self.root:addBackButton()

	return self
end

return M