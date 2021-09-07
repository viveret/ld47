local audio = require "src.audio"
local graphics = require "src.graphics"
local images = require "src.images"
local animations = require "src.animations"
local GameStateLifecycleManager = require "src.components.system.GameStateLifecycleManager"
local SaveDataMgr = require "src.components.system.SaveDataMgr"
local data = recursiveRequire "src.data"

game = lume.extend({
    timeline = {},
    flags = {},
    fracSec = 0,
    timeWarp = 1,
    timeWarpMin = 1,
    timeWarpMax = 1000,
    timeWarpStep = 2,
    objectScale = 1/8,
    backgroundMusic = { },
    events = {},
    options = {
        language = 'en',
        textSpeed = 15, -- chars per second
    },
    debug = {
        keys = true,
        renderActors = false,
        renderWarps = false,
        renderBounds = false,
        renderObjects = false,
        renderFilenames = true,
        renderDebugUIEnabled = true,
        camera = {
            x = 0,
            y = 0,
            vx = 0,
            vy = 0,
            enabled = false,
        }
    },
    ui = {
        overlay = uiComponents.GameOverlay.new(),
        interactionTray = uiComponents.InGame.InteractionTray.new(),
    },
    saves = SaveDataMgr.new(),
}, data)

_empty = gameStates.Base.new('_empty')

-- https://github.com/bjornbytes/cargo
-- assets = cargo.init({
--     dir = 'my_assets',
--     loaders = {
--       jpg = love.graphics.newImage
--     },
--     processors = {
--       ['images/'] = function(image, filename)
--         image:setFilter('nearest', 'nearest')
--       end
--     }
--   })

function game.keypressed( key, scancode, isrepeat )
    game.stateMgr:keypressed( key, scancode, isrepeat )
end

function game.keyreleased( key, scancode )
    game.stateMgr:keyreleased( key, scancode )
end

function game.clear()
    game.stateMgr:clear()
    game.saves:clear()
    game.time = game.initial.time
    game.flags = {}
end

function game.getWidth()
    return game.stateMgr:current():getWidth()
end

function game.getHeight()
    return game.stateMgr:current():getHeight()
end

function game.draw()
    game.stateMgr:draw()
    game.ui.overlay:draw()
end

function game.updateForTimespassed(dt)
    local tickEverySeconds = 1 / 60

    local secondsSinceLastUpdate = dt

    if game.fracSec ~= nil then
        secondsSinceLastUpdate = dt + game.fracSec
    end

    local ticks = secondsSinceLastUpdate / tickEverySeconds
    local wholeTicks = math.floor(ticks)
    local remainder = secondsSinceLastUpdate - (wholeTicks * tickEverySeconds)

    game.fracSec = remainder

    return wholeTicks
end

function game.update(dt)
    Promise.update()

    -- handle any fadeouts that are in progress
    game.audio:update(dt)

    if #game.events > 0 then
        local tmp = game.events
        game.events = {}
        for k, ev in pairs(tmp) do
            game.fire(ev.ev, false, ev.args, ev.promise)
        end
    end

    game.stateMgr:update(dt)
    if game.stateMgr:isTransitioning() == false then
        local currentGameState = game.stateMgr:current()
    
        -- pump everything if time is passing
        if currentGameState and currentGameState.isPhysicalGameState then
            local ticks = game.updateForTimespassed(dt * pow(2, game.timeWarp))
            game.tick(ticks)
        end
    end

    game.ui.overlay:update(dt)
end

function game.tick(ticks)
    -- check to see if something has happened between ticks
    game.tickEvents(ticks)
    game.time:tick(ticks)

    -- tick the overlay
    game.ui.overlay.tick(ticks)
end

function game.tickEvents(ticks)
    if game.nextEvent ~= nil and #game.nextEvent > 0 then
        local time = lume.first(game.nextEvent).time
        if time:lessThanOrEqualTo(game.time) then
            -- fire the events
            for i,ev in pairs(game.nextEvent) do
                game.fire(ev.action)
            end

            -- lookup the next event
            game.nextEvent = game.queryNextEvents(time:addMS())
        end
    else
        game.nextEvent = game.queryNextEvents(game.time)
    end
end

