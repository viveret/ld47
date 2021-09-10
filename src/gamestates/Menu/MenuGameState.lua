local super = require "src.gamestates.BaseGameState"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

local rootViewType = require "src.components.ui.GroupUIComponent"

function M.new(type, title)
    local self = setmetatable(lume.extend(super.new(title), {
        isMenuGameState = true,
        title = title,
        bgMusicName = "day2",
        root = rootViewType.new(type or 'menu')
    }), M)
    
	return self
end

function M:onCreate(args)
    super.onCreate(self, args)

    self.root.bg = game.images.ui.menu_bg
    self.root.justify = 'center'
    
    self.root:addSpace(60 * 2)
end

function M:onSwitchTo(args)
    super.onSwitchTo(self, args)

    game.audio:play(self.bgMusicName)
    self.root:activated()
end

function M:getWidth()
    return lg.getWidth()
end

function M:getHeight()
    return lg.getHeight()
end

function M:draw()
    self.root.w = self:getWidth()
    self.root.h = self:getHeight()
    self.root:draw()
    -- super.draw(self)
end

function M:tick(ticks)
    -- self.root:tick(ticks)
end

function M:update(dt)
    self.root:update(dt)
    -- super.update(self)
end

function M:onKeyPressed( key, scancode, isrepeat )
    self.root:onKeyPressed( key, scancode, isrepeat )
end

function M:onKeyReleased( key, scancode )
    self.root:onKeyReleased( key, scancode )
end


return M