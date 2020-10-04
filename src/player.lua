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
        walkForceX = 0.5,
        walkForceY = 0.5,
        positionIsCenter = true,
        maxVelocity = 30,
        type = "player"
	}, M)
    self.body = lp.newBody(world, self.x, self.y, "dynamic")
    self.body:setMass(self.body:getMass() * 20)
    self.shape = lp.newRectangleShape(self.w, self.h)
    self.fixture = lp.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
    
    self.animations = {
        idle = animation.new(spritesheet, 64, 64, 0, 3, 0, 1),
        down = animation.new(spritesheet, 64, 64, 3, 6, 0, 1),
        up = animation.new(spritesheet, 64, 64, 9, 6, 0, 1),
        right = animation.new(spritesheet, 64, 64, 15, 6, 0, 1),
        left = animation.new(spritesheet, 64, 64, 15, 6, 0, 1, true)
    }
	return self
end

function M:draw()
    if self.activeAnimation == nil then
        self.activeAnimation = self.animations.idle
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
        self.activeAnimation = self.animations.up
    end
    if lk.isDown('a') then
        vx = -1
        self.activeAnimation = self.animations.left
    end
    if lk.isDown('s') then
        vy = 1
        self.activeAnimation = self.animations.down
    end
    if lk.isDown('d') then
        vx = 1
        self.activeAnimation = self.animations.right
    end

    if vx == 0 and vy == 0 then
        self.body:setLinearDamping(10)
    else
        self.body:setLinearDamping(0)
    end

    local currentVx, currentVy = self.body:getLinearVelocity()

    if vx ~= 0 then
        if math.abs(currentVx) < self.maxVelocity then
            self.body:applyForce(vx * self.walkForceX, 0)
        end
    else
        --local dampingDir = currentVx < 0 and 1 or -1
        --self.body:applyForce(dampingDir * self.dampingFactor * self.walkForceX, 0)
        --self.body:setLinearVelocity(0, currentVy)
    end

    if vy ~= 0 then
        if math.abs(currentVy) < self.maxVelocity then
            self.body:applyForce(0, vy * self.walkForceY)
        end
    else
        -- local dampingDir = currentVy < 0 and 1 or -1
        -- self.body:applyForce(0, dampingDir * self.dampingFactor * self.walkForceY)
        --self.body:setLinearVelocity(currentVx, 0)
    end

    if self.body:getY() < 0 then
        vy = abs(vy)
    end

    if self.body:getX() < 0 then
        vx = abs(vx)
    end

    if currentVx == 0 and currentVy == 0 then
        self.activeAnimation = self.animations.idle
    end

    if self.activeAnimation ~= nil then
        self.activeAnimation:update(dt)
    end
end

return M