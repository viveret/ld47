local M = {}
M.__index = M
M.__file = __file__()

function M.new(pushOrPop, previousState, futureState, easing, duration)
    if lume.find({pushOrPop, 'return', 'escape'}, key) ~= nil then
        error ('pushOrPop must be push or pop')
    elseif previousState == nil then
        error ('previousState is nil')
    elseif futureState == nil then
        error ('futureState is nil')
    end
    
    if easing == nil then
        easing = 'easeInOutCubic'
    end
    
    if duration == nil then
        duration = 1 -- default 1 second
    end

    return setmetatable({
        pushOrPop = pushOrPop,
        previousState = previousState,
        futureState = futureState,
        easing = easings[easing] or error ('Could not find easing ' .. easing),
        duration = duration,
        elapsedTime = 0,
    }, M)
end

function M:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    if self.elapsedTime >= self.duration then
        self.elapsedTime = self.duration
        game.stackTransition = nil
        
        if self.pushOrPop == 'pop' then
            game.popTop()
        elseif self.pushOrPop == 'remove' then
            local indexStart = lume.find(game.stack, self.futureState)
            local indexEnd = lume.find(game.stack, self.previousState)

            game.remove(indexStart, indexEnd)
        else
            game.push(self.futureState)
        end
    end
end

function M:progress()
    return self.easing(self.elapsedTime / self.duration)
end

function M:draw()
    lg.push()
        lg.translate(-lg.getWidth() * self:progress(), 0)
        lg.push()
            self.previousState:draw()
        lg.pop()
        lg.translate(lg.getWidth(), 0)
        self.futureState:draw()
    lg.pop()
end

return M