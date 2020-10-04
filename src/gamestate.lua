local gamestate = {
    stack = {},
    timeline = {},
    flags = {},
    time = 0,
    states = {
        StartNewGame = require "src.gamestates.StartNewGameState",
        OverworldGame = require "src.gamestates.OverworldGameState",
        DialogGame = require "src.gamestates.DialogGameState"
    },
    backgroundMusic = { }
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

function gamestate.load(name)
    randomseed(os.time())
    --[[
    local Encoded = Kuey.encode("Love is life!", "love2d") -- Encode the string with "love2d" as key
    print(Encoded)                                         -- Show the encoded string
    print(Kuey.decode(Encoded, "anykey"))                  -- Try to show a decoded string with any key
    print(Kuey.decode(Encoded, "love2d"))                  -- Show the decoded string with the correct key
    ]]--
    path = 'saves/' .. (name or lume.first(gamestate.list()) or '') .. '.txt'
    print(path)
    if lfs.getInfo(path) ~= nil then
        file = lfs.read(path)
        state = lume.deserialize(file)
        gamestate.stack.push(state)
    end
end

function gamestate.list()
    if gamestate.savesFolderExists() then
        return lfs.getDirectoryItems("saves")
    else
        return {}
    end
end

function gamestate.savesFolderExists()
    local savesInfo = lfs.getInfo("saves")
    return not savesInfo ~= nil
end

function gamestate.save(autosave)
    if gamestate.savesFolderExists() == false then
        lfs.createDirectory("saves")
    end
    -- save state (and record datetime / if autosave)

    --[[
    local Encoded = Kuey.encode("Love is life!", "love2d") -- Encode the string with "love2d" as key
    print(Encoded)                                         -- Show the encoded string
    print(Kuey.decode(Encoded, "anykey"))                  -- Try to show a decoded string with any key
    print(Kuey.decode(Encoded, "love2d"))                  -- Show the decoded string with the correct key
    ]]--
    serialized = lume.serialize(gamestate.current())
    lfs.write('saves/' .. 'name' .. '.txt', serialized)
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
        gamestate.stack[-1] = newGamestate
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

    return gamestate.current():update(dt)
end

function gamestate.load()
    -- universal setup
    gamestate.graphics = graphics.load()
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

    -- initialize specific state
    if gamestate.savesFolderExists() then
        gamestate.warpTo('OverworldGame,65,55,x')
    else
        gamestate.warpTo('OverworldGame,0,0,x')
    end
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

function gamestate.fire(ev)
    return ev.fireOn(ev, gamestate)
end

function gamestate.warpTo(path)
    local scene, x, y, etc = path:match("^%s*(.-),%s*(.-),%s*(.-),%s*(.-)$")
    local stateType = gamestate.states[scene]
    gamestate.push(stateType.new(gamestate))
    gamestate.current():load(x, y)
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