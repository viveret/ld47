local M = {}
M.__index = M

function M.new(world, name, game, x, y, w, h, callback)
    local self = setmetatable({
        type = "actor",
        width = w,
        height = h,
        name = name,
        game = game,
        walkForce = 12,
        maxVelocity = 12,
        interactWith = {}
	}, M)

    self.body = lp.newBody(world, x, y, "dynamic")
    self.shape = lp.newRectangleShape(self.width, self.height)
    self.fixture = lp.newFixture(self.body, self.shape)
    self.body:setLinearDamping(self.walkForce / 2)
    self.fixture:setUserData(self)

    self:pullPositionFromBody()

    if callback ~= nil then
        self.interactionCallback = callback
        self.isInteractable = true
        self.interactWith = { }
    end

	return self
end

function M:onRemove()
    self.body:destroy()
    self.body = nil
end

function M:moveTo(x, y, speed)
    self.movingTo = {
        x = x,
        y = y,
        speed = speed
    }
end

function M:setPosition(x, y, vX, vY)
    self.body:setX(x)
    self.body:setY(y)
    self.body:setLinearVelocity(vX, vY)
    self:update(0)
end

function M:doInteraction()
    local ct = #self.interactWith
    if ct > 0 then
        for _,v in pairs(self.interactWith) do
            v:interact(self)
        end
    end
end

function M:interact(player)
    if self.interactionCallback ~= nil then
        self.interactionCallback(game, player, "action")
    end
end

function M:pullPositionFromBody()
    self.x = self.body:getX() - self.width / 2
    self.y = self.body:getY() - self.height / 2
end

function M:update(dt)
    self:pullPositionFromBody()

    if self:updateMovingTo(dt) then
        self.body:setLinearVelocity(0, 0)
    end
end

function M:updateMovingTo(dt)
    if self.movingTo ~= nil then
        local dirX = self.movingTo.x - self.x
        local dirY = self.movingTo.y - self.y

        local dist = math.sqrt(dirX*dirX + dirY*dirY)

        if dist < 1.1 then
            self.movingTo = nil
            return true
        end

        dirX = dirX / dist
        dirY = dirY / dist

        local speed = self.movingTo.speed

        local velX = speed * dirX
        local velY = speed * dirY

        self.body:setLinearVelocity(velX, velY)

        if self.animations ~= nil then
            if math.abs(velX) > math.abs(velY) then
                if velX < 0 then
                    self.animation = self.animations.left
                else
                    self.animation = self.animations.right
                end
            else
                if velY < 0 then
                    self.animation = self.animations.up
                else
                    self.animation = self.animations.down
                end
            end
        end

        return false
    else
        return true
    end
end

return M