local M = {}
M.__index = M

function M.new(gamestate, bodyToFollow)
    local self = setmetatable({
        gamestate = gamestate,
        x = 0,
        y = 0,
        vx = 0,
        vy = 0,
        ax = 0,
        ay = 0,
        scalex = 8,
        scaley = 8,
        rotate = 0,
        bodyToFollow = bodyToFollow
	}, M)
    if self.bodyToFollow ~= nil then
        local x, y = self.bodyToFollow:getPosition()
        self:setPosition(x, y)
    end
	return self
end

function M:draw()
    local w, h = lg.getWidth(), lg.getHeight()
    lg.translate(w / 2, h / 2)
    lg.scale(self.scalex, self.scaley)
    lg.translate(-self.x, -self.y)
    if self.rotate ~= 0 then
        lg.rotate(self.rotate)
    end
end

function M:update(dt)
    if self.bodyToFollow ~= nil then
        local x, y = self.bodyToFollow:getPosition()
        self:setPosition(x, y)
    end
end

function M:refresh(dt)
    if self.bodyToFollow ~= nil then
        local x, y = self.bodyToFollow:getPosition()
        self:setPosition(x, y)
    end
end

function M:setPosition(x, y)
    local hw = lg.getWidth() / 16
    local hh = lg.getHeight() / 16
    self.x = min(max(self.x + (x - self.x) / 2, hw), self.gamestate:getWidth() - hw)
    self.y = min(max(self.y + (y - self.y) / 2, hh), self.gamestate:getHeight() - hh)
end

function M:reset()
    
end

return M