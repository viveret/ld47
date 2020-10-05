local M = {}
M.__index = M

function M.new(img, frameWidth, frameHeight, firstFrameIndex, frameCount, currentTime, duration, flipHorizontal, runOnlyOnce)
    if img == nil then
        error ('img must not be nil')
    end

    local self = setmetatable({
        spritesheet = img,
        currentTime = currentTime,
        duration = duration,
        quads = {},
        flipHorizontal = flipHorizontal or false,
        frameWidth = frameWidth,
        frameHeight = frameHeight,
        runOnlyOnce = runOnlyOnce,
        clipW = 0.5,
        clipH = 0.5,
        pause = false,
        loopCount = 0
    }, M)

    if frameCount > 0 then
        for f = 0, frameCount - 1 do
            local y = frameHeight * (firstFrameIndex + f)
            table.insert(self.quads, lg.newQuad(0, y + self.clipH, frameWidth, frameHeight - self.clipH * 2, img:getDimensions()))
        end
    else
        error ('frameCount must be greater than 0')
    end

    return self
end

function M:draw(x, y, noScale)
    local spriteIdx = math.floor(self.currentTime / self.duration * #self.quads) + 1
    local quad = self.quads[spriteIdx]

    if #self.quads == 0 or quad == nil then
        return
    end

    local scale = 1
    if not noScale then
        scale = scale / 8
    end
    if self.flipHorizontal then
        lg.draw(self.spritesheet, quad, x, y, 0, -scale, scale, self.frameWidth, 0)
    else
        lg.draw(self.spritesheet, quad, x, y, 0, scale, scale)
    end
end

function M:update(dt) 
    if self.pause then
        return
    end
    
    self.currentTime = self.currentTime + dt
    if self.currentTime >= self.duration then
        self.loopCount = self.loopCount + 1
        if self.runOnlyOnce then
            self.pause = true
            self.currentTime = 0
        else
            self.currentTime = self.currentTime - self.duration
        end
    end
end

function M:getFrameSize()
    return { width = self.frameWidth, height = self.frameHeight }
end

return M