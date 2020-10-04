local gamestate = {
    stack = {},
    timeline = {},
    flags = {},
    time = 0,
    states = {
        -- Exterior
        Overworld = require "src.gamestates.Exterior.OverworldGameState",
        Swamp = require "src.gamestates.Exterior.SwampGameState",
        Cemetery = require "src.gamestates.Exterior.CemeteryGameState",

        -- Interior
        Antiques = require "src.gamestates.Interior.AntiquesGameState",
        Bar = require "src.gamestates.Interior.BarGameState",
        Coffee = require "src.gamestates.Interior.CoffeeGameState",
        Home = require "src.gamestates.Interior.HomeGameState",
        Doctor = require "src.gamestates.Interior.DoctorGameState",
        Library = require "src.gamestates.Interior.LibraryGameState",
        Motel = require "src.gamestates.Interior.MotelGameState",
        PostOffice = require "src.gamestates.Interior.PostOfficeGameState",
        School = require "src.gamestates.Interior.SchoolGameState",
        Shop = require "src.gamestates.Interior.ShopGameState",
        
        -- Other
        Title = require "src.gamestates.Menu.TitleGameState",
        StartNewGame = require "src.gamestates.StartNewGameState",
        DialogGame = require "src.gamestates.DialogGameState",
        Pause = require "src.gamestates.Menu.PauseGameState",
    },
    backgroundMusic = { },
    events = {},
    saveData = {
        location = nil,
    },
    initial = {
        location = 'Home,65,55,x'
    }
}
lfs = love.filesystem
lume = require "lib.lume"

local audio = require "src.audio"
local timeline = require "src.timeline"
local graphics = require "src.graphics"

function donothing()
end

_empty = {
    draw = donothing,
    update = donothing,
    load = donothing
}

function gamestate.hasProgress()
    return gamestate.saveData.location ~= nil
end

function gamestate.save(autosave)
    
end

function gamestate.clear()
    lfs.remove("saves")
end

function gamestate.getWidth()
    return gamestate.current():getWidth()
end

function gamestate.getHeight()
    return gamestate.current():getHeight()
end

function gamestate.current()
    if lume.count(gamestate.stack) > 0 then
        return lume.last(gamestate.stack)
    else
        return _empty
    end
end

function gamestate.push(newGamestate)
    if newGamestate ~= nil then
        table.insert(gamestate.stack, newGamestate)
    else
        error('newGamestate must not be nil')
    end
end

function gamestate.pop()
    table.remove(gamestate.stack)
end

function gamestate.replace(newGamestate)
    if newGamestate ~= nil then
        gamestate.pop()
        gamestate.push(newGamestate)
    else
        error('newGamestate must not be nil')
    end
end

function gamestate.draw()
    gamestate.current():draw()
end

function gamestate.update(dt)
    -- handle any fadeouts that are in progress
    gamestate.advanceBGMusic()

    if #gamestate.events > 0 then
        local tmp = gamestate.events
        gamestate.events = {}
        for k, ev in pairs(tmp) do
            ev:fireOn(gamestate)
        end
    end

    return gamestate.current():update(dt)
end

function gamestate.load()
    randomseed(os.time())
    
    -- universal setup
    gamestate.graphics = graphics.new()
    gamestate.audio = audio.load()

    -- time is 0 now
    gamestate.time = 0

    -- no flags currently set
    gamestate.flags = {}

    -- load timeline
    local timelineLines = lfs.lines("assets/timeline/timeline.csv")
    gamestate.timeline = timeline.load(timelineLines)

    -- spin up toast
    toast.init(gamestate)

    -- start at title
    gamestate.warpTo('Title,0,0,x')
end

function gamestate.setFlag(flag)
    if not gamestate.flags[flag] then
        gamestate.flags[flag] = true
    end
end

function gamestate.clearFlag(flag) 
    if gamestate.flags[flag] then
        gamestate.flags[flag] = nil
    end
end

function gamestate.hasFlag(flag)
    if gamestate.flags[flag] then
        return true
    end

    return false
end

function gamestate.fire(ev, queue)
    if queue then
        table.insert(gamestate.events, ev)
    else
        return ev:fireOn(gamestate)
    end
end

function gamestate.warpTo(path)
    if path == nil or path == '' then
        error('path cannot be nil or empty')
    end
    print(path)
    local scene, x, y, etc = path:match("^%s*(.-),%s*(.-),%s*(.-),%s*(.-)$")
    local stateType = gamestate.states[scene]
    if stateType ~= nil then
        local newState = stateType.new(gamestate)
        newState.type = scene
        if gamestate.current().isPhysicalGameState then
            gamestate.push(newState)
        else
            gamestate.replace(newState)
        end
        gamestate.current():load(x, y)
        gamestate.saveData.location = path
    else
        error ('Invalid stateType ' .. scene)
    end
end

function gamestate.newGame()
    gamestate.warpTo(gamestate.initial.location)
end

function gamestate.continueGame()
    if lume.last(gamestate.stack).type == 'Pause' then
        gamestate.pop()
    else
        gamestate.warpTo(gamestate.saveData.location)
    end
end

function gamestate.quitGame()
    love.event.quit()
end

function gamestate.ensureBGMusic(bgMusicName)
    local source = gamestate.audio[bgMusicName]:clone()

    source:setVolume(0)
    source:setLooping(true)
    source:play()

    table.insert(gamestate.backgroundMusic, source)
end

function gamestate.advanceBGMusic()
    local fadeOverSeconds = 5
    local step =  1 / (60 * fadeOverSeconds)

    local bg = gamestate.backgroundMusic

    local queued = #gamestate.backgroundMusic

    if queued == 0 then
        return
    end

    local current = gamestate.backgroundMusic[1]

    local shouldFadeOut = queued > 1

    local curVol = current:getVolume()

    if curVol == 1 and not shouldFadeOut then
        -- nothing to do
        return
    end

    -- update current volume
    if shouldFadeOut then
        curVol = curVol - step
    else 
        curVol = curVol + step
    end

    if curVol < 0  then
        curVol = 0
    end

    if curVol > 1  then
        curVol = 1
    end

    current:setVolume(curVol)

    -- update next volume (if we're also fading it in)
    if shouldFadeOut then
        local next = gamestate.backgroundMusic[2]

        local nextVol = next:getVolume()
        nextVol = nextVol + step
        if nextVol > 1 then
            nextVol = 1
        end

        next:setVolume(nextVol)
    end

    -- if current is completely faded out, toss it
    if curVol == 0 then
        current:stop()
        current:release()
        table.remove(gamestate.backgroundMusic, 1)
    end
end

return gamestate