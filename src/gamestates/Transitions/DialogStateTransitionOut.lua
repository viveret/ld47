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
    self.futureState:draw()
    lg.pop()

    lg.push()
    lg.translate(0, -lg.getHeight() * self:progress())
    self.previousState:draw()
    lg.pop()
end

return M