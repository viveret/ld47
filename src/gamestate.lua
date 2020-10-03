local gamestate = {
    stack = {},
    timeline = {},
    flags = {},
    time = 0,
    states = {
        StartNewGame = require "src.gamestates.StartNewGameState",
        OverworldGame = require "src.gamestates.OverworldGameState"
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

    if gamestate.roomText ~= nil then
        love.graphics.print(gamestate.roomText, _renderWidth / 2, _renderHeight / 2)
    end
end

function gamestate.update(dt)
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

    -- initialize specific state
    if gamestate.savesFolderExists() then
        gamestate.warpTo('OverworldGame,0,0,x')
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

function gamestate.showRoomText(text)
    gamestate.roomText = text
end

function gamestate.warpTo(path)
    local scene, x, y, etc = path:match("^%s*(.-),%s*(.-),%s*(.-),%s*(.-)$")
    local stateType = gamestate.states[scene]
    gamestate.push(stateType.new(gamestate))
    gamestate.current():load(x, y)
end

return gamestate