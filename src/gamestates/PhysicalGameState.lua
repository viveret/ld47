TimedGameState = require "src.gamestates.TimedGameState"
local M = setmetatable({}, { __index = TimedGameState })
M.__index = M

local timeline = require "src.timeline"
local player = require "src.player"

function M.new(gamestate, name, bg)
    local self = setmetatable(TimedGameState.new(gamestate, name), M)
    self.background = bg
    self.world = lp.newWorld(0, 0, true)
    self.player = nil
	return self
end

function M:draw()
    -- TimedGameState.draw(self)

    if self.gamestate ~= nil then
        self.gamestate.graphics.drawObject(self.background, 0, 0)
        self.player:draw()
    end

    lg.print("You are in " .. self.name, 0, 0)
end

function M:update(dt)
    TimedGameState.update(self)
    self.world:update(dt)
    self.player:update(dt)
end

function M:load(x, y)
    TimedGameState.load(self)
    self.player = player.new(self.world, x, y)
end

function M.save()
end


return M