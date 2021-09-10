local M = {}
M.__index = M
M.__file = __file__()

gamestateTransitions = recursiveRequire("src.gamestates.Transitions", { suffixToRemove = "StateTransition" })

function M.new()
    local self = setmetatable({
        stack = {},
        stackTransition = nil,
	}, M)
	return self
end

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

function M:onKeyPressed( key, scancode, isrepeat )
    if not self:isTransitioning() then
        debugtrycatch(game.debug.keys, function()
            self:current():onKeyPressed( key, scancode, isrepeat )
        end)
    end
end

function M:onKeyReleased( key, scancode )
    if not self:isTransitioning() then
        debugtrycatch(game.debug.keys, function()
            self:current():onKeyReleased( key, scancode )
        end)
    end
end

function M:clear()
    self.stack = {}
end

function M:findByScene(scene)
    if lume.count(self.stack) > 0 then
        if scene and scene ~= '' then
            return lume.last(lume.filter(self.stack,
                function(gs)
                    return gs.scene == scene
                end
            ))
        else
            error('scene not a string (was nil or empty)')
        end
    else
        return nil
    end
end

function M:current(filter)
    if lume.count(self.stack) > 0 then
        if filter then
            return lume.last(lume.filter(self.stack, filter))
        else
            return lume.last(self.stack)
        end
    else
        return nil
    end
end

function M:currentPhysical(filter)
    return self:current(
        function(state)
            return state.isPhysicalGameState
        end
    )
end

function M:currentMenu(filter)
    return self:current(
        function(state)
            return state.isMenuGameState
        end
    )
end

function M:isTransitioning()
    return self.stackTransition ~= nil
end

-- transition to a different game here
function M:switchTo(toGamestate, transitionType)
    if toGamestate == nil then
        error('toGamestate must not be nil')
    end

    for ix, state in ipairs(self.stack) do
        if state == toGamestate then
            table.remove(self.stack, ix)
            break
        end
    end

    self:push(toGamestate, transitionType)
end

function M:switchToExisting(existing, previous, transitionType, args)
    if previous then
        previous:onSwitchAway()
    end
    existing:onSwitchTo(args)
    self:switchTo(existing, transitionType)
end

function M:switchToNew(create, previous, transitionType, args)
    if previous then
        -- print("switching away from " .. previous.__file)
        previous:onSwitchAway()
    end
    
    local newState = create.new()

    newState:onCreate(args)

    self:push(newState, transitionType)
end

-- push a NEW game here
function M:push(newGamestate, transitionType)
    if newGamestate.loaded ~= true then
        newGamestate:onLoad()
    end

    if transitionType == nil then
        if newGamestate ~= nil then
            -- print("pushing "..newGamestate.scene)
            table.insert(self.stack, newGamestate)
            newGamestate:onAttach()
            newGamestate:onSwitchTo()
        else
            error('newGamestate must not be nil')
        end
    else
        self.stackTransition = transitionType.new('push', self:current(), newGamestate)
    end
end

function M:remove(indexStart, indexEnd, transitionType)
    if indexEnd < indexStart then
        error("indexEnd < indexStart (" .. indexEnd .. " < " .. indexStart .. ")")
    end

    if transitionType == nil then
        local old = self:current()

        if indexStart == indexEnd then
            self.stack[indexStart]:onDetach()
            table.remove(self.stack, indexStart)
        else
            local tmp = {}
            for i = 1, #self.stack do
                if indexStart < i or i > indexEnd then
                    table.insert(tmp, self.stack[i])
                else
                    self.stack[i]:onDetach()
                end
            end
            self.stack = tmp
        end

        local current = self:current()

        if current ~= old then
            if current ~= nil then
                if current.loaded ~= true then
                    current:onLoad()
                end
                current:onSwitchTo()
            end
        end
    else
        if 0 >= indexStart then
            error("indexStart too small (is " .. indexStart .. ")")
        end

        if #self.stack < indexEnd then
            error("indexEnd too big (is " .. indexEnd .. ", #stack = " .. #self.stack .. ")")
        end

        local previous = self.stack[indexStart]
        local next = self.stack[indexEnd]
        local transitionOp = 'remove'
        
        if indexStart == indexEnd then
            next = self.stack[indexStart - 1]
            transitionOp = 'pop'
        end

        self.stackTransition = transitionType.new(transitionOp, previous, next)
    end
end

function M:popTop(transitionType)
    self:remove(#self.stack, #self.stack, transitionType)
end

function M:popToInclusive(marker, transitionType)
    self:remove(self:find(marker), #self.stack, transitionType)
end

function M:popToExclusive(marker, transitionType)
    self:remove(self:find(marker) - 1, #self.stack, transitionType)
end

function M:replace(newGamestate)
    if newGamestate ~= nil then
        print('todo: fix this to not call extra functions')
        self:popTop()
        self:push(newGamestate)
    else
        error('newGamestate must not be nil')
    end
end

function M:draw()
    if self:isTransitioning() then
        self.stackTransition:draw()
    else
        for i,s in ipairs(self.stack) do
            if i < #self.stack and self.stack[i + 1].isTransparent then
                s:draw()
            end
        end
        local currentGameState = self:current()
        if currentGameState then
            currentGameState:draw()
        else
            print("No current gamestate")
        end
    end
end

function M:update(dt)
    if self:isTransitioning() then
        self.stackTransition:update(dt)
    else
        local currentGameState = self:current()
        if currentGameState then
            -- print('current game state: ' .. inspect(currentGameState.__index.__file))
            currentGameState:update(dt)
        else
            print("No current gamestate")
        end
    end
end

function M:reload()
    local current = self:current()
    if current ~= nil then
        current:reload()
    end
end

function M:quickload(state)
    local current = self:current()
    if current ~= nil then
        current:quickload(state)
    end
end

function M:quicksave(state)
    local current = self:current()
    if current ~= nil then
        current:quicksave(state)
    end
end

function M:onTransitionFinished(transition)
    if transition ~= self.stackTransition then
        error("Different transition finished than current one")
    end

    self.stackTransition = nil
    
    if transition.pushOrPop == 'pop' then
        self:popTop()
    elseif transition.pushOrPop == 'remove' then
        local indexStart = lume.find(self.stack, transition.futureState)
        local indexEnd = lume.find(self.stack, transition.previousState)

        self:remove(indexStart, indexEnd)
    elseif transition.futureState ~= nil then
        self:push(transition.futureState)
    else
        error("no handler for finishing transition")
    end
end

return M