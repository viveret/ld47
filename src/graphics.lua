local M = {}

function M.load()
    lg.setDefaultFilter('linear', 'linear')

    return lume.extend({
        Overworld = lg.newImage("assets/images/world/Overworld.png"),
        Player = lg.newImage("assets/images/people/protag.png"),
        Dialog = lg.newImage("/assets/images/screen/dialog-box.png"),
        DialogFont = love.graphics.newImageFont(
        	"/assets/images/screen/dialog-font.png",
        	" abcdefghijklmnopqrstuvwxyz"..
        	"ABCDEFGHIJKLMNOPQRSTUVWXYZ0"..
    		"123456789.,!?-+/():;%&`'*#=[]\""
    	),
    	TextArrow = lg.newImage("/assets/images/screen/text-arrow.png")
    }, M)
end

function M.drawObject(img, x, y, w, h)
    local iw, ih = img:getDimensions()
    lg.draw(img, x, y, 0, w / iw, h / ih)
end

function M:drawDialogBox(profileName, text, animation)
	local outerXGutter = 5
	local innerXGutter = 18
	local outerYGutter = 5
	local innerYGutter = 14
	local maximumTextWidth = (572 - (innerXGutter * 2))
	local maximumTextHeight = 200
	local maximumNameWidth = 125
	local maximumNameHeight = 30

	local dialogBox = self.Dialog
	
	-- render the dialog box
	local width, height = dialogBox:getDimensions()

	local maximumTextHeight = height - (innerYGutter * 2)

	local y = outerYGutter
	local x = outerXGutter + _renderWidth / 2 - width / 2

	M.drawObject(dialogBox, x, y, width, height)
	
	-- render the text
	self:renderTextInBox(text, x + 180 + innerXGutter, y, maximumTextWidth, maximumTextHeight)

	-- render the name
	self:renderTextInBox(profileName, x + 40, y + 175, maximumNameWidth, maximumNameHeight)

	if animation ~= nil then
		local animSize = animation:getFrameSize()

		local animX = x + width - innerXGutter - animSize
		local animY = y + height - innerYGutter - animSize

		animation:draw(animX, animY, true)
	end
end

function M:renderTextInBox(text, x, y, width, height)
	local font = self.DialogFont

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