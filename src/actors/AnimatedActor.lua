local BaseActor = require "src.actors.BaseActor"
local M = setmetatable({}, { __index = BaseActor })
M.__index = M
M.__file = __file__()

function M.new(world, name, game, x, y, w, h, anims, callback)
    if anims == nil then
        error('anims must not be nil')
    end

    w = w or (anims.still.frameWidth / 8 * 0.9)
    h = h or (anims.still.frameHeight / 8 * 0.9)
    local self = setmetatable(BaseActor.new(
        world, name, game, x, y, w, h, callback
    ), M)
    
    self.animations = anims
    self.animation = self.animations.still
    
    return self
end

function M:updateMovingTo(dt)
    local ret = BaseActor.updateMovingTo(self, dt)
    if ret then
        self.animation = self.animations.still
    end
    return ret
end

function M:update(dt)
    BaseActor.update(self, dt)
    self:updateAnimation(dt)
end

function M:updateAnimation(dt)
    local currentVx, currentVy = self.body:getLinearVelocity()
    if abs(currentVx) + abs(currentVy) < self.walkForce / 4 then
        self.animation = self.animations.still
    end

    if self.animation ~= nil then
        self.animation:update(dt)
    end
end

function M:drawTranslate()
    lg.translate(floor(self.x), floor(self.y))
end

function M:draw()
    lg.push()
    self:drawTranslate()
    self.animation:draw(0, 0)
    if self.inProximity or self.canInteractWith then
        lg.setColor(0, 1, 0)
        lg.rectangle('line', 0, 0, self.animation.frameWidth / 8, self.animation.frameHeight / 8)
        lg.setColor(1, 1, 1)
    end

    if game.debug.renderActors then
        lg.setColor(0, 1, 1)
        lg.rectangle('line', 0, 0, self.width, self.height)
        lg.setColor(1, 1, 1)
    end

    if game.debug.renderFilenames then
        lg.push()
        lg.scale(1 / 8, 1 / 8)
        local msg = "<" .. self.__file .. ">\n"
        lg.print(msg, 0, 0)
        lg.pop()
    end
    lg.pop()
end

return M