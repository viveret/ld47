local M = {}
M.__index = M

local frameSize = 64;

function M.new(img, firstFrameIndex, frameCount, currentTime, duration, flipHorizontal)
    local self = setmetatable({
        spritesheet = img,
        currentTime = currentTime,
        duration = duration,
        quads = {},
        flipHorizontal = flipHorizontal or false
    }, M)

    for f = 0, frameCount - 1 do
        y = frameSize * (firstFrameIndex + f)
        table.insert(self.quads, lg.newQuad(0, y, frameSize, frameSize, img:getDimensions()))
    end

    return self
end

function M:draw(x, y)
    local spriteIdx = math.floor(self.currentTime / self.duration * #self.quads) + 1

<<<<<<< HEAD
    if flipHorizontal then
        lg.draw(self.spritesheet, self.quads[spriteIdx], x, y, 0, -1 / 16, 1 / 16, 4, 0)
    else
        lg.draw(self.spritesheet, self.quads[spriteIdx], x, y, 0, 1 / 16, 1 / 16)
=======
    if self.flipHorizontal then
        lg.draw(self.spritesheet, self.quads[spriteIdx], x, y, 0, -1, 1, frameSize, 0)
    else
        lg.draw(self.spritesheet, self.quads[spriteIdx], x, y)
>>>>>>> player: wire left/right animations
    end
end

function M:update(dt) 
    self.currentTime = self.currentTime + dt
    if self.currentTime >= self.duration then
        self.currentTime = self.currentTime - self.duration
    end
end

return M