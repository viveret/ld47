local M = {}
M.__index = M

local animation = require "src.animation"

function M.new(world, spritesheet, x, y)
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
    
    self.animations = {
        idle = animation.new(spritesheet, 0, 3, 0, 1),
        down = animation.new(spritesheet, 3, 6, 0, 1),
        up = animation.new(spritesheet, 9, 6, 0, 1),
        right = animation.new(spritesheet, 15, 6, 0, 1),
        left = animation.new(spritesheet, 15, 6, 0, 1, true)
    }
	return self
end

function M:draw()
    if self.activeAnimation == nil then
        self:setActiveAnimation(self.animations.idle)
    end

    lg.push()
    --lg.scale(1 / 64, 1 / 64)
    if self.positionIsCenter then
        self.activeAnimation:draw(self.body:getX() - self.w / 2, self.body:getY() - self.h / 2)
        --lg.rectangle("fill", self.body:getX(), self.body:getY(), self.w, self.h)
    else
        self.activeAnimation:draw(self.body:getX(), self.body:getY())
        --lg.rectangle("fill", self.body:getX(), self.body:getY(), self.w, self.h)
    end
    lg.pop()
end

function M:update(dt)
    local vx, vy = 0, 0

    if lk.isDown('w') then
        vy = -1
        self:setActiveAnimation(self.animations.up, dt)
<<<<<<< HEAD
    end
    if lk.isDown('a') then
        vx = -1
        self:setActiveAnimation(self.animations.left, dt)
    end
    if lk.isDown('s') then
        vy = 1
        self:setActiveAnimation(self.animations.down, dt)
    end
    if lk.isDown('d') then
        vx = 1
        self:setActiveAnimation(self.animations.right, dt)
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

    -- todo: also check for ongoing movement
    if vx == 0 and vy == 0 then
=======
    elseif lk.isDown('a') then
        if self.body:getX() > 0 then
            self.body:applyLinearImpulse(-50, 0)
        else
            self.body:setLinearVelocity(0, 0)
        end
        self:setActiveAnimation(self.animations.left, dt)
    elseif lk.isDown('s') then
        if self.body:getY() < lg.getHeight() - 64 then
            self.body:applyLinearImpulse(0, 50)
        else
            self.body:setLinearVelocity(0, 0)
        end
        self:setActiveAnimation(self.animations.down, dt)
    elseif lk.isDown('d') then
        if self.body:getX() < lg.getWidth() - 64 then
            self.body:applyLinearImpulse(50, 0)
        else
            self.body:setLinearVelocity(0, 0)
        end
        self:setActiveAnimation(self.animations.right, dt)
    else
        self.body:setLinearVelocity(0, 0)
>>>>>>> player: wire left/right animations
        self:setActiveAnimation(self.animations.idle, dt)
    end
    --self.body:setLinearVelocity(vx, vy)
    --self.body:applyLinearImpulse(vx, vy)
end

function M:setActiveAnimation(animation, dt)
    dt = dt or 0
    self.activeAnimation = animation
    self.activeAnimation:update(dt)
end

return M