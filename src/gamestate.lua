local gamestate = {
    stack = {},
    timeline = {}
}
lfs = love.filesystem
lume = require "lib.lume"

function donothing()
end

_empty = {
    draw = donothing,
    update = donothing,
    load = donothing
}

function gamestate.load(name)
    randomseed(os.time())

    -- load timeline
    local timelineLines = lfs.lines("assets/timeline/timeline.csv")
    gamestate.timeline = Timeline_load(timelineLines)

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
    table.insert(gamestate.stack, newGamestate)
end

function gamestate.pop()
    table.remove(gamestate.stack)
end

function gamestate.draw()
    return gamestate.current().draw()
end

function gamestate.update()
    return gamestate.current().update()
end

function gamestate.load()
    return gamestate.current().load()
end



return gamestate