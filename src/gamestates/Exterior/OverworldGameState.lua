PhysicalGameState = require "src.gamestates.PhysicalGameState"
AnimatedObject = require "src.world.AnimatedObject"
local M = setmetatable({}, { __index = PhysicalGameState })
M.__index = M

function M.new(gamestate)
    local self = setmetatable(PhysicalGameState.new(gamestate, 'Overworld', gamestate.graphics.Overworld), M)
    self:addExteriorWorldBounds()
    self:addWorldBounds({
        { -- Building 1a
            x = 0, y = 2,
            w = 32, h = 15
        },
        { -- Building 1b
            x = 30, y = 15,
            w = 18, h = 6
        },
        { -- Cemetary left
            x = 45, y = 2,
            w = 30, h = 4
        },
        { -- Cemetary right
            x = 45 + 35 + 30, y = 2,
            w = 30, h = 4
        },
        { -- Doctor
            x = 160, y = 2,
            w = 40, h = 27
        },
        { -- School
            x = 155, y = 47,
            w = 45, h = 33
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
    self.renderBounds = true
    
    self.doors = {
        antiques = door.new(self.world, self.gamestate.graphics.AntiquesDoor, 65, 82.5),
        bar = door.new(self.world, self.gamestate.graphics.BarDoor, 30, 82.5),
        coffee = door.new(self.world, self.gamestate.graphics.CoffeeShopDoor, 95, 82.5),
        doctor = door.new(self.world, self.gamestate.graphics.DoctorDoor, 174.5, 25.5),
        library = door.new(self.world, self.gamestate.graphics.LibraryDoor, 124.5, 82.5),
        motelLeft = door.new(self.world, self.gamestate.graphics.MotelDoor, 10.5, 21.5),
        motelMiddle = door.new(self.world, self.gamestate.graphics.MotelDoor, 25, 21.5),
        motelRight = door.new(self.world, self.gamestate.graphics.MotelDoor, 49.5, 26),
        postoffice = door.new(self.world, self.gamestate.graphics.PostOfficeDoor, 125.5, 127.5),
        school = door.new(self.world, self.gamestate.graphics.SchoolDoor, 172, 77),
        store = door.new(self.world, self.gamestate.graphics.StoreDoor, 43.5, 121),
    }

    self.warps = {
        { -- Home
            x = 180, y = 140,
            w = 20, h = 10,
            path = 'Home,50,120,x',
            door = self.doors.home,
        },
        { -- Galaxy Motel Left
            x = 11, y = 20,
            w = 9, h = 8,
            path = 'Motel,20,15,x',
            door = self.doors.motelLeft
        },
        { -- Galaxy Motel Center
            x = 25, y = 20,
            w = 9, h = 8,
            path = 'Motel,20,15,x',
            door = self.doors.motelCenter
        },
        { -- Galaxy Motel Right
            x = 50, y = 26,
            w = 9, h = 8,
            path = 'Motel,20,15,x',
            door = self.doors.motelRight
        },
        { -- Swamp
            x = 0, y = 122,
            w = 8, h = 10,
            path = 'Swamp,-30,-35,x'
        },
        { -- Bar
            x = 30, y = 80,
            w = 9, h = 8,
            path = 'Bar,20,15,x',
            door = self.doors.bar
        },
        { -- Antiques
            x = 65, y = 80,
            w = 9, h = 8,
            path = 'Antiques,20,15,x',
            door = self.doors.antiques,
        },
        { -- Coffee
            x = 95, y = 80,
            w = 9, h = 8,
            path = 'Coffee,20,15,x',
            door = self.doors.coffee,
        },
        { -- School
            x = 173, y = 75,
            w = 9, h = 8,
            path = 'School,20,15,x',
            door = self.doors.school,
        },
        { -- Doctor
            x = 176, y = 25,
            w = 9, h = 8,
            path = 'Doctor,20,15,x',
            door = self.doors.doctor,
        },
        { -- Cemetery
            x = 100, y = 0,
            w = 5, h = 5,
            path = 'Cemetery,100,115,x'
        },
        { -- Library
            x = 125, y = 80,
            w = 9, h = 8,
            path = 'Library,20,90,x',
            door = self.doors.library,
        },
        { -- Post Office
            x = 126, y = 129,
            w = 9, h = 8,
            path = 'PostOffice,10,10,x',
            door = self.doors.postoffice
        },
        { -- General Store
            x = 44, y = 122,
            w = 9, h = 8,
            path = 'Shop,10,10,x',
            door = self.doors.store
        }
    }
    self.renderWarps = true

    self.animatedObjects = {
        schoolFlag = AnimatedObject.new(self.world, self.gamestate.graphics.SchoolFlag, 184, 70, 88, 160, 3, 3),
        beerSign = AnimatedObject.new(self.world, self.gamestate.graphics.BeerSign, 20, 80, 56, 80, 14, 5)
    }

	return self
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

function M:load(x, y)
    PhysicalGameState.load(self, x, y)
	self.gamestate.ensureBGMusic("theme")
end

function M:save()
end


return M