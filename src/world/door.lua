local M = {}
M.__index = M

local animation = require "src.animation"

function M.new(world, spritesheet, x, y)
    local self = setmetatable({
        spritesheet = spritesheet,
        x = x,
        y = y
    }, M)

    local doWarp = function ()
        self.animate = false
        self.gamestate.fire(WarpEvent.new(self.path), true)
    end

    self.animation = animation.new(self.spritesheet, 80, 72, 0, 6, 0, 1, false, doWarp)

    return self
end

function M:draw() 
    self.animation:draw(self.x, self.y)
end

function M:update(dt)
    if self.animate then
        self.animation:update(dt)
    end
end

function M:animateAndWarp(gs, path)
    self.gamestate = gs
    self.path = path
    self.animate = true
end

return M