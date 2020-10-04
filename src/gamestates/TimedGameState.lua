local M = {}
M.__index = M

function M.new(gamestate, scene)
    local self = setmetatable({
        gamestate = gamestate,
        scene = scene,
        fracSec = nil
	}, M)
	return self
end

function M:update(dt)
    -- check to see if something is ready to happen
    local time = self.gamestate.time
    local nextEvent = self.nextEvent

    if nextEvent ~= nil then
        if nextEvent.time == time then
            -- fire the event
            self.gamestate.fire(nextEvent.action)

            -- lookup the next event
            self.nextEvent = timeline.nextEvent(self.timeline, self.gamestate.time, self.gamestate.flags)
        end
    end
end

function M:load()
    -- load relevant timeline
    self.timeline = timeline.lookup(self.gamestate.timeline, self.scene, self.gamestate.time)
    
    self:recalcTimeline()
end

function M:switchTo(x, y)

end

function M:save()
end

function M:recalcTimeline() 
    -- what comes next?
    local oldEvent = self.nextEvent

    self.nextEvent = timeline.nextEvent(self.timeline, self.gamestate.time, self.gamestate.flags)

    if oldEvent ~= self.nextEvent then
        print(self.scene.." changed next event: "..self.nextEvent.action.type.." at "..self.nextEvent.time)
    end
end

return M