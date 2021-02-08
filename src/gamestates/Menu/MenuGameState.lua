local super = require "src.components.ui.GroupUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new(type, title)
    local self = setmetatable(lume.extend(super.new(type or 'menu'), {
        title = title,
        bgMusicName = "day2",
        bg = game.images.ui.menu_bg,
        justify = 'center',
    }), M)
    
    self:addSpace(60 * 2)
    
	return self
end

function M:activated()
    game.audio:play(self.bgMusicName)
    super.activated(self)
end

function M:getWidth()
    return lg.getWidth()
end

function M:getHeight()
    return lg.getHeight()
end

return M