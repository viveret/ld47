local M = {}
M.__index = M
M.__file = __file__()

--[[
    TODO/Nice to have:
        - variable animation speed
        - changes like flipping horizontally once in a while
]]

function M.new(world, x, y, anim, onInteract, label)
    local self = setmetatable({
        x = x,
        y = y,
        hasNotInteractedWith = false,
        onInteract = onInteract,
        animation = anim,
        label = label
    }, M)

    local w, h = self.animation.frameWidth / 8, self.animation.frameHeight / 8
    self.w = w
    self.h = h
    
    self.body = lp.newBody(world, self.x, self.y, "static")
    self.shape = lp.newRectangleShape(w, h)
    self.fixture = lp.newFixture(self.body, self.shape)

    return self
end

function M:getHighlightColor()
    if self.inProximity or self.canInteractWith then
        return { 0, 1, 0 }
    elseif game.debug.renderObjects then
        return { 0, 0, 1 }
    else
        return nil
    end
end

function M:tostring()
    return self.label or '???'
end

function M:draw()
    lg.push()
    lg.translate(floor(self.body:getX()), floor(self.body:getY()))
    self.animation:draw(0, 0)

    local highlightColor = self:getHighlightColor()
    if highlightColor then
        lg.setColor(unpack(highlightColor))
        lg.rectangle('line', self.body:getX(), self.body:getY(), self.w / 8, self.h / 8)
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

function M:interact(player)
    if self.onInteract ~= nil then
        self.onInteract(self, player)
    else
        self.animation.pause = not self.animation.pause
        self.animation.currentTime = self.animation.duration * 0.5
    end
end

function M:update(dt)
    self.animation:update(dt)
end

return M