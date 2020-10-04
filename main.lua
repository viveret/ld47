_windowWidth, _windowHeight = 800, 600
_renderWidth, _renderHeight = love.graphics.getDimensions()
OS = love.system.getOS()

lg = love.graphics
la = love.audio
lm = love.mouse
lk = love.keyboard
lp = love.physics
lfs = love.filesystem

lume = require "lib.lume"
kuey = require "lib.kuey"
lume.extend(_G, math)

ActorSpawnEvent = require "src.events.ActorSpawnEvent"
ActorMoveEvent = require "src.events.ActorMoveEvent"
ActorDespawnEvent = require "src.events.ActorDespawnEvent"
ActorSpeakEvent = require "src.events.ActorSpeakEvent"
ActorTextEvent = require "src.events.ActorTextEvent"
PlaySoundEvent = require "src.events.PlaySoundEvent"
RoomTextEvent = require "src.events.RoomTextEvent"
ToggleFlagEvent = require "src.events.ToggleFlagEvent"
WarpEvent = require "src.events.WarpEvent"
NewGameEvent = require "src.events.NewGameEvent"
ContinueGameEvent = require "src.events.ContinueGameEvent"
QuitGameEvent = require "src.events.QuitGameEvent"
ManualCameraEvent = require "src.events.ManualCameraEvent"
GameOverEvent = require "src.events.GameOverEvent"
GlobalAmbientColorEvent = require "src.events.GlobalAmbientColorEvent"

Camera = require "src.Camera"
ManualCamera = require "src.ManualCamera"
TimedGameState = require "src.gamestates.TimedGameState"
MenuGameState = require "src.gamestates.Menu.MenuGameState"
gamestate = require "src.gamestate"
timeline = require "src.timeline"
player = require "src.player"
door = require "src.world.door"
toast = require "src.toast"
animation = require "src.animation"
actor = require "src.world.actor"
actorCallbacks = require "src.world.actorCallbacks"


function interpolateValues(a, b, v)
    local r = {}
    for k,av in pairs(a) do
        r[k] = (b[k] - av) * v + av
    end
    return r
end


function love.draw()
    _renderWidth, _renderHeight = love.graphics.getDimensions()
    gamestate.draw()
end
function love.update(dt)
    gamestate.update(dt)
end
function love.load()
    love.window.setMode(_renderWidth, _renderHeight, { resizable = false, minwidth = _windowWidth, minheight = _windowHeight })
    love.window.setTitle("Trouble Stirring at Loop's Bend")
    gamestate.load()
end
