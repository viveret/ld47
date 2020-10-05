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

function M:draw()
    local hours = floor(self.gamestate.time / (60 * 60)) + 1
    local minutes = floor(self.gamestate.time / 60) % 60 -- - (hours * 60 - 1)
    local amOrPm = "AM"
    if hours > 12 then
        hours = hours - 12
        amOrPm = "PM"
    end
    local friendlyTime = hours .. ":"
    
    if minutes > 9 then
        friendlyTime = friendlyTime .. minutes
    else
        friendlyTime = friendlyTime .. "0" .. minutes
    end

    friendlyTime = friendlyTime .. " " .. amOrPm

	self.graphics:drawObject(self.ui.dialog, x, y, width, height)
	
	-- render the text
    self.graphics:renderTextInBox(text, x + 180 + innerXGutter, y, maximumTextWidth, maximumTextHeight, self.ui.dialog_font)
    

    lg.print(friendlyTime, 0, lg.getHeight() - 48)
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

function M:activated()
end

function M:save()
end

function M:recalcTimeline() 
    -- what comes next?
    local oldEvent = self.nextEvent

    self.nextEvent = timeline.nextEvent(self.timeline, self.gamestate.time, self.gamestate.flags)

    if self.nextEvent ~= nil then
        if oldEvent == nil or oldEvent.time ~= self.nextEvent.time then
            print(self.scene.." changed next event: "..self.nextEvent.action.type.." at "..self.nextEvent.time)
        end
    end
end

return M