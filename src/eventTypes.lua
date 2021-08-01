local M = recursiveRequire('src/events')
 -- {
    -- ActorSpawnEvent = require "src.events.ActorSpawnEvent",
    -- ActorMoveEvent = require "src.events.ActorMoveEvent",
    -- ActorDespawnEvent = require "src.events.ActorDespawnEvent",
    -- ActorSpeakEvent = require "src.events.ActorSpeakEvent",
    -- ActorTextEvent = require "src.events.ActorTextEvent",
    -- PlaySoundEvent = require "src.events.PlaySoundEvent",
    -- RoomTextEvent = require "src.events.RoomTextEvent",
    -- ToggleFlagEvent = require "src.events.ToggleFlagEvent",
    -- WarpEvent = require "src.events.WarpEvent",
    -- NewGameEvent = require "src.events.NewGameEvent",
    -- LoadGameEvent = require "src.events.LoadGameEvent",
    -- LoadSaveEvent = require "src.events.LoadSaveEvent",
    -- ClearAllSavesEvent = require "src.events.system.ClearAllSavesEvent",
    -- QuickLoadEvent = require "src.events.system.QuickLoadEvent",
    -- QuickSaveEvent = require "src.events.system.QuickSaveEvent",
    -- ContinueGameEvent = require "src.events.ContinueGameEvent",
    -- QuitGameEvent = require "src.events.QuitGameEvent",
    -- ManualCameraEvent = require "src.events.ManualCameraEvent",
    -- GameOverEvent = require "src.events.GameOverEvent",
    -- SetSaveDataEvent = require "src.events.SetSaveDataEvent",
    -- SpawnStaticObjectEvent = require "src.events.SpawnStaticObjectEvent",
    -- DespawnStaticObjectEvent = require "src.events.DespawnStaticObjectEvent",


    -- TabSelectedEvent = require "src.events.ui.TabSelectedEvent",
-- }

function aliasEvents(events)
    for k,ev in pairs(events) do
        if k:match('Event$') then
            local key = k:sub(0, -6)
            M[key] = ev
            events[key] = ev
        end

        if ev.aliases then
            for i,alias in pairs(ev.aliases) do
                M[alias] = ev
                events[alias] = ev
            end
        end

        if not ev.__index then
            aliasEvents(ev)
        end
    end
end

aliasEvents(M)

return M