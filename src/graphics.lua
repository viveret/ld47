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
    	TextArrow = lg.newImage("/assets/images/screen/text-arrow.png"),
    	PlayerProfile = lg.newImage("assets/images/people/protag-profile.png"),
    	UnknownProfile = lg.newImage("assets/images/people/unknown-profile.png"),
        AntiquesDoor = lg.newImage("assets/images/world/Antiques/Door.png"),
        BarDoor = lg.newImage("assets/images/world/Bar/Door.png"),
        CoffeeShopDoor = lg.newImage("assets/images/world/Coffee/Door.png"),
        DoctorDoor = lg.newImage("assets/images/world/Doctor/Door.png"),
        LibraryDoor = lg.newImage("assets/images/world/Library/Door.png"),
        MotelDoor = lg.newImage("assets/images/world/Motel/Door.png"),
        PostOfficeDoor = lg.newImage("assets/images/world/PostOffice/Door.png"),
        SchoolDoor = lg.newImage("assets/images/world/School/Door.png"),
        StoreDoor = lg.newImage("assets/images/world/Shop/Door.png")

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

	-- calculate dialog placement
	local dialogBox = self.Dialog
	local width, height = dialogBox:getDimensions()
	
	local maximumTextHeight = height - (innerYGutter * 2)

	local y = outerYGutter
	local x = outerXGutter + _renderWidth / 2 - width / 2

	-- render the profile picture
	local profile = nil

	if profileName == 'Player' then
		profile = self.PlayerProfile
	elseif profileName == '???' then
		profile = self.UnknownProfile
	end

	if profile ~= nil then 
		local profileX = x + 28
		local profielY = y + 12

		M.drawObject(profile, profileX, profileY, 152, 152)
	end

	-- render the dialog box
	
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