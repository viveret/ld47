_windowWidth, _windowHeight = 1920, 1080
_renderWidth, _renderHeight = love.graphics.getDimensions()
OS = love.system.getOS()

lg = love.graphics
la = love.audio
lm = love.mouse
lk = love.keyboard
lfs = love.filesystem

lume = require "lib.lume"
kuey = require "lib.kuey"
lume.extend(_G, math)

gamestate = require "src.gamestate"
StartNewGameState = require "src.gamestates.StartNewGameState"

function love.draw()
    _renderWidth, _renderHeight = love.graphics.getDimensions()
    gamestate.draw()
end
function love.update()
    gamestate.update()
end
function love.load()
    love.window.setMode(_renderWidth, _renderHeight, { resizable = true })
    
    if gamestate.savesFolderExists() then
        gamestate.push(StartNewGameState)
    else
        gamestate.load()
    end
end