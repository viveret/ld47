local M = {}
M.__index = M

local cache = {}

function M.new()
    lg.setDefaultFilter('linear', 'linear')

    return setmetatable({
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
				dugUp = lg.newImage("assets/images/world/cemetery/dugupgrave.png"),
				fresh = lg.newImage("assets/images/world/cemetery/freshgrave.png"),
				bones = lg.newImage("assets/images/world/cemetery/bonepile.png"),
				grave1 = lg.newImage("assets/images/world/cemetery/grave1.png"),
				grave2 = lg.newImage("assets/images/world/cemetery/grave2.png"),
				grave3 = lg.newImage("assets/images/world/cemetery/grave3.png"),
				grave4 = lg.newImage("assets/images/world/cemetery/grave4.png"),
				grave5 = lg.newImage("assets/images/world/cemetery/grave5.png"),
				grave6 = lg.newImage("assets/images/world/cemetery/grave6.png"),
				grave7 = lg.newImage("assets/images/world/cemetery/grave7.png"),
				grave8 = lg.newImage("assets/images/world/cemetery/grave8.png"),
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
			title = lg.newImage("assets/images/ui/title.png"),
			start_btn = lg.newImage("assets/images/ui/start-button.png"),
			quit_btn = lg.newImage("assets/images/ui/quit.png"),
			continue_btn = lg.newImage("assets/images/ui/start-button.png"),
			end_bg = lg.newImage("assets/images/ui/end.png"),
			notes = lg.newImage("assets/images/ui/notes.png"),

			clock_bg = lg.newImage("assets/images/ui/clock.png"),

			success = lg.newImage("assets/images/ui/success.png"),
			failure = lg.newImage("assets/images/ui/failure.png"),

			icons = {
				saving = lg.newImage("assets/images/ui/saving.png"),
			},

			portraits = {
				player = lg.newImage("assets/images/people/protag-profile.png"),
				unkown = lg.newImage("assets/images/people/unknown-profile.png"),
				person1 = lg.newImage("assets/images/people/person1-profile.png"),
				person2 = lg.newImage("assets/images/people/person2-profile.png"),
				person3 = lg.newImage("assets/images/people/person3-profile.png"),
				person4 = lg.newImage("assets/images/people/person4-profile.png"),
				person5 = lg.newImage("assets/images/people/person5-profile.png"),
				person6 = lg.newImage("assets/images/people/person6-profile.png"),
				person7 = lg.newImage("assets/images/people/person7-profile.png"),
				person8 = lg.newImage("assets/images/people/person8-profile.png"),
				person9 = lg.newImage("assets/images/people/person9-profile.png"),
				person10 = lg.newImage("assets/images/people/person10-profile.png"),
				cultist = lg.newImage("assets/images/people/cultist-profile.png"),
				cultist1 = lg.newImage("assets/images/people/cultist-profile.png"),
				cultist2 = lg.newImage("assets/images/people/cultist-profile.png"),
				cultist3 = lg.newImage("assets/images/people/cultist-profile.png"),
				cultist4 = lg.newImage("assets/images/people/cultist-profile.png"),
				cultist5 = lg.newImage("assets/images/people/cultist-profile.png"),
				cultist6 = lg.newImage("assets/images/people/cultist-profile.png"),
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
			radio = lg.newImage("assets/images/world/home/radio.png"),
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
		},

		inventories = {

		},
    }, M)
end

return M