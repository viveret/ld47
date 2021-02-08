local M = {}
M.__index = M

function M.new()
    local self = setmetatable({
    }, M)

	return self
end

function M:draw()
    lg.push()
    lg.translate(0, lg.getHeight() - 48)
    
    local dt = game.time

    local timeWidth = 120
	game.graphics:drawObject(game.images.ui.clock_bg, 0, 0, timeWidth, 64)
    game.graphics:drawTextInBox(dt:timeShort(), 0, -8, timeWidth, 64, game.images.ui.dialog_font, nil, true)

    local dateWidth = 130
	game.graphics:drawObject(game.images.ui.clock_bg, lg.getWidth() - dateWidth, 0, dateWidth, 64)
    game.graphics:drawTextInBox(dt:dateShort(), lg.getWidth() - dateWidth, -8, dateWidth, 64, game.images.ui.dialog_font, nil, true)
    
    lg.pop()
end

return M