local M = {}
M.__index = M

function M.new(images)
	local getActorAnimations = function(img)
		return {
			still = animation.new(img, 64, 64, 0, 3, 0, 1),
			down = animation.new(img, 64, 64, 3, 6, 0, 1),
			up = animation.new(img, 64, 64, 9, 6, 0, 1),
			right = animation.new(img, 64, 64, 15, 6, 0, 1),
			left = animation.new(img, 64, 64, 15, 6, 0, 1, true),
		}
	end
	return setmetatable({
		actors = {
			mary = {
				still = animation.new(images.actors.mary, 64, 64, 0, 3, 0, 1),
			},
			player =  getActorAnimations(images.actors.player),
			cultist =  getActorAnimations(images.actors.cultist),
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
			motel_guy = animation.new(images.actors.motel_guy, 64, 64, 0, 6, 0, 1),
		},
		doors = {
			antiques = animation.new(images.doors.antiques, 80, 72, 0, 6, 0, 1, false),
			bar = animation.new(images.doors.bar, 80, 72, 0, 6, 0, 1, false),
			coffee_shop = animation.new(images.doors.coffee_shop, 80, 72, 0, 6, 0, 1, false),
			doctor = animation.new(images.doors.doctor, 80, 72, 0, 6, 0, 1, false),
			library = animation.new(images.doors.library, 80, 72, 0, 6, 0, 1, false),
			motel = animation.new(images.doors.motel, 80, 72, 0, 6, 0, 1, false),
			post_office = animation.new(images.doors.post_office, 80, 72, 0, 6, 0, 1, false),
			school = animation.new(images.doors.school, 80, 72, 0, 6, 0, 1, false),
			store = animation.new(images.doors.store, 80, 72, 0, 6, 0, 1, false),
		},
		ui = {
			text_arrow = animation.new(images.ui.text_arrow, 32, 32, 0, 2, 0, 1, false)
		}
    }, M)
end

return M