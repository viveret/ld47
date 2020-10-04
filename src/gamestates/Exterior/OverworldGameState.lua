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
            x = 45 + 35 + 10, y = 2,
            w = 30, h = 4
        },
        { -- Building 2
            x = 130, y = 2,
            w = 28, h = 20
        },
        { -- Building 3
            x = 125, y = 40,
            w = 35, h = 23
        }
    })
    self.renderBounds = true
    
    self.warps = {
        { -- Home
            x = 135, y = 115,
            w = 20, h = 10,
            path = 'Home,65,55,x'
        },
        { -- Swamp
            x = 0, y = 100,
            w = 5, h = 5,
            path = 'Swamp,-30,-35,x'
        },
        { -- Coffee
            x = 50, y = 100,
            w = 5, h = 5,
            path = 'Coffee,-30,-35,x'
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
	self.gamestate.ensureBGMusic("overworld")
end

function M:save()
end


return M