local M = {}
M.__index = M

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
end

function M:update(dt)
    if self.animate then
        self.animation:update(dt)
        if self.animation.loopCount > 0 then
            self.animate = false
            game.fire(WarpEvent.new(self.path), true)
        end
    end
end

function M:animateAndWarp(gs, path)
    game = gs
    self.path = path
    self.animate = true
end

return M