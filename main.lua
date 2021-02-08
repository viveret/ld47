_windowWidth, _windowHeight = 800, 600
_renderWidth, _renderHeight = love.graphics.getDimensions()
OS = love.system.getOS()

lg = love.graphics
la = love.audio
lm = love.mouse
lk = love.keyboard
lp = love.physics
lfs = love.filesystem

--PROF_CAPTURE = true
prof = require("lib.jprof.jprof")

binser = require "lib.binser"
lume = require "lib.lume"
kuey = require "lib.kuey"
inspect = require "lib.inspect"
say = require "lib.say"

require('src.languages.en')

lume.extend(_G, math)

Color = require "src.core.Color"
DateTime = require "src.core.DateTime"
TimeSpan = require "src.core.TimeSpan"

eventTypes = require "src.eventTypes"
uiComponents = require "src.uiComponents"

Camera = require "src.Camera"
ManualCamera = require "src.ManualCamera"
TimedGameState = require "src.gamestates.TimedGameState"
InventoryItem = require "src.inventory.InventoryItem"
Inventory = require "src.inventory.Inventory"
require "src.game"
timeline = require "src.timeline"
door = require "src.world.door"
animation = require "src.animation"
timelineCallbacks = require "src.world.timelineCallbacks"
StaticObject = require "src.world.StaticObject"


function donothing()
end

function interpolateValues(a, b, v)
    local r = {}
    for k,av in pairs(a) do
        r[k] = lume.lerp(av, b[k], v)
    end
    return r
end


function love.draw()
    _renderWidth, _renderHeight = love.graphics.getDimensions()
    game.draw()
    prof.pop("frame")
end
function love.update(dt)
    prof.push("frame")
    game.update(dt)
end
function love.load()
    love.window.setMode(_renderWidth, _renderHeight, { resizable = false, minwidth = _windowWidth, minheight = _windowHeight })
    love.window.setTitle("Return to Loop's Bend")
    love.audio.setVolume(0)
    game.init()
end
function love.quit()
    prof.write("prof.mpack")
end

love.keypressed = game.keypressed
love.keyreleased = game.keyreleased