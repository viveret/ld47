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
Promise = require "lib.promise.promise"

require('src.languages.en')

require "src.util.util"
typeReload = require "src.util.typeReload"

mathExtensions = require('src.util.math')
extendMissingKeysOrError(math, mathExtensions)
lume.extend(_G, math)

Color = require "src.core.Color"
DateTime = require "src.core.DateTime"
TimeSpan = require "src.core.TimeSpan"

require "src.eventTypes"
require "src.gameStateTypes"
uiComponents = recursiveRequire("src.components.ui", { suffixToRemove = "View" })

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




function reloadPlayer()
    typeReload.reloadWithinObject(game.currentPhysical().player)
end

function reloadCurrentScene()
    typeReload.reloadWithinObject(game.currentPhysical())
end