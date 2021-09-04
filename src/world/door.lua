local M = {}
M.__index = M
M.__file = __file__()

local animation = require "src.animation"

function M.new(anim, x, y)
    if anim == nil then
        error ('anim must not be null')
    end

    local self = setmetatable({
        spritesheet = spritesheet,
        x = x,
        y = y
    }, M)

    self.animation = anim

    return self
end

function M:draw() 
    self.animation:draw(self.x, self.y)
    if game.debug.renderFilenames then
        lg.push()
        lg.scale(1 / 8, 1 / 8)
        local msg = "<" .. self.__file .. ">\n"
        lg.print(msg, 0, 0)
        lg.pop()
    end
end

function M:update(dt)
    if self.animate then
        self.animation:update(dt)
        if self.animation.loopCount > 0 then
            self.animate = false
            game.fire(events.WarpEvent.new(self.path), true)
        end
    end
end

function M:animateAndWarp(gs, path)
    game = gs
    self.path = path
    self.animate = true
end

return M