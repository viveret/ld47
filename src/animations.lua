local M = {}
M.__index = M

function M.new(images)
	local getActorAnimations = function(img)
		return {
			still = animation.new(img, 64, 64, 0, 3, 0, 8),
			down = animation.new(img, 64, 64, 3, 6, 0, 8),
			up = animation.new(img, 64, 64, 9, 6, 0, 8),
			right = animation.new(img, 64, 64, 15, 6, 0, 8),
			left = animation.new(img, 64, 64, 15, 6, 0, 8, true),
		}
	end
	return setmetatable({
		actors = {
			mary = {
				still = animation.new(images.actors.mary, 64, 64, 0, 3, 0, 1),
			},
			player =  getActorAnimations(images.actors.player),
			cultist =  getActorAnimations(images.actors.cultist),
			cultist1 =  getActorAnimations(images.actors.cultist1),
			cultist2 =  getActorAnimations(images.actors.cultist2),
			cultist3 =  getActorAnimations(images.actors.cultist3),
			cultist4 =  getActorAnimations(images.actors.cultist4),
			cultist5 =  getActorAnimations(images.actors.cultist5),
			cultist6 =  getActorAnimations(images.actors.cultist6),
			person1 =  getActorAnimations(images.actors.person1),
			person2 =  getActorAnimations(images.actors.person2),
			person3 =  getActorAnimations(images.actors.person3),
			person4 =  getActorAnimations(images.actors.person4),
			person5 =  getActorAnimations(images.actors.person5),
			person6 =  getActorAnimations(images.actors.person6),
			person7 =  getActorAnimations(images.actors.person7),
			person8 =  getActorAnimations(images.actors.person8),
			person9 =  getActorAnimations(images.actors.person9),
			person10 = getActorAnimations(images.actors.person10),
			motel_guy = getActorAnimations(images.actors.motel_guy),
			librarian = {
				still = animation.new(images.actors.librarian, 64, 64, 0, 2, 0, 1),
			},
		},
		doors = {
			antiques = animation.new(images.doors.antiques, 80, 72, 0, 6, 0, 1, false),
			bar = animation.new(images.doors.bar, 80, 72, 0, 6, 0, 1, false),
			coffee_shop = animation.new(images.doors.coffee_shop, 80, 72, 0, 6, 0, 1, false),
			doctor = animation.new(images.doors.doctor, 80, 72, 0, 6, 0, 1, false),
			library = animation.new(images.doors.library, 80, 72, 0, 6, 0, 1, false),
			motelLeft = animation.new(images.doors.motel, 80, 72, 0, 6, 0, 1, false),
			motelMiddle = animation.new(images.doors.motel, 80, 72, 0, 6, 0, 1, false),
			motelRight = animation.new(images.doors.motel, 80, 72, 0, 6, 0, 1, false),
			post_office = animation.new(images.doors.post_office, 80, 72, 0, 6, 0, 1, false),
			school = animation.new(images.doors.school, 80, 72, 0, 6, 0, 1, false),
			store = animation.new(images.doors.store, 80, 72, 0, 6, 0, 1, false),
		},
		ui = {
			text_arrow = animation.new(images.ui.text_arrow, 32, 32, 0, 2, 0, 1, false)
		},
		decor = {
			school_flag = animation.new(images.decor.school_flag, 88, 160, 0, 3, 0, 3, false),
			beer_sign = animation.new(images.decor.beer_sign, 56, 80, 0, 14, 0, 12, false),
			freezer = animation.new(images.decor.freezer, 96, 96, 0, 3, 0, 10000),
		}
    }, M)
end

return M