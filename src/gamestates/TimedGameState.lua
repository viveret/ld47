local M = {}
M.__index = M

local timeline = require "src.timeline"

function M.new(gamestate, name)
    local self = setmetatable({
        gamestate = gamestate,
        name = name
	}, M)
	return self
end

function M:update()
    -- check to see if something is ready to happen
    local time = self.gamestate.time
    local nextEvent = self.nextEvent

    if nextEvent == nil then
        return
    end

    if nextEvent.time == time then
        -- fire the event
        self.gamestate.fire(nextEvent.action)

        -- lookup the next event
        self.nextEvent = timeline.nextEvent(self.timeline, self.gamestate.time)
    end
end

function M:load()
    -- what can happen in the overworld?
    self.timeline = timeline.lookup(self.gamestate.timeline, self.name, self.gamestate.time, self.gamestate.flags)
    self.nextEvent = timeline.nextEvent(self.timeline, self.gamestate.time)
end

function M:save()
end


return M