PhysicalGameState = require "src.gamestates.PhysicalGameState"
AnimatedObject = require "src.world.AnimatedObject"
local M = setmetatable({}, { __index = PhysicalGameState })
M.__index = M

function M.new(gamestate)
    local self = setmetatable(PhysicalGameState.new(gamestate, 'Overworld', gamestate.images.places.overworld), M)
    self.bgMusicName = "chill"
    self:addExteriorWorldBounds()
    self:addWorldBounds({
        { -- Building 1a
            x = 2, y = 2,
            w = 43, h = 24
        },
        { -- Building 1b
            x = 36, y = 16,
            w = 26, h = 14
        },
        { -- Cemetary left
            x = 56, y = 2,
            w = 39, h = 8
        },
        { -- Cemetary right
            x = 110, y = 2,
            w = 42, h = 8
        },
        { -- Doctor
            x = 160, y = 2,
            w = 40, h = 27
        },
        { -- School
            x = 155, y = 47,
            w = 45, h = 33
        },
        { -- Bar
            x = 10, y = 67,
            w = 33, h = 20
        },
        { -- Coffee, Library
            x = 57, y = 45,
            w = 85, h = 42
        },
        { -- Post Office
            x = 109, y = 104,
            w = 43, h = 33
        },
        { -- General Store
            x = 33, y = 105,
            w = 70, h = 24
        }
    })
    
    self.doors = {
        antiques = door.new(self.gamestate.animations.doors.antiques, 65, 82.5),
        bar = door.new(self.gamestate.animations.doors.bar, 30, 82.5),
        coffee = door.new(self.gamestate.animations.doors.coffee_shop, 95, 82.5),
        doctor = door.new(self.gamestate.animations.doors.doctor, 174.5, 25.5),
        library = door.new(self.gamestate.animations.doors.library, 124.5, 82.5),
        motelLeft = door.new(self.gamestate.animations.doors.motelLeft, 10.5, 21.5),
        motelMiddle = door.new(self.gamestate.animations.doors.motelMiddle, 25, 21.5),
        motelRight = door.new(self.gamestate.animations.doors.motelRight, 49.5, 26),
        postoffice = door.new(self.gamestate.animations.doors.post_office, 125.5, 127.5),
        school = door.new(self.gamestate.animations.doors.school, 172, 77),
        store = door.new(self.gamestate.animations.doors.store, 43.5, 121),
    }

    self.warps = {
        { -- Home
            x = 180, y = 140,
            w = 20, h = 10,
            path = 'Home,50,50,x',
            door = self.doors.home,
        },
        { -- Galaxy Motel Left
            x = 11, y = 20,
            w = 9, h = 8,
            path = 'Motel,62,52,x',
            door = self.doors.motelLeft
        },
        { -- Galaxy Motel Center
            x = 25, y = 20,
            w = 9, h = 8,
            path = 'Motel,62,52,x',
            door = self.doors.motelMiddle
        },
        { -- Galaxy Motel Right
            x = 50, y = 26,
            w = 9, h = 8,
            path = 'MotelLobby,50,63,x',
            door = self.doors.motelRight
        },
        { -- Swamp
            x = 0, y = 122,
            w = 8, h = 10,
            path = 'Swamp,176,114,x'
        },
        { -- Bar
            x = 30, y = 80,
            w = 9, h = 8,
            path = 'Bar,50,52,x',
            door = self.doors.bar
        },
        { -- Antiques
            x = 65, y = 80,
            w = 9, h = 8,
            path = 'Antiques,48,60,x',
            door = self.doors.antiques,
        },
        { -- Coffee
            x = 95, y = 80,
            w = 9, h = 8,
            path = 'Coffee,48,64,x',
            door = self.doors.coffee,
        },
        { -- School
            x = 173, y = 75,
            w = 9, h = 8,
            path = 'School,50,55,x',
            door = self.doors.school,
        },
        { -- Doctor
            x = 176, y = 25,
            w = 9, h = 8,
            path = 'Doctor,20,15,x',
            door = self.doors.doctor,
        },
        { -- Cemetery
            x = 95, y = 0,
            w = 15, h = 5,
            path = 'Cemetery,100,115,x'
        },
        { -- Library
            x = 125, y = 80,
            w = 9, h = 8,
            path = 'Library,50,50,x',
            door = self.doors.library,
        },
        { -- Post Office
            x = 126, y = 129,
            w = 9, h = 8,
            path = 'PostOffice,50,50,x',
            door = self.doors.postoffice
        },
        { -- General Store
            x = 44, y = 122,
            w = 9, h = 8,
            path = 'Shop,10,10,x',
            door = self.doors.store
        }
    }

    self.animatedObjects = {
        schoolFlag = AnimatedObject.new(self.world, 184, 70, self.gamestate.animations.decor.school_flag),
        beerSign = AnimatedObject.new(self.world, 20, 80, self.gamestate.animations.decor.beer_sign, awdawdawd)
    }

    self.animatedObjects.beerSign.type = 'sign'
    self.animatedObjects.beerSign.isInteractable = true
    table.insert(self.proximityObjects, self.animatedObjects.beerSign)

    self.animatedObjects.schoolFlag.type = 'sign'
    self.animatedObjects.schoolFlag.isInteractable = true
    table.insert(self.proximityObjects, self.animatedObjects.schoolFlag)

	return self
end

function awdawdawd(b, player)
    print('Turned off / on beer sign')
    b.hasInteractedWith = true
    b.animation.pause = not b.animation.pause
    b.animation.currentTime = 0
end

function M:draw()
    PhysicalGameState.draw(self)
end

function M:drawInWorldView()
    PhysicalGameState.drawInWorldView(self)
end

function M:update(dt)
    PhysicalGameState.update(self, dt)
end

function M:load()
    PhysicalGameState.load(self)
end

function M:switchTo(x, y)
    PhysicalGameState.switchTo(self, x, y)
end

function M:save()
end


return M