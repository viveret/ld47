local M = {}
M.__index = M

function M.new()
    local self = setmetatable({
        width = 400
    }, M)

	return self
end

function M:draw()
    local player = game.stateMgr:current().player
    if player and player.interactWith and #player.interactWith > 0 then
        lg.push()
        --lg.translate(lg.getWidth() - self:getWidth(), 0)
        game.graphics:drawObject(game.images.ui.clock_bg, 8, 0, self.width, 32 * (#player.interactWith + 1))
        for i,e in ipairs(player.interactWith) do
            game.graphics:drawTextInBox(i .. ") " .. e:tostring(), 8, 32 * i - 16, self.width, 32, game.images.ui.dialog_font, nil, false)
        end
        lg.pop()
    end
end

return M