function game.queryNextEvents(when)
    local ret = game.timeline:nextEvent(when, game.time:getAtMidnight())
    if ret == nil then
        print('No events in near future')
        return
    end
    print('Next events to be fired at ' .. when:tostring() ..  ' (' .. #ret .. '):')
    for i,ev in pairs(ret) do
        print('\t' .. i .. '): <' .. ev.action.type .. '> ' .. ev.action:tostring())
        --print('\t' .. i .. '): ' .. inspect(ev))
    end
    return ret
end

function game.timeWarpBumpDown()
    game.timeWarp = max(game.timeWarp - game.timeWarpStep, game.timeWarpMin)
end

function game.timeWarpBumpUp()
    game.timeWarp = min(game.timeWarp + game.timeWarpStep, game.timeWarpMax)
end

function game.init()
    randomseed(os.time())
    if game.options.language ~= 'en' then
        require('src.languages.' .. game.options.language)
    end

    game.graphics = graphics.new()
    game.images = images.new()
    game.animations = animations.new()
    game.audio = audio.new()

    game.items = {
        apple = InventoryItem.new('apple', game.images.timelineObjs.book, 'Apple', 'Delicious fruit',
        {
            title = 'Eat',
        },
        {
            title = 'Decompose',
        })
    }

    game.time = game.initial.time

    -- no flags currently set
    game.flags = {}

    -- Handles how states are created, deleted, switched to/away from, saved/loaded
    game.stateMgr = GameStateLifecycleManager.new()

    -- load timeline
    game.timeline = timeline.new()

    for _, flag in pairs(game.initial.flags) do
        game.setFlag(flag)
    end

    game.warpTo('title', gamestateTransitions.FadeIn)
end

function game.reload()
    game.stateMgr:reload()
end

function game.quickload()
    local state = game.saves:currentSlotMostRecentSaveState()
    game.state = state:getEntry("game-state"):load()
    game.stateMgr:quickload(state)
end

function game.quicksave()
    local state = game.saves:currentSlotMostRecentSaveState()
    state:getEntry("game-state"):save(game.state)
    game.stateMgr:quicksave(state)
end

function game.setFlag(flag)
    -- print("setFlag("..flag..")")

    local alreadySet = false
    for _, setFlag in ipairs(game.flags) do
        if setFlag == flag then
            alreadySet = true
            break
        end 
    end

    if alreadySet then
        return
    end

    table.insert(game.flags, flag)
end

function game.clearFlag(flag) 
    print("clearFlag("..flag..")")

    for ix, setFlag in ipairs(game.flags) do
        if flag == setFlag then
            table.remove(game.flags, ix)
            break
        end
    end
end

function game.hasFlag(flag)
    for _, setFlag in ipairs(game.flags) do
        if setFlag == flag then
            return true
        end
    end

    return false
end

function game.hasFlags(flags)
    for _, flag in ipairs(flags or error('flags is nil')) do
        if not game.hasFlag(flag) then
            return false
        end
    end

    return true
end

function game.fire(ev, queue, args, promise)
    local promise = promise or Promise.new()

    if queue then
        table.insert(game.events, { ev = ev, args = args, promise = promise })
    else
        trycatch(
            function()
                local result
                if args == nil then
                    result = ev:fireOn()
                else
                    result = ev:fireOn(unpack(args))
                end
                promise:resolve(result)
            end,
            function(ex)
                print('could not fire event: ' .. inspect(ev))
                print(ex)
                promise:reject(ex)
            end
        )
    end

    return promise
end

function game.note(text)
    game.saveData.notes = game.saveData.notes or {}
    table.insert(game.saveData.notes, text)
end

function game.toast(text)
    game.note(text)
    game.ui.overlay:addUiElement(uiComponents.widgets.Toast.new(text))
end

function game.warpTo(path, transitionType)
    if path == nil or path == '' then
        error('path cannot be nil or empty')
    end
    local aliasFor = game.warps[path]
    local alias = nil
    if aliasFor ~= nil then
        alias = path
        path = aliasFor
        
        print('Warp to ' .. alias .. " (" .. path .. ")")
    else
        print('Warp to ' .. path)
    end
    
    local scene, x, y, etc = path:match("^%s*(.-),%s*(.-),%s*(.-),%s*(.-)$")
    if scene == nil then
        scene = path
    end

    x = tonumber(x)
    y = tonumber(y)

    local existing = game.stateMgr:findByScene(scene)
    local create = gameStates[scene]
    local previous = game.stateMgr:currentPhysical()

    trycatch(
        function()
            if existing ~= nil then
                game.stateMgr:switchToExisting(existing, previous, x, y, transitionType)
            elseif create ~= nil then
                game.stateMgr:switchToNew(create, previous, scene, x, y, transitionType)
            else
                error ('Invalid gameState ' .. scene)
            end
        end,
        function (ex)
            print('failed to warp to ' .. path)
            print(ex)
        end
    )
end

return game