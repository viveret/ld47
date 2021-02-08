local M = {}
M.__index = M

local _easings = {
    linear = function (v) return v end,
    square = function (v) return v * v end,
    easeInCubic = function (v) return v * v * v end,
    easeOutCubic = function (v) return 1 - pow(1 - v, 3) end,
    easeInOutCubic = function (v) if v < 0.5 then return 4 * v * v * v else return 1 - pow(-2 * v + 2, 3) / 2 end end,
    easeInSin = function (v) return 1 - cos((pi * v) / 2) end,
    easeOutSin = function (v) return sin((pi * v) / 2) end,
    easeInOutSin = function (v) return -(cos(pi * v) - 1) / 2 end,
}

function M.new(pushOrPop, previousState, futureState, easing, duration)
    if pushOrPop ~= 'push' and pushOrPop ~= 'pop' then
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
        easing = _easings[easing] or error ('Could not find easing ' .. easing),
        duration = duration,
        elapsedTime = 0
    }, M)
end

function M:update(dt)
    self.futureState:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    if self.elapsedTime >= self.duration then
        self.elapsedTime = self.duration
        game.stackTransition = nil
        if self.pushOrPop == 'pop' then
            game.pop()
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