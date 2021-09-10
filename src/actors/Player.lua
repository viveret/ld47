local AnimatedActor = require "src.actors.AnimatedActor"
local M = setmetatable({}, { __index = AnimatedActor })
M.__index = M
M.__file = __file__()

function M.new(world, name, game, x, y, w, h, anims)
    local self = setmetatable(AnimatedActor.new(
        world, name, game, x, y, w, h, anims, nil), M)
    
    self.type = "player"
    self.assetName = "player"
    self.walkForce = 20
    self.maxVelocity = 20

    self.keyBinds = game.strings.keyBinds
    self.inventory = Inventory.new('player', game.images.ui)
    self.inventory:addItem('apple')

    return self
end

function M:drawTranslate()
    lg.translate(self.x, self.y)
end

function M:update(dt)
    local vx, vy = 0, 0

    if lk.isDown(self.keyBinds.moveUp) then
        vy = -1
        self.animation = self.animations.up
    end
    if lk.isDown(self.keyBinds.moveLeft) then
        vx = -1
        self.animation = self.animations.left
    end
    if lk.isDown(self.keyBinds.moveDown) then
        vy = 1
        self.animation = self.animations.down
    end
    if lk.isDown(self.keyBinds.moveRight) then
        vx = 1
        self.animation = self.animations.right
    end

    if lk.isDown(self.keyBinds.run) then
        vx = vx * 1.75
        vy = vy * 1.75
        AnimatedActor.update(self, dt * .75)
    end

    if self.y < 0 then
        vy = 1
    end

    if self.x < 0 then
        vx = 1
    end

    local currentVx, currentVy = self.body:getLinearVelocity()

    if vx ~= 0 then
        if math.abs(currentVx) < self.maxVelocity * abs(vx) then
            self.body:applyForce(vx * self.walkForce * .5, 0)
        end
    end

    if vy ~= 0 then
        if math.abs(currentVy) < self.maxVelocity * abs(vy) then
            self.body:applyForce(0, vy * self.walkForce * .5)
        end
    end

    AnimatedActor.update(self, dt)
end

function M:onKeyPressed( key, scancode, isrepeat )
    if not isrepeat then
		if self.keyBinds.interact == key then
            self:doInteraction()
            return
		end
	end
end

function M:updateMovingTo(dt)
    return false
end

return M