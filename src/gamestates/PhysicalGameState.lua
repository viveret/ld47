TimedGameState = require "src.gamestates.TimedGameState"
local M = setmetatable({}, { __index = TimedGameState })
M.__index = M

local timeline = require "src.timeline"

function M.new(gamestate, name, bg)
    local self = setmetatable(TimedGameState.new(gamestate, name), M)
	self.background = bg
	return self
end

function M:draw()
    -- TimedGameState.draw(self)

    if self.gamestate ~= nil then
        self.gamestate.graphics.drawObjectFit(self.background, 0, 0)
        self.gamestate.player.draw()
    end

    lg.print("You are in " .. self.name, 0, 0)
end

function M:update()
    TimedGameState.update(self)
    self.gamestate.player.update()
end

function M:load()
    TimedGameState.load(self)
end

function M.save()
end


return M