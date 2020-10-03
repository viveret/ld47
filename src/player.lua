local M = {}
M.__index = M

local animation = require "src.animation"

function M.new(world, gfx, x, y)
    local self = setmetatable({
        x = x,
        y = y,
        w = 4,
        h = 4,
        world = world,
        walkForceX = 0.125,
        walkForceY = 0.125,
        positionIsCenter = true
	}, M)
    self.body = lp.newBody(world, self.x, self.y, "dynamic")
    self.body:setLinearDamping(0.9)
    self.body:setMass(self.body:getMass() * 20)
    self.shape = lp.newRectangleShape(self.w, self.h)
    self.fixture = lp.newFixture(self.body, self.shape)
    self.idleAnimation = animation.new(gfx.Player, 0, 3, 0, 1)
	return self
end

function M:draw()
    lg.push()
    --lg.scale(1 / 64, 1 / 64)
    if self.positionIsCenter then
        self.idleAnimation:draw(self.body:getX() - self.w / 2, self.body:getY() - self.h / 2)
        --lg.rectangle("fill", self.body:getX(), self.body:getY(), self.w, self.h)
    else
        self.idleAnimation:draw(self.body:getX(), self.body:getY())
        --lg.rectangle("fill", self.body:getX(), self.body:getY(), self.w, self.h)
    end
    lg.pop()
end

function M:update(dt)
    local vx, vy = 0, 0

    if lk.isDown('w') then
        vy = -1
    end
    if lk.isDown('a') then
        vx = -1
    end
    if lk.isDown('s') then
        vy = 1
    end
    if lk.isDown('d') then
        vx = 1
    end

    if vx ~= 0 then
        self.body:applyForce(vx * self.walkForceX, 0)
    end

    if vy ~= 0 then
        self.body:applyForce(0, vy * self.walkForceY)
    end
    
    if self.body:getY() < 0 then
        vy = abs(vy)
    end

    if self.body:getX() < 0 then
        vx = abs(vx)
    end
    --self.body:setLinearVelocity(vx, vy)
    --self.body:applyLinearImpulse(vx, vy)


    self.idleAnimation:update(dt)
end

return M