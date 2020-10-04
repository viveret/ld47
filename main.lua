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
PlaySoundEvent = require "src.events.PlaySoundEvent"
RoomTextEvent = require "src.events.RoomTextEvent"
ToggleFlagEvent = require "src.events.ToggleFlagEvent"
WarpEvent = require "src.events.WarpEvent"

Camera = require "src.Camera"
TimedGameState = require "src.gamestates.TimedGameState"
gamestate = require "src.gamestate"
timeline = require "src.timeline"
player = require "src.player"
door = require "src.world.door"
toast = require "src.toast"
animation = require "src.animation"
actor = require "src.world.actor"


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
