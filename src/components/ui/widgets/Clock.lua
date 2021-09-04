local M = {}
M.__index = M
M.__file = __file__()

function M.new()
    local self = setmetatable({
        dateWidth = 130,
        timeWidth = 180,
        borderWidth = 2,
        radius = 10,
        startAngle = -math.pi / 2,
        secondsColor = {
            fg = {
                r = 1,
                g = 1,
                b = 1,
                a = 0.1,
            },
            bg = {
                r = 0,
                g = 0,
                b = 0,
                a = 0.1,
            }
        },
        dateColor = {
            fg = {
                r = 1,
                g = 1,
                b = 1,
                a = 0.1,
            },
            bg = {
                r = 0,
                g = 0,
                b = 0,
                a = 0.1,
            }
        }
    }, M)

	return self
end

function M:draw()
    lg.push()
    lg.translate(0, lg.getHeight() - 48)
    
    local dt = game.time

    self:drawHoursMinutesBackground(dt)

    self:drawSecondsCircle(dt)
    self:drawTimeOfDayCircle(dt)
    self:drawHoursMinutesForeground(dt)
    
    lg.pop()
end

function M:drawHoursMinutesForeground(dt)
    game.graphics:drawTextInBox(dt:timeShort(), 0, -8, self.timeWidth, 64, game.images.ui.dialog_font, nil, true)
    game.graphics:drawTextInBox(dt:dateShort(), lg.getWidth() - self.dateWidth, -8, self.dateWidth, 64, game.images.ui.dialog_font, nil, true)
end

function M:drawHoursMinutesBackground(dt)
	game.graphics:drawObject(game.images.ui.clock_bg, 0, 0, self.timeWidth, 64)
	game.graphics:drawObject(game.images.ui.clock_bg, lg.getWidth() - self.dateWidth, 0, self.dateWidth, 64)
end

function M:drawSecondsCircle(dt)
    self:drawClock(self.timeWidth - self.radius - 4 - 10, self.radius + 4 + 10, dt.second / 60, self.secondsColor.fg, self.secondsColor.bg)
end

function M:drawTimeOfDayCircle(dt)
    self:drawClock(self.radius + 4 + 10, self.radius + 4 + 10, dt:normalizedTimeOfDay12(), self.secondsColor.fg, self.secondsColor.bg)
end

function M:drawClock(x, y, amount, color_fg, color_bg)
    lg.push()
    lg.translate(x, y)
    
    lg.setColor(color_bg.r, color_bg.g, color_bg.b, color_bg.a or 1)
    lg.arc('fill', 0, 0, self.radius + self.borderWidth, 0, 2 * math.pi, 24)
    lg.setColor(color_fg.r, color_fg.g, color_fg.b, color_fg.a or 1)
    lg.arc('fill', 0, 0, self.radius, self.startAngle, amount * 2 * math.pi + self.startAngle, 24)
    lg.setColor(1, 1, 1)

    lg.pop()
end

return M