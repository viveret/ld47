local M = {}
M.__index = M

local timeline = require "src.timeline"

function M.new(gamestate, name)
    local self = setmetatable({
        gamestate = gamestate,
        name = name,
        fracSec = nil
	}, M)
	return self
end

function M:update(dt)
    local tickEverySeconds = 1 / 60

    local secondsSinceLastUpdate = dt

    if self.fracSec ~= nil then
        secondsSinceLastUpdate = dt + self.fracSec
    end

    local ticks = secondsSinceLastUpdate / tickEverySeconds
    local wholeTicks = math.floor(ticks)
    local remainder = secondsSinceLastUpdate - (wholeTicks * tickEverySeconds)

    for i=0,wholeTicks,1 do
        -- check to see if something is ready to happen
        local time = self.gamestate.time
        local nextEvent = self.nextEvent

        if nextEvent ~= nil then
            if nextEvent.time == time then
                -- fire the event
                self.gamestate.fire(nextEvent.action)

                -- lookup the next event
                self.nextEvent = timeline.nextEvent(self.timeline, self.gamestate.time)
            end
        end

        -- advance time, this always happens...
        self.gamestate.time = self.gamestate.time + 1
        toast.tick()
    end

    self.fracSec = remainder
end

function M:load()
    -- load relevant timeline
    self.timeline = timeline.lookup(self.gamestate.timeline, self.name, self.gamestate.time, self.gamestate.flags)
    -- what comes next?
    self.nextEvent = timeline.nextEvent(self.timeline, self.gamestate.time)
end

function M:save()
end


return M