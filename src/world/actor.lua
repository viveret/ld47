local M = {}
M.__index = M

function M.new(world, gamestate, x, y, spriteSheetStill, spritesheetUp, spritesheetDown, spritesheetLeft, spritesheetRight, callback)
    local self = setmetatable({
        width = 4,
        height = 4,
        movingTo = nil,
        type = "actor"
    }, M)

    self.spriteSheetStill = spriteSheetStill
    self.spritesheetUp = spritesheetUp
    self.spritesheetDown = spritesheetDown
    self.spritesheetLeft = spritesheetLeft
    self.spritesheetRight = spritesheetRight
    self.callback = callback

    local trueX = x - self.width / 2
    local trueY = y - self.height / 2

    self.animation = self.spriteSheetStill
    self.body = lp.newBody(world, trueX, trueY, "dynamic")
    self.shape = lp.newRectangleShape(self.width, self.height)
    self.fixture = lp.newFixture(self.body, self.shape)

    self.fixture:setUserData(self)

    return self
end

function M:draw() 
    self.animation:draw(self.body:getX(), self.body:getY())
end

function M:moveTo(x, y, speed)
    self.movingTo = {
        x = x - self.width / 2,
        y = y - self.height / 2,
        speed = speed
    }
end

function M:update(dt)
    if self.movingTo ~= nil then
        local leftX = self.body:getX()
        local topY = self.body:getY()

        local x = leftX + self.width / 2
        local y = topY + self.height / 2

        local dirX = self.movingTo.x - x
        local dirY = self.movingTo.y - y

        local dist = math.sqrt(dirX*dirX + dirY*dirY)

        if dist < 1 then
            -- made it, stop it and end the block
            self.movingTo = nil
            self.animation = self.spriteSheetStill
            self.body:setLinearVelocity(0, 0)
            self.animation:update(dt)
            return
        end

        dirX = dirX / dist
        dirY = dirY / dist

        local speed = self.movingTo.speed

        local velX = speed * dirX
        local velY = speed * dirY

        self.body:setLinearVelocity(velX, velY)

        if math.abs(velX) > math.abs(velY) then
            if velX < 0 then
                self.animation = self.spritesheetLeft
            else
                self.animation = self.spritesheetRight
            end
        else
            if velY < 0 then
                self.animation = self.spritesheetUp
            else
                self.animation = self.spritesheetDown
            end
        end

        self.animation:update(dt)
    else
        self.body:setLinearVelocity(0, 0)
        self.animation:update(dt)
    end
end

return M