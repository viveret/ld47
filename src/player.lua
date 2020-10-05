local M = {}
M.__index = M

function M.new(world, spritesheet, x, y)
    local self = setmetatable({
        x = x,
        y = y,
        w = 4,
        h = 4,
        world = world,
        walkForceX = 0.25,
        walkForceY = 0.25,
        positionIsCenter = true,
        maxVelocity = 30,
        type = "player",
        interactWith = {}
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

function M:setPosition(x, y, vX, vY)
    self.body:setX(x)
    self.body:setY(y)
    self.body:setLinearVelocity(vX, vY)
end

function M:draw()
    if self.activeAnimation == nil then
        self.activeAnimation = self.animations.idle
    end

    lg.push()
    if self.positionIsCenter then
        self.activeAnimation:draw(self.body:getX() - self.w, self.body:getY() - self.h)
    else
        self.activeAnimation:draw(self.body:getX(), self.body:getY())
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

    self.y = self.body:getY()
    if self.y < 0 then
        vy = abs(vy)
    end

    self.x = self.body:getX()
    if self.x < 0 then
        vx = abs(vx)
    end

    if currentVx == 0 and currentVy == 0 then
        self.activeAnimation = self.animations.idle
    end

    if self.activeAnimation ~= nil then
        self.activeAnimation:update(dt)
    end


    if lk.isDown('space') and #self.interactWith > 0 then
        for _,v in pairs(self.interactWith) do
            v:interact(self)
        end
    end
end

return M