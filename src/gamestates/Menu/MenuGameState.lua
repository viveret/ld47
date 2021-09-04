local super = require "src.gamestates.BaseGameState"
local M = setmetatable({}, { __index = super })
M.__index = M

local rootViewType = require "src.components.ui.GroupUIComponent"

function M.new(type, title)
    local self = setmetatable(lume.extend(super.new(title), {
        isMenuGameState = true,
        title = title,
        bgMusicName = "day2",
        root = rootViewType.new(type or 'menu')
    }), M)

    self.root.bg = game.images.ui.menu_bg
    self.root.justify = 'center'
    
    self.root:addSpace(60 * 2)
    
	return self
end

function M:activated()
    game.audio:play(self.bgMusicName)
    self.root:activated()
    --super.activated(self)
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

function M:save()
end

function M:load()
end

function M:keypressed( key, scancode, isrepeat )
    self.root:keypressed( key, scancode, isrepeat )
end

function M:keyreleased( key, scancode )
    self.root:keyreleased( key, scancode )
end


return M