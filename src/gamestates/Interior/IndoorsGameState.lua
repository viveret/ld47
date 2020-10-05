PhysicalGameState = require "src.gamestates.PhysicalGameState"
local M = setmetatable({}, { __index = PhysicalGameState })
M.__index = M

function M.new(gamestate, name, graphics)
    local self = setmetatable(PhysicalGameState.new(gamestate, name, graphics), M)
    self:addExteriorWorldBounds()
	return self
end

function M:draw()
    PhysicalGameState.draw(self)
end

function M:update(dt)
    PhysicalGameState.update(self, dt)
end

function M:load()
    PhysicalGameState.load(self, x, y)
end

function M:switchTo(x, y)
    PhysicalGameState.switchTo(self, x, y)

    if self.lightsAreOn or true then
        self.colors = {
            night = { r = 0.9, g = 0.7, b = 0.7 },
            day = { r = 1, g = 1, b = 1 }
        }
    end
end

function M.save()
end


return M