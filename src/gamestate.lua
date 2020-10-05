local gamestate = {
    stack = {},
    timeline = {},
    flags = {},
    time = 0,
    timedGameStateCreators = {
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
        MotelLobby = require "src.gamestates.Interior.MotelLobbyGameState",
        PostOffice = require "src.gamestates.Interior.PostOfficeGameState",
        School = require "src.gamestates.Interior.SchoolGameState",
        Shop = require "src.gamestates.Interior.ShopGameState"
    },
    existingStates = { },
    createStates = {
        -- Other
        Title = require "src.gamestates.Menu.TitleGameState",
        StartNewGame = require "src.gamestates.StartNewGameState",
        DialogGame = require "src.gamestates.DialogGameState",
        Pause = require "src.gamestates.Menu.PauseGameState",
        GameOver = require "src.gamestates.Menu.GameOverGameState",
    },
    backgroundMusic = { },
    events = {},
    saveData = {},
    initial = {
        location = 'Home,50,50,x'
    },
    fracSec = 0
}
lfs = love.filesystem
lume = require "lib.lume"

local audio = require "src.audio"
local graphics = require "src.graphics"
local images = require "src.images"
local animations = require "src.animations"

function donothing()
end

_empty = {
    draw = donothing,
    update = donothing,
    load = donothing,
    keypressed = donothing,
    keyreleased = donothing,
}

function gamestate.hasProgress()
    return gamestate.dirty
end

function gamestate.save(autosave)
    
end

function gamestate.keypressed( key, scancode, isrepeat )
    if not isrepeat then
        if key == 'p' then
            gamestate.warpTo('Pause,0,0,x')
        elseif key == 'space' then
            local currentPlayer = gamestate.current().player
            if currentPlayer ~= nil then
                currentPlayer:doInteraction()
            end
        end
    end

    gamestate.current():keypressed( key, scancode, isrepeat )
end

function gamestate.keyreleased( key, scancode )
    gamestate.current():keyreleased( key, scancode )
end

function gamestate.clear()
    gamestate.time = 0
    gamestate.flags = {}
    gamestate.stack = {}
    -- gamestate.saveData = {}
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

