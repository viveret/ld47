local M = {}
M.__index = M
M.__file = __file__()

-- https://developer.android.com/guide/components/activities/activity-lifecycle
function M.new(scene)
    if scene == nil or scene == '' then
        error('scene cannot be nil or empty')
    end
    local self = setmetatable({
        scene = scene,
        state = {},
        initialState = {},
	}, M)
    
	return self
end

function M:onCreate()
end

function M:onDestroy()
    self.loaded = false
end

function M:onStart()
end

function M:onStop()
end

function M:onRestart()
end

function M:onLoad()
    local state = game.saves:currentSlotMostRecentSaveState()
    if state then
        local stateEntry = state:getEntry("scene-" .. self.scene)
        if stateEntry then
            self.initialState = stateEntry:load() or {}
            -- print("init state: " .. inspect(self.initialState))
            self.state = copy(self.initialState, {}, true)
        end
    end
    self.loaded = true
end

function M:onSave()
end

function M:onAttach()
end

function M:onDetach()
end

function M:onSwitchTo() -- "resume"
end

function M:onSwitchAway() -- "pause"
end

function M:onKeyPressed( key, scancode, isrepeat )
end

function M:onKeyReleased( key, scancode )
end

function M:onUserInteraction()
end

function M:onLowMemory()
end

function M:isAttached()
    return self:getStackIndex() ~= nil
end

function M:getStackIndex()
    return lume.find(game.stack, self)
end


function M:onTypeReloaded()
    -- self:
end

function M:draw()
end

function M:tick(ticks)
end

function M:update(dt)
end

function M:quicksave(state)
    state:getEntry("scene-" .. self.scene):save(self.state)
end

function M:quickload(state)
    if state then
        self.state = state:getEntry("scene-" .. self.scene):load() or {}
    else
        error("state is nil")
        -- self.state = lume.extend({}, self.initialState)
    end
end

-- function M:reload()
--     self:quickload(self.initialState)
-- end

-- function M:switchTo(x, y)
--     -- local currentSlot = game.saves:currentSlot()
--     -- if currentSlot then
--     --     currentSlot:quicksave(true)
--     -- else
--     --     print("could not save - currentSlot is nil")
--     -- end
--     -- game.saves:save("scene-" .. self.scene, self.state)
--     -- table.push(self.states, lume.extend({}, self.state))

--     local state = game.saves:currentSlotMostRecentSaveState()
--     if state then
--         self:quickload(state)
--     end
-- end

-- function M:switchAway()
--     game.quicksave()
-- end

-- function M:activated()
-- end

return M