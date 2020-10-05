local M = {}
M.__index = M

function M.new(world, img, x, y)
    local self = setmetatable({
        image = img,
        gamestate = gamestate,
        x = x,
        y = y
    }, M)

    self.body = lp.newBody(world, self.x, self.y, "static")
    
    local w, h = img:getDimensions()
    self.shape = lp.newRectangleShape(w / 8, h / 8)
    self.fixture = lp.newFixture(self.body, self.shape)

    return self
end

function M:draw()
    lg.draw(self.image, self.body:getX(), self.body:getY(), 0, 1 / 8, 1 / 8)
end

return M