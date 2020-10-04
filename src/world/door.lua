local M = {}
M.__index = M

local animation = require "src.animation"

function M.new(world, spritesheet, x, y)
    local self = setmetatable({
        spritesheet = spritesheet,
        x = x,
        y = y
    }, M)

    self.animation = animation.new(self.spritesheet, 80, 72, 0, 6, 0, 1, doWarp)
--    self.body = lp.newBody(world, self.x, self.y, "static")
--    self.shape = lp.newRectangleShape(9, 9)
--    self.fixture = lp.newFixture(self.body, self.shape)
--    self.fixture:setUserData("door")

    return self
end

function M:draw() 
    --self.animation:draw(self.body:getX(), self.body:getY())
    self.animation:draw(self.x, self.y)
    -- lg.setColor(0, 0, 1)
    -- lg.rectangle("line", self.body:getX(), self.body:getY(), 9, 9)
    -- lg.setColor(1,1,1)
end

function M:doWarp()
    self.animate = false
    self.gamestate.fire(WarpEvent.new(self.path), true)
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