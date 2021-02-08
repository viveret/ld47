local M = {}
M.__index = M

function M.new(scene)
    local self = setmetatable({
        scene = scene,
        fracSec = nil,
        colors = {
            night = Color.new({ r = 0.5, g = 0.5, b = 0.6 }),
            day = Color.new({ r = 1, g = 1, b = 1 })
        },
        sunriseHourStart = 8,
        sunriseHourEnd = 9,
        sunsetHourStart = 19,
        sunsetHourEnd = 20,
        state = {
            
        },
        states = {},
	}, M)
	return self
end

function M:draw()
    game.ui.clock:draw()
end

function M:tick(ticks)
end

function M:update(dt)
end

function M:save()
end

function M:load()
    -- load relevant timeline
    --self.timeline = timeline.lookup(game.timeline, self.scene, game.time)
end

function M:quicksave()
    self.state.time = game.time
    table.push(self.states, lume.extend({}, self.state))
end

function M:quickload(state)
    if state == nil then
        self.state.time = game.time
    elseif state < 0 then
    else
    end
end

function M:reload()
    self:quickload(self.initialState)
end

function M:switchTo(x, y)
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