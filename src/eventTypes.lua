local M = {
    ActorSpawnEvent = require "src.events.ActorSpawnEvent",
    ActorMoveEvent = require "src.events.ActorMoveEvent",
    ActorDespawnEvent = require "src.events.ActorDespawnEvent",
    ActorSpeakEvent = require "src.events.ActorSpeakEvent",
    ActorTextEvent = require "src.events.ActorTextEvent",
    PlaySoundEvent = require "src.events.PlaySoundEvent",
    RoomTextEvent = require "src.events.RoomTextEvent",
    ToggleFlagEvent = require "src.events.ToggleFlagEvent",
    WarpEvent = require "src.events.WarpEvent",
    NewGameEvent = require "src.events.NewGameEvent",
    LoadGameEvent = require "src.events.LoadGameEvent",
    LoadSaveEvent = require "src.events.LoadSaveEvent",
    ClearAllSavesEvent = require "src.events.system.ClearAllSavesEvent",
    QuickLoadEvent = require "src.events.system.QuickLoadEvent",
    QuickSaveEvent = require "src.events.system.QuickSaveEvent",
    ContinueGameEvent = require "src.events.ContinueGameEvent",
    QuitGameEvent = require "src.events.QuitGameEvent",
    ManualCameraEvent = require "src.events.ManualCameraEvent",
    GameOverEvent = require "src.events.GameOverEvent",
    SetSaveDataEvent = require "src.events.SetSaveDataEvent",
    SpawnStaticObjectEvent = require "src.events.SpawnStaticObjectEvent",
    DespawnStaticObjectEvent = require "src.events.DespawnStaticObjectEvent",


    TabSelectedEvent = require "src.events.ui.TabSelectedEvent",
}

lume.extend(_G, M)

for k,ev in pairs(M) do
    if k:match('Event$') then
        M[k:sub(0, -6)] = ev
    end

    if ev.aliases then
        for i,alias in pairs(ev.aliases) do
            M[alias] = ev
        end
    end
end
return M