local super = require "src.gamestates.BaseGameState"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new(scene)
    local self = setmetatable(lume.extend({
        fracSec = nil,
        colors = {
            night = Color.new({ r = 0.5, g = 0.5, b = 0.6 }),
            day = Color.new({ r = 1, g = 1, b = 1 })
        },
        sunriseHourStart = 8,
        sunriseHourEnd = 9,
        sunsetHourStart = 19,
        sunsetHourEnd = 20,
        clock = uiComponents.widgets.Clock.new(),
	}, super.new(scene)), M)
	return self
end

function M:init()
    super.init(self)
    -- self.clock:init()
end

function M:draw()
    self.clock:draw()
end

function M:quicksave(state)
    --self.state.time = game.time:getSaveState()
    super.quicksave(self, state)
end

function M:quickload(state)
    super.quickload(self, state)
end

function M:switchTo(x, y)
    super.switchTo(self, x, y)
    -- load relevant timeline
    --self.timeline = timeline.lookup(game.timeline, self.scene, game.time)
end

function M:activated()
    self:performEventsSince(self.lastVisited)
    self:resolveNextEvents()
end

function M:getColorRightNow()
    local timeOfDay = game.time.hour + game.time.minute / 60 + game.time.second / 3600

    if timeOfDay < self.sunriseHourStart then
        return self.colors.night
    elseif timeOfDay < self.sunriseHourEnd then
        local sunriseDuration = self.sunriseHourEnd - self.sunriseHourStart
        return interpolateValues(self.colors.night, self.colors.day, (timeOfDay - self.sunriseHourStart) / (sunriseDuration))
    elseif timeOfDay < self.sunsetHourStart then
        return self.colors.day
    elseif timeOfDay < self.sunsetHourEnd then
        local sunsetDuration = self.sunsetHourEnd - self.sunsetHourStart
        return interpolateValues(self.colors.day, self.colors.night, (timeOfDay - self.sunsetHourStart) / (sunsetDuration))
    else
        return self.colors.night
    end
end

return M