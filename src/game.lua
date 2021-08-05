local audio = require "src.audio"
local graphics = require "src.graphics"
local images = require "src.images"
local animations = require "src.animations"
local SaveDataMgr = require "src.components.system.SaveDataMgr"

game = {
    stack = {},
    stackTransition = nil,

    stackTransitions = {
        Regular = require "src.gamestates.Transitions.GameStateTransition",
        DialogIn = require "src.gamestates.Transitions.DialogStateTransitionIn",
        DialogOut = require "src.gamestates.Transitions.DialogStateTransitionOut",
        FadeInOut = require "src.gamestates.Transitions.FadeInOutStateTransition",
        ToRight = require "src.gamestates.Transitions.ToRightStateTransition",
        ToLeft = require "src.gamestates.Transitions.ToLeftStateTransition",
        ToUp = require "src.gamestates.Transitions.ToUpStateTransition",
        ToDown = require "src.gamestates.Transitions.ToDownStateTransition",
    },

    timeline = {},
    flags = {},
    fracSec = 0,
    timeWarp = 1,
    timeWarpMin = 1,
    timeWarpMax = 1000,
    timeWarpStep = 2,
    objectScale = 1/8,
    existingStates = { },
    backgroundMusic = { },
    events = {},
    options = {
        language = 'en',
        textSpeed = 15, -- chars per second
    },
    debug = {
        keys = true,
    },
    initial = {
        time = DateTime.new("1/1/2000 8:00:0-0"),
        flags = {
            "NotDoneJob",
            "NotServedcustomerOne",
            "NotServedcustomerTwo",
            "NotServedcustomerThree",
            "NotServedcustomerFour",
            "has-not-reserved-room",
            "NotSeenSickCultist",
            "SawCemeteryCultist",
            "NotSeenCemeteryCultist",
        }
    },
    warps = {
        title = 'Title,0,0,x',
        options = 'Options,0,0,x',
        loadgame = 'LoadGame,0,0,x',
        start = 'Home,60,30,x',
        gameover = 'GameOver,0,0,x',
        pause = 'Pause,0,0,x',
        notes = 'Notes,0,0,x',
        inventory = 'Inventory,0,0,x',
    },
    keyBinds = {
        moveLeft = 'a',
        moveRight = 'd',
        moveUp = 'w',
        moveDown = 's',
        run = 'lshift',
        interact = 'space',
        pause = 'p',
        inventory = 'i',
        notes = 'n',
        use = 'enter',
        quickload = 'r',
        quicksave = 't',
    },
    paths = {
        timeline = "assets/timeline/timeline.csv"
    },
    ui = {
        overlay = uiComponents.GameOverlay.new(),
        clock = uiComponents.Clock.new(),
        interactionTray = uiComponents.InGame.InteractionTray.new(),
    },
    saves = SaveDataMgr.new(),
}

_empty = {
    draw = donothing,
    update = donothing,
    load = donothing,
    keypressed = donothing,
    keyreleased = donothing,
}

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

function game.load(autosave)
    self.saves:load(autosave)
end
function game.save(autosave)
    self.saves:save(autosave)
end

function game.keypressed( key, scancode, isrepeat )
    if not game.isTransitioning() then
        debugtrycatch(game.debug.keys, function()
            game.current():keypressed( key, scancode, isrepeat )
        end)
    end
end

function game.keyreleased( key, scancode )
    if not game.isTransitioning() then
        debugtrycatch(game.debug.keys, function()
            game.current():keyreleased( key, scancode )
        end)
    end
end

function game.clear()
    game.time = game.initial.time
    game.flags = {}
    game.stack = {}
    game.saves:clear()
end

function game.getWidth()
    return game.current():getWidth()
end

function game.getHeight()
    return game.current():getHeight()
end

function game.current()
    if lume.count(game.stack) > 0 then
        return lume.last(game.stack)
    else
        return _empty
    end
end

function game.isTransitioning()
    return game.stackTransition ~= nil
end

-- transition to a different game here
function game.switchTo(toGamestate, transitionType)
    if toGamestate == nil then
        error('toGamestate must not be nil')
    end

    for ix, state in ipairs(game.stack) do
        if state == toGamestate then
            table.remove(game.stack, ix)
            break
        end
    end

    game.push(toGamestate, nil, transitionType)
