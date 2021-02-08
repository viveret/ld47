local M = {}
M.__index = M

function M.new()
    return setmetatable({
    }, M)
end

function M:drawObject(img, x, y, w, h)
    local iw, ih = img:getDimensions()
    lg.draw(img, x, y, 0, w / iw, h / ih)
end

function M:drawTextInBox(text, x, y, width, height, font, color, centerIt)
	local lineHeight = font:getHeight()

	local trueWidth, lines = font:getWrap(text, width - 16)

	local trueHeight = #lines * lineHeight

	local textY = y + height / 2 - (trueHeight / 2)
	local textX = x + 16
	if #lines > 1 or centerIt then
		textX = textX - 16 + width / 2 - trueWidth / 2
	end

	local oldFont = lg.getFont()
	lg.setFont(font)
	if color ~= nil then
		lg.setColor(color.r, color.g, color.b, color.a)
	end

	for ix, line in pairs(lines) do
		lg.print(line, textX, textY)
		textY = textY + lineHeight
	end

	if color ~= nil then
		lg.setColor(1, 1, 1, 1)
	end
	lg.setFont(oldFont)
end

return M