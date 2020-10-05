local M = {}
M.__index = M

function M.new()
    lg.setDefaultFilter('linear', 'linear')

    local cultist = lg.newImage("assets/images/people/cultist.png")
    
    local person1 = lg.newImage("assets/images/people/person1.png")
    local person2 = lg.newImage("assets/images/people/person2.png")
    local person3 = lg.newImage("assets/images/people/person3.png")
    local person4 = lg.newImage("assets/images/people/person4.png")
    local person5 = lg.newImage("assets/images/people/person5.png")
    local person6 = lg.newImage("assets/images/people/person6.png")
    local person7 = lg.newImage("assets/images/people/person7.png")
    local person8 = lg.newImage("assets/images/people/person8.png")
    local person9 = lg.newImage("assets/images/people/person9.png")
    local person10 = lg.newImage("assets/images/people/person10.png")

    return setmetatable({
        Overworld = {
			Bg = lg.newImage("assets/images/world/Overworld.png"),
		},
        Antiques = {
			Bg = lg.newImage("assets/images/world/Antiques/Interior.png"),
		},
        Bar = {
			Bg = lg.newImage("assets/images/world/Bar/Interior.png"),
		},
        Cemetery = {
			Bg = lg.newImage("assets/images/world/Cemetery/Cemetery.png"),
		},
        Coffee = {
			Bg = lg.newImage("assets/images/world/Coffee/Interior.png"),
			Table = lg.newImage("assets/images/world/Coffee/table.png"),
		},
        Doctor = {
			Bg = lg.newImage("assets/images/world/Doctor/Interior.png"),
		},
        Home = {
			Bg = lg.newImage("assets/images/world/Home/Interior.png"),
		},
        Library = {
			Bg = lg.newImage("assets/images/world/Library/Interior.png"),
		},
        Motel = {
			Bg = lg.newImage("assets/images/world/Motel/Interior.png"),
		},
        PostOffice = {
			Bg = lg.newImage("assets/images/world/PostOffice/Interior.png"),
		},
        School = {
			Bg = lg.newImage("assets/images/world/School/Interior.png"),
		},
        Shop = {
			Bg = lg.newImage("assets/images/world/Shop/Interior.png"),
		},
        Swamp = {
			Bg = lg.newImage("assets/images/world/Swamp/Swamp.png"),
		},
		
		Player = lg.newImage("assets/images/people/protag.png"),
		
		-- UI
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
		CultistProfile = lg.newImage("assets/images/people/cultist-profile.png"),
		MaryProfile = lg.newImage("assets/images/people/mary-profile.png"),
        
		ui = {
			button_bg = lg.newImage("assets/images/ui/button_bg.png"),
			menu_bg = lg.newImage("assets/images/ui/menu_bg.png"),
			title_fg = lg.newImage("assets/images/ui/title_fg.png"),
			title = lg.newImage("assets/images/ui/title.png"),
			start_btn = lg.newImage("assets/images/ui/start-button.png"),
		},
		


		-- Doors
        AntiquesDoor = lg.newImage("assets/images/world/Antiques/Door.png"),
        BarDoor = lg.newImage("assets/images/world/Bar/Door.png"),
        CoffeeShopDoor = lg.newImage("assets/images/world/Coffee/Door.png"),
        DoctorDoor = lg.newImage("assets/images/world/Doctor/Door.png"),
        LibraryDoor = lg.newImage("assets/images/world/Library/Door.png"),
        MotelDoor = lg.newImage("assets/images/world/Motel/Door.png"),
        PostOfficeDoor = lg.newImage("assets/images/world/PostOffice/Door.png"),
        SchoolDoor = lg.newImage("assets/images/world/School/Door.png"),
        StoreDoor = lg.newImage("assets/images/world/Shop/Door.png"),

    	CultistIdle = animation.new(cultist, 64, 64, 0, 3, 0, 1),
        CultistDown = animation.new(cultist, 64, 64, 3, 6, 0, 1),
        CultistUp = animation.new(cultist, 64, 64, 9, 6, 0, 1),
        CultistRight = animation.new(cultist, 64, 64, 15, 6, 0, 1),
		CultistLeft = animation.new(cultist, 64, 64, 15, 6, 0, 1, true),
		
		SchoolFlag = lg.newImage("assets/images/world/Street/school-flag.png"),
		BeerSign = lg.newImage("assets/images/world/Street/beer-sign.png"),

		MaryIdle = animation.new(lg.newImage("assets/images/world/Antiques/Mary.png"), 64, 64, 0, 3, 0, 1),

		-- People
		Person1Idle = animation.new(person1, 64, 64, 0, 3, 0, 1),
		Person1Down = animation.new(person1, 64, 64, 3, 6, 0, 1),
		Person1Up = animation.new(person1, 64, 64, 9, 6, 0, 1),
		Person1Right = animation.new(person1, 64, 64, 15, 6, 0, 1),
		Person1Left = animation.new(person1, 64, 64, 15, 6, 0, 1, true),

		Person2Idle = animation.new(person2, 64, 64, 0, 3, 0, 1),
		Person2Down = animation.new(person2, 64, 64, 3, 6, 0, 1),
		Person2Up = animation.new(person2, 64, 64, 9, 6, 0, 1),
		Person2Right = animation.new(person2, 64, 64, 15, 6, 0, 1),
		Person2Left = animation.new(person2, 64, 64, 15, 6, 0, 1, true),

		Person3Idle = animation.new(person3, 64, 64, 0, 3, 0, 1),
		Person3Down = animation.new(person3, 64, 64, 3, 6, 0, 1),
		Person3Up = animation.new(person3, 64, 64, 9, 6, 0, 1),
		Person3Right = animation.new(person3, 64, 64, 15, 6, 0, 1),
		Person3Left = animation.new(person3, 64, 64, 15, 6, 0, 1, true),

		Person4Idle = animation.new(person4, 64, 64, 0, 3, 0, 1),
		Person4Down = animation.new(person4, 64, 64, 3, 6, 0, 1),
		Person4Up = animation.new(person4, 64, 64, 9, 6, 0, 1),
		Person4Right = animation.new(person4, 64, 64, 15, 6, 0, 1),
		Person4Left = animation.new(person4, 64, 64, 15, 6, 0, 1, true)
		
    }, M)
end

function M:drawObject(img, x, y, w, h)
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

	if profileName == '???' then
		profile = self.UnknownProfile
	else
		profile = self[profileName.."Profile"]
	end

	if profile ~= nil then 
		local profileX = x + 28
		local profileY = y + 16

		self:drawObject(profile, profileX, profileY, 152, 152)
	end

	-- render the dialog box
	
	self:drawObject(dialogBox, x, y, width, height)
	
	-- render the text
	self:renderTextInBox(text, x + 180 + innerXGutter, y, maximumTextWidth, maximumTextHeight)

	-- render the name
	self:renderTextInBox(profileName, x + 40, y + 175, maximumNameWidth, maximumNameHeight)

	if animation ~= nil then
		local animSize = animation:getFrameSize()

		local animX = x + width - innerXGutter - animSize.width
		local animY = y + height - innerYGutter - animSize.height

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