end

-- push a NEW game here
function game.push(newGamestate, deactive, transitionType)
    if transitionType == nil then
        if newGamestate ~= nil then
            -- print("pushing "..newGamestate.scene)
            table.insert(game.stack, newGamestate)
        else
            error('newGamestate must not be nil')
        end
    
        if deactive ~= true then
            newGamestate:activated()
        end
        game.markTopmost(newGamestate)
    else
        game.stackTransition = transitionType.new('push', game.current(), newGamestate)
    end
end

function game.markTopmost(toGamestate)
    for _, state in ipairs(game.stack) do
        state.topmost = toGamestate == state
    end
end

function game.pop(transitionType)
    if transitionType == nil then
        table.remove(game.stack)

        local current = game:current()
        if current ~= nil then
            game.markTopmost(current)
            current:activated()
        end
    else
        local previous = game.stack[#game.stack]
        local next = game.stack[#game.stack - 1]
        game.stackTransition = transitionType.new('pop', previous, next)
    end
end

function game.replace(newGamestate)
    if newGamestate ~= nil then
        game.pop()
        game.push(newGamestate)
    else
        error('newGamestate must not be nil')
    end
end

function game.draw()
    if game.isTransitioning() then
        game.stackTransition:draw()
    else
        for i,s in ipairs(game.stack) do
            if i < #game.stack and game.stack[i + 1].isTransparent then
                s:draw()
            end
        end
        game.current():draw()
    end
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
    -- handle any fadeouts that are in progress
    game.audio:update(dt)
    game.saves:update(dt)

    if #game.events > 0 then
        local tmp = game.events
        game.events = {}
        for k, ev in pairs(tmp) do
            ev:fireOn(game)
        end
    end

    if game.isTransitioning() then
        game.stackTransition:update(dt)
    else
        local currentGameState = game.current()
        currentGameState:update(dt)
    
        -- pump everything if time is passing
        if currentGameState.isPhysicalGameState then
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

    -- load timeline
    game.timeline = timeline.new()

    -- spin up the TimedGameStates
    -- for key, creator in pairs(game.timedGameStateCreators) do
    --     local state = creator.new()
    --     state:load()
    --     game.existingStates[key] = state
    --     game.push(state, true)
    -- end

    for _, flag in pairs(game.initial.flags) do
        game.setFlag(flag)
    end

    game.warpTo('title', game.stackTransitions.FadeIn)
end

function game.reload()
    local current = game:current()
    if current ~= nil then
        current:reload()
    end
end

function game.quickload()
    if game.saveSlot ~= nil then
        local current = game:current()
        if current ~= nil then
            current:quickload()
        end
    end
end

function game.quicksave()
    if game.saveSlot ~= nil then
        local current = game:current()
        if current ~= nil then
            current:quicksave()
        end
    end
end

function game.setFlag(flag)
    print("setFlag("..flag..")")

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

function game.fire(ev, queue)
    if queue then
        table.insert(game.events, ev)
    else
        return ev:fireOn(game)
    end
end

function game.note(text)
    game.saveData.notes = game.saveData.notes or {}
    table.insert(game.saveData.notes, text)
end

function game.toast(text)
    game.note(text)
    game.ui.overlay:addUiElement(uiComponents.Toast.new(text))
end

function game.switchToExisting(existing, x, y, transitionType)
    existing:switchTo(x, y)
    game.switchTo(existing, transitionType)
end

function game.switchToNew(create, scene, x, y, transitionType)
    local newState = create.new(game)
    newState.type = scene
    newState:load(x, y)
    game.push(newState, nil, transitionType)
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
    x = tonumber(x)
    y = tonumber(y)

    local existing = game.existingStates[scene]
    local create = gameStates[scene]
    local switchToResult = false
    local err = false

    trycatch(
        function()
            if existing ~= nil then
                game.switchToExisting(existing, x, y, transitionType)
            elseif create ~= nil then
                game.switchToNew(create, scene, x, y, transitionType)
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