local super = require "src.gamestates.Transitions.GameStateTransition"
local M = setmetatable({}, { __index = super })
M.__index = M

function M:draw()
end

function M.new(pushOrPop, previousState, futureState, easing, duration)
    return setmetatable(super.new(pushOrPop, previousState, futureState, easing, duration), M)
end

function M:draw()
    lg.push()
        lg.translate(lg.getWidth() * self:progress(), 0)
        lg.push()
            self.previousState:draw()
        lg.pop()
        lg.translate(-lg.getWidth(), 0)
        self.futureState:draw()
    lg.pop()
end

return M