local M = {}
M.__index = M

function M.new(world, x, y, img)
    local self = setmetatable({
        image = img,
        gamestate = gamestate,
        x = x,
        y = y
    }, M)

    local w, h = img:getDimensions()
    self.w = w
    self.h = h

    self.body = lp.newBody(world, x, y, "static")
    self.shape = lp.newRectangleShape(w / 8, h / 8)
    self.fixture = lp.newFixture(self.body, self.shape)

    return self
end

function M:draw()
    lg.push()
    lg.translate(-self.w / 16, -self.h / 16)
    lg.draw(self.image, self.body:getX(), self.body:getY(), 0, 1 / 8, 1 / 8)
    if true then -- self.inProximity or self.canInteractWith
        lg.setColor(0, 1, 0)
        lg.rectangle('line', self.body:getX(), self.body:getY(), self.w / 8, self.h / 8)
        lg.setColor(1, 1, 1)
    end
    lg.pop()
end

return M