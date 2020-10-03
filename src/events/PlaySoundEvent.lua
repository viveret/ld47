local M = {}

function M.fireOn(self, gs)
    love.audio.play(self.path)
end

return M