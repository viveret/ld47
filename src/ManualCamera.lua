local M = {}
M.__index = M

function M.new(game, attachedState, oldCamera, endX, endY, duration, hold)
    local self = setmetatable({
        game = game,
        attachedState = attachedState,
        oldCamera = oldCamera,
        x = oldCamera.x,
        y = oldCamera.y,
        stepX = (endX - oldCamera.x) / duration,
        stepY = (endY - oldCamera.y) / duration,
        duration = duration,
        hold = hold,
        passedTicks = 0,
        vx = 0,
        vy = 0,
        ax = 0,
        ay = 0,
        scalex = 8,
        scaley = 8,
        rotate = 0,
	}, M)

	return self
end

function M:draw()
    local w, h = lg.getWidth(), lg.getHeight()
    lg.translate(w / 2, h / 2)
    lg.scale(self.scalex, self.scaley)
    lg.translate(-self.x, -self.y)
    if self.rotate ~= 0 then
        lg.rotate(self.rotate)
    end
end

function M:update(dt)
    local transitionUntil = self.duration
    local holdUntil = transitionUntil + self.hold
    local transitionBackUntil = holdUntil + self.duration


    if self.passedTicks < transitionUntil then
        -- pan to where we need to go
        self.x = self.x + self.stepX
        self.y = self.y + self.stepY
    elseif self.passedTicks < holdUntil then
        -- just wait, staring
    elseif self.passedTicks < transitionBackUntil then
        -- pan back to the old camera

        self.oldCamera:update(dt)
        local moveBackToX = self.oldCamera.x
        local moveBackToY = self.oldCamera.y
        
        local remainingTicks = transitionBackUntil - self.passedTicks

        local distX = moveBackToX - self.x
        local distY = moveBackToY - self.y

        local stepX = distX / remainingTicks
        local stepY = distY / remainingTicks

        self.x = self.x + stepX
        self.y = self.y + stepY
    else
        -- time to die
        self.attachedState:removeCamera(self)
    end

    self.passedTicks = self.passedTicks + 1
end

function M:reset()
    
end

return M