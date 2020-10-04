PhysicalGameState = require "src.gamestates.PhysicalGameState"
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
        }
    })
    self.renderBounds = true
    
    self.warps = {
        { -- Home
            x = 180, y = 140,
            w = 20, h = 10,
            path = 'Home,50,120,x'
        },
        { -- Swamp
            x = 0, y = 122,
            w = 8, h = 10,
            path = 'Swamp,-30,-35,x'
        },
        { -- Bar
            x = 30, y = 80,
            w = 9, h = 8,
            path = 'Bar,20,15,x'
        },
        { -- Antiques
            x = 65, y = 80,
            w = 9, h = 8,
            path = 'Antiques,20,15,x'
        },
        { -- Coffee
            x = 95, y = 80,
            w = 9, h = 8,
            path = 'Coffee,20,15,x'
        },
        { -- School
            x = 173, y = 75,
            w = 9, h = 8,
            path = 'School,20,15,x'
        },
        { -- Doctor
            x = 176, y = 25,
            w = 9, h = 8,
            path = 'Doctor,20,15,x'
        },
        { -- Cemetery
            x = 100, y = 0,
            w = 5, h = 5,
            path = 'Cemetery,100,115,x'
        },
        { -- Library
            x = 125, y = 80,
            w = 9, h = 8,
            path = 'Library,20,90,x'
        },
    }
    self.renderWarps = true

    self.doors = {
        antiques = door.new(self.world, self.gamestate.graphics.AntiquesDoor, 50, 65),
        bar = door.new(self.world, self.gamestate.graphics.BarDoor, 23, 65),
        coffee = door.new(self.world, self.gamestate.graphics.CoffeeShopDoor, 75, 65),
        doctor = door.new(self.world, self.gamestate.graphics.DoctorDoor, 138, 20),
        library = door.new(self.world, self.gamestate.graphics.LibraryDoor, 100, 65),
        motelLeft = door.new(self.world, self.gamestate.graphics.MotelDoor, 8, 17),
        motelMiddle = door.new(self.world, self.gamestate.graphics.MotelDoor, 20, 17),
        motelRight = door.new(self.world, self.gamestate.graphics.MotelDoor, 40, 21),
        postoffice = door.new(self.world, self.gamestate.graphics.PostOfficeDoor, 100, 100),
        school = door.new(self.world, self.gamestate.graphics.SchoolDoor, 138, 62),
        store = door.new(self.world, self.gamestate.graphics.StoreDoor, 35, 97),
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