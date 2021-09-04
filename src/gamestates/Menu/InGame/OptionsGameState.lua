local super = require "src.gamestates.Menu.MenuGameState"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new(type)
    local self = setmetatable(lume.extend(super.new(type, 'Options'), {
    }), M)
    self.root.justify = 'left'

    self.tabs = uiComponents.navs.TabGroup.new()
    local tsystem = self.tabs:addTab('system', uiComponents.options.SystemOptions.new())
    local taudio = self.tabs:addTab('audio', uiComponents.options.AudioOptions.new())
    local tgraphics = self.tabs:addTab('graphics', uiComponents.options.GraphicsOptions.new())

    self.root:addUiElement(self.tabs)

    self.root:addBackButton()

	return self
end

function M:keypressed( key, scancode, isrepeat )
    if not isrepeat then
        if lume.find({'p', 'escape'}, key) then
            self.root.returnButton:onClick()
            return
        end
    end
    super.keypressed(self, key, scancode, isrepeat)
end

return M