-- transition to a different gamestate here
function gamestate.switchTo(toGamestate)
    if toGamestate == nil then
        error('toGamestate must not be nil')
    end

    --print("switchTo "..toGamestate.scene)

    local moved = false

    for ix, state in ipairs(gamestate.stack) do
        if state == toGamestate then
            table.remove(gamestate.stack, ix)
            moved = true
        end
    end

    gamestate.push(toGamestate)
    gamestate.markTopmost(toGamestate)

    for _, state in ipairs(gamestate.stack) do
        if not state.topmost and state.player ~= nil then
            state.player.body:setActive(false)
        end
        if state.topmost and state.player ~= nil then
            state.player.body:setActive(true)
        end
    end

    --print("switchTo, queue "..#gamestate.stack)
    --print("switchTo, new current "..gamestate.current().scene)
end

-- push a NEW gamestate here
function gamestate.push(newGamestate)
    if newGamestate ~= nil then
        -- print("pushing "..newGamestate.scene)
        table.insert(gamestate.stack, newGamestate)
    else
        error('newGamestate must not be nil')
    end

    gamestate.markTopmost(newGamestate)

    --print("push, queue "..#gamestate.stack)
    --print("push, new current "..gamestate.current().scene)
end

function gamestate.markTopmost(toGamestate)
    toGamestate:activated()
    for _, state in ipairs(gamestate.stack) do
        state.topmost = toGamestate == state
    end
end

function gamestate.pop()
    table.remove(gamestate.stack)

    local current = gamestate:current()
    if current ~= nil then
        gamestate.markTopmost(current)
    end
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
    if gamestate.toast ~= nil then
        gamestate.toast:draw()
    end
end

function gamestate.updateForTimespassed(dt)
    local tickEverySeconds = 60

    local secondsSinceLastUpdate = dt

    if gamestate.fracSec ~= nil then
        secondsSinceLastUpdate = dt + gamestate.fracSec
    end

    local ticks = secondsSinceLastUpdate / tickEverySeconds
    local wholeTicks = math.floor(ticks)
    local remainder = secondsSinceLastUpdate - (wholeTicks * tickEverySeconds)

    gamestate.fracSec = remainder

    return wholeTicks
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

    local currentGameState = gamestate.current()

    local currentNeedsUpdate = true

    -- pump everything if time is passing
    if currentGameState.isPhysicalGameState then
        local ticks = gamestate.updateForTimespassed(dt)

        for i=0,ticks,1 do
            -- advance time, this always happens...
            gamestate.time = gamestate.time + 1

            -- pump every "time-y" state
            for key, existing in pairs(gamestate.existingStates) do
                existing:update(1/60)   -- every step is always the same length

                if existing == currentGameState then
                    currentNeedsUpdate = false
                end
            end

            -- tick the toast
            if gamestate.toast ~= nil then
                gamestate.toast:tick()
            end
        end 
    else
        currentGameState:update(dt)
    end
end

function gamestate.load()
    randomseed(os.time())

    -- universal setup
    gamestate.graphics = graphics.new()
    gamestate.images = images.new(gamestate.graphics)
    gamestate.animations = animations.new(gamestate.images)
    gamestate.audio = audio.load()

    -- time is 0 now
    gamestate.time = 0

    -- no flags currently set
    gamestate.flags = {}

    -- load timeline
    local timelineLines = lfs.lines("assets/timeline/timeline.csv")
    gamestate.timeline = timeline.load(timelineLines)

    -- spin up the TimedGameStates

    for key, creator in pairs(gamestate.timedGameStateCreators) do
        local state = creator.new(gamestate)
        state:load()
        gamestate.existingStates[key] = state
        gamestate.push(state)
    end

    -- initialize
    gamestate.init()
end

function gamestate.init()
    gamestate.setFlag("NotDoneJob")
    gamestate.setFlag("NotServedcustomerOne")
    gamestate.setFlag("NotServedcustomerTwo")
    gamestate.setFlag("NotServedcustomerThree")
    gamestate.setFlag("NotServedcustomerFour")
    gamestate.setFlag("has-not-reserved-room")
    gamestate.setFlag("NotSeenSickCultist")

    -- start at title
    gamestate.warpTo('Title,0,0,x')
end

function gamestate.setFlag(flag)
    print("setFlag("..flag..")")

    local alreadySet = false
    for _, setFlag in ipairs(gamestate.flags) do
        if setFlag == flag then
            alreadySet = true
            break
        end 
    end

    if alreadySet then
        return
    end

    table.insert(gamestate.flags, flag)

    gamestate.recalcTimeline()
end

function gamestate.clearFlag(flag) 
    print("clearFlag("..flag..")")

    for ix, setFlag in ipairs(gamestate.flags) do
        if flag == setFlag then
            table.remove(gamestate.flags, ix)
            break
        end
    end

    gamestate.recalcTimeline()
end

function gamestate.hasFlag(flag)
    for _, setFlag in ipairs(gamestate.flags) do
        if setFlag == flag then
            return true
        end
    end

    return false
end

function gamestate.recalcTimeline()
    for key, existing in pairs(gamestate.existingStates) do
        existing:recalcTimeline()
    end
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
    print('Warp to ' .. path)
    local scene, x, y, etc = path:match("^%s*(.-),%s*(.-),%s*(.-),%s*(.-)$")

    local existing = gamestate.existingStates[scene]
    local create = gamestate.createStates[scene]

    if existing ~= nil then
        gamestate.switchTo(existing)
        existing:switchTo(tonumber(x), tonumber(y))
    elseif create ~= nil then
        local newState = create.new(gamestate)
        newState.type = scene
        gamestate.push(newState)
        gamestate.current():load(tonumber(x), tonumber(y))
    else 
        error ('Invalid stateType ' .. scene)
    end
end

function gamestate.newGame()
    gamestate.saveData = {
        dirty = true
    }
    gamestate.warpTo(gamestate.initial.location)
end

function gamestate.continueGame()
    local lastType = lume.last(gamestate.stack).type
    
    if lastType == 'Pause' then
        gamestate.pop()
    elseif lastType == 'GameOver' then
        gamestate.clear()
        gamestate.init()
    end
end

function gamestate.quitGame()
    love.event.quit()
end

function gamestate.gameOver()
    gamestate.warpTo('GameOver,0,0,x')
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