local M = {}
M.__index = M

function M.new(bodyToFollow)
    local self = setmetatable({
        x = 0,
        y = 0,
        vx = 0,
        vy = 0,
        ax = 0,
        ay = 0,
        scalex = 16,
        scaley = 16,
        rotate = 0,
        bodyToFollow = bodyToFollow
	}, M)
	return self
end

function M:draw()
    local w, h = lg.getWidth(), lg.getHeight()
    lg.translate(w / 2, h / 2)
    lg.scale(self.scalex, self.scaley)
    lg.translate(-min(self.x, w / 2 / self.scalex), -max(self.y, h / 2 / self.scalex))
    if self.rotate ~= 0 then
        lg.rotate(self.rotate)
    end
end

function M:update(dt)
    if self.bodyToFollow ~= nil then
        local x, y = self.bodyToFollow:getPosition()
        self.x = self.x + (x - self.x) / 2
        self.y = self.y + (y - self.y) / 2
    end
    --self.ax -= self.
end

function M:reset()
    
end

return M