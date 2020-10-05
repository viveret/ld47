local AnimatedActor = require "src.actors.AnimatedActor"
local M = setmetatable({}, { __index = AnimatedActor })
M.__index = M

function M.new(world, name, gamestate, x, y, w, h, anims)
    local self = setmetatable(AnimatedActor.new(
        world, name, gamestate, x, y, w, h, anims, nil), M)
    
    self.type = "player"
    
    return self
end

function M:update(dt)
    local vx, vy = 0, 0

    if lk.isDown('w') then
        vy = -1
        self.animation = self.animations.up
    end
    if lk.isDown('a') then
        vx = -1
        self.animation = self.animations.left
    end
    if lk.isDown('s') then
        vy = 1
        self.animation = self.animations.down
    end
    if lk.isDown('d') then
        vx = 1
        self.animation = self.animations.right
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
        self.animation = self.animations.still
    end

    if self.animation ~= nil then
        self.animation:update(dt)
    end
end

return M