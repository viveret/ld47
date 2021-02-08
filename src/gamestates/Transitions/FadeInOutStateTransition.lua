local super = require "src.gamestates.Transitions.GameStateTransition"
local M = setmetatable({}, { __index = super })
M.__index = M

function M:draw()
end

function M.new(pushOrPop, previousState, futureState, easing, duration)
    return setmetatable(super.new(pushOrPop, previousState, futureState, easing, duration), M)
end

function M:draw()
    local prog = self:progress()
    lg.push()
    if prog < 0.5 then
        self.previousState:draw()
        lg.setColor(0, 0, 0, prog * 2)
        lg.rectangle('fill', 0, 0, lg.getWidth(), lg.getHeight())
    else
        self.futureState:draw()
        lg.setColor(0, 0, 0, 1 - (prog - 0.5) * 2)
        lg.rectangle('fill', 0, 0, lg.getWidth(), lg.getHeight())
    end
    lg.setColor(1, 1, 1, 1)
    lg.pop()
end

return M