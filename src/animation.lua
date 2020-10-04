local M = {}
M.__index = M

function M.new(img, frameWidth, frameHeight, firstFrameIndex, frameCount, currentTime, duration, flipHorizontal)
    local self = setmetatable({
        spritesheet = img,
        currentTime = currentTime,
        duration = duration,
        quads = {},
        flipHorizontal = flipHorizontal or false,
        frameWidth = frameWidth,
        frameHeight = frameHeight
    }, M)

    for f = 0, frameCount - 1 do
        y = frameHeight * (firstFrameIndex + f)
        table.insert(self.quads, lg.newQuad(0, y, frameWidth, frameHeight, img:getDimensions()))
    end

    return self
end

function M:draw(x, y, noScale)
    local spriteIdx = math.floor(self.currentTime / self.duration * #self.quads) + 1

    local scale = 1
    if not noScale then
        scale = scale / 8
    end

    if self.flipHorizontal then
        lg.draw(self.spritesheet, self.quads[spriteIdx], x, y, 0, -scale, scale, self.frameWidth, 0)
    else
        lg.draw(self.spritesheet, self.quads[spriteIdx], x, y, 0, scale, scale)
    end
end

function M:update(dt) 
    self.currentTime = self.currentTime + dt
    if self.currentTime >= self.duration then
        self.currentTime = self.currentTime - self.duration
    end
end

function M:getFrameSize()
    return { width = self.frameWidth, height = self.frameHeight }
end

return M