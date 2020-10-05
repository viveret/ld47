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

function M:renderTextInBox(text, x, y, width, height, font)
	local lineHeight = font:getHeight()

	local trueWidth, lines = font:getWrap(text, width)

	local trueHeight = #lines * lineHeight

	local textY = y + height / 2 - (trueHeight / 2)
	local textX = x + (width / 2 - (trueWidth / 2))

	local oldFont = lg.getFont()
	lg.setFont(font)

	for ix, line in pairs(lines) do
		lg.print(line, textX, textY)
		textY = textY + lineHeight
	end

	lg.setFont(oldFont)
end

return M