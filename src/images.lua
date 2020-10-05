local M = {}
M.__index = M

function M.new(graphics)
    lg.setDefaultFilter('linear', 'linear')

    return setmetatable({
		graphics = graphics,
		places = {
			overworld = {
				bg = lg.newImage("assets/images/world/overworld.png"),
			},
			antiques = {
				bg = lg.newImage("assets/images/world/antiques/interior.png"),
			},
			bar = {
				bg = lg.newImage("assets/images/world/bar/interior.png"),
			},
			cemetery = {
				bg = lg.newImage("assets/images/world/cemetery/cemetery.png"),
			},
			coffee = {
				bg = lg.newImage("assets/images/world/coffee/interior.png"),
				table = lg.newImage("assets/images/world/coffee/table.png"),
			},
			doctor = {
				bg = lg.newImage("assets/images/world/doctor/interior.png"),
			},
			home = {
				bg = lg.newImage("assets/images/world/home/interior.png"),
			},
			library = {
				bg = lg.newImage("assets/images/world/library/interior.png"),
			},
			motel = {
				bg = lg.newImage("assets/images/world/motel/interior.png"),
			},
			motel_lobby = {
				bg = lg.newImage("assets/images/world/motel/interior-lobby.png"),
			},
			post_office = {
				bg = lg.newImage("assets/images/world/post-office/interior.png"),
			},
			school = {
				bg = lg.newImage("assets/images/world/school/interior.png"),
			},
			shop = {
				bg = lg.newImage("assets/images/world/shop/interior.png"),
			},
			swamp = {
				bg = lg.newImage("assets/images/world/swamp/swamp.png"),
			},
		},
		
		-- UI
		ui = {
			dialog = lg.newImage("/assets/images/screen/dialog-box.png"),
			dialog_font = love.graphics.newImageFont(
				"/assets/images/screen/dialog-font.png",
				" abcdefghijklmnopqrstuvwxyz"..
				"ABCDEFGHIJKLMNOPQRSTUVWXYZ0"..
				"123456789.,!?-+/():;%&`'*#=[]\""
			),
			text_arrow = lg.newImage("/assets/images/screen/text-arrow.png"),

			button_bg = lg.newImage("assets/images/ui/button_bg.png"),
			menu_bg = lg.newImage("assets/images/ui/menu_bg.png"),
			title_fg = lg.newImage("assets/images/ui/title_fg.png"),
			title = lg.newImage("assets/images/ui/title.png"),
			start_btn = lg.newImage("assets/images/ui/start-button.png"),

			profiles = {
				player = lg.newImage("assets/images/people/protag-profile.png"),
				unkown = lg.newImage("assets/images/people/unknown-profile.png"),
				cultist = lg.newImage("assets/images/people/cultist-profile.png"),
				mary = lg.newImage("assets/images/people/mary-profile.png"),
				motel_guy = lg.newImage("assets/images/people/motelguy-profile.png"),
			},
		},
		
		doors = {
			antiques = lg.newImage("assets/images/world/antiques/door.png"),
			bar = lg.newImage("assets/images/world/bar/door.png"),
			coffee_shop = lg.newImage("assets/images/world/coffee/door.png"),
			doctor = lg.newImage("assets/images/world/doctor/door.png"),
			library = lg.newImage("assets/images/world/library/door.png"),
			motel = lg.newImage("assets/images/world/motel/door.png"),
			post_office = lg.newImage("assets/images/world/post-office/door.png"),
			school = lg.newImage("assets/images/world/school/door.png"),
			store = lg.newImage("assets/images/world/shop/door.png"),
		},

		decor = {
			school_flag = lg.newImage("assets/images/world/street/school-flag.png"),
			beer_sign = lg.newImage("assets/images/world/street/beer-sign.png"),

			-- coffee shop assets
			freezer = lg.newImage("assets/images/world/coffee/freezer.png"),
			back_counter = lg.newImage("assets/images/world/coffee/back-counter.png"),
			counter = lg.newImage("assets/images/world/coffee/counter.png"),
			table = lg.newImage("assets/images/world/coffee/table.png"),
			ropes = lg.newImage("assets/images/world/library/ropes.png"),
			tome = lg.newImage("assets/images/world/library/tome.png"),
			construction = lg.newImage("assets/images/world/construction.png")
		},

		actors = {
			player = lg.newImage("assets/images/people/protag.png"),
			mary = lg.newImage("assets/images/world/antiques/mary.png"),
			cultist = lg.newImage("assets/images/people/cultist.png"),
			cultist1 = lg.newImage("assets/images/people/cultist2.png"),
			cultist2 = lg.newImage("assets/images/people/cultist3.png"),
			cultist3 = lg.newImage("assets/images/people/cultist4.png"),
			cultist4 = lg.newImage("assets/images/people/cultist5.png"),
			cultist5 = lg.newImage("assets/images/people/cultist3.png"),
			cultist6 = lg.newImage("assets/images/people/cultist4.png"),
			person1 = lg.newImage("assets/images/people/person1.png"),
			person2 = lg.newImage("assets/images/people/person2.png"),
			person3 = lg.newImage("assets/images/people/person3.png"),
			person4 = lg.newImage("assets/images/people/person4.png"),
			person5 = lg.newImage("assets/images/people/person5.png"),
			person6 = lg.newImage("assets/images/people/person6.png"),
			person7 = lg.newImage("assets/images/people/person7.png"),
			person8 = lg.newImage("assets/images/people/person8.png"),
			person9 = lg.newImage("assets/images/people/person9.png"),
			person10 = lg.newImage("assets/images/people/person10.png"),
			motel_guy = lg.newImage("assets/images/world/motel/motelguy.png"),
			librarian = lg.newImage("assets/images/people/bartender.png")
		},

		timelineObjs = {
			book = lg.newImage("assets/images/world/library/tome.png"),
			package = lg.newImage("assets/images/world/home/package.png"),
		}
    }, M)
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
	local width, height = self.ui.dialog:getDimensions()
	
	local maximumTextHeight = height - (innerYGutter * 2)

	local y = outerYGutter
	local x = outerXGutter + _renderWidth / 2 - width / 2

	-- render the profile picture
	local profile = nil

	if profileName == '???' then
		profile = self.ui.profiles.unknown
	else
		profile = self.ui.profiles[profileName]
	end

	if profile ~= nil then 
		local profileX = x + 28
		local profileY = y + 16

		self:drawObject(profile, profileX, profileY, 152, 152)
	end

	-- render the dialog box
	
	self.graphics:drawObject(self.ui.dialog, x, y, width, height)
	
	-- render the text
	self.graphics:renderTextInBox(text, x + 180 + innerXGutter, y, maximumTextWidth, maximumTextHeight, self.ui.dialog_font)

	-- render the name
	self.graphics:renderTextInBox(profileName, x + 40, y + 175, maximumNameWidth, maximumNameHeight, self.ui.dialog_font)

	if animation ~= nil then
		local animSize = animation:getFrameSize()

		local animX = x + width - innerXGutter - animSize.width
		local animY = y + height - innerYGutter - animSize.height

		animation:draw(animX, animY, true)
	end
end

return M