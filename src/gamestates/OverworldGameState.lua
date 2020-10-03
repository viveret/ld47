local M = {}

local timeline = require "src.timeline"

function M.draw()
    lg.print("You are in the overworld", 0, 0)

    if M.gamestate ~= nil then
        M.gamestate.graphics.drawObjectFit(M.gamestate.graphics.Overworld, 0, 0)
    end
end

function M.update()
    -- check to see if something is ready to happen
    local time = M.gamestate.time
    local nextEvent = M.nextEvent

    if nextEvent == nil then
        return
    end

    if nextEvent.time == time then
        -- fire the event
        M.gamestate.fire(nextEvent.action)

        -- lookup the next event
        M.nextEvent = timeline.nextEvent(M.timeline, M.gamestate.time)
    end
end

function M.load(gamestate)
    M.gamestate = gamestate

    -- what can happen in the overworld?
    M.timeline = timeline.lookup(M.gamestate.timeline, 'Overworld', gamestate.time, gamestate.flags)
    M.nextEvent = timeline.nextEvent(M.timeline, M.gamestate.time)
end

function M.save()
end


return M