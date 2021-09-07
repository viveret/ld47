local M = {}
M.__index = M
M.__file = __file__()

local GameSaveSlot = require "src.components.system.GameSaveSlot"

-- default location is in user save directory (.local/share/love/ld47/savedata)
-- https://love2d.org/wiki/love.filesystem
function M.new()
    local self = setmetatable({
        currentSlotIndex = 0,
        slotPath = 'savedata/',
    }, M)

	return self
end

function M:currentSlotMostRecentSaveState()
    local currentSlot = self:currentSlot()
    if currentSlot == nil then
        error("Current slot == nil")
    end

    local state = currentSlot:getMostRecentSaveState()
    if state == nil then
    --     error("getMostRecentSaveState() == nil")
    -- else
        state = currentSlot:newSaveState()
        if state == nil then
            error("currentSlot:newSaveState()")
        end
    end

    return state
end

function M:currentSlot()
    local path = self:currentSlotPath()

    if GameSaveSlot.exists(path) then
        return GameSaveSlot.load(path)
    else
        return GameSaveSlot.new("New Game", path, nil, "medium")
    end
end

function M:currentSlotPath()
    return self.slotPath .. self.currentSlotIndex
end

function M:getAll(testData)
    if testData == true then
        return {
            GameSaveSlot.newTest(1),
            GameSaveSlot.newTest(2),
            GameSaveSlot.newTest(3),
        }
    else
        local filesTable = lfs.getDirectoryItems(self.slotPath)
        return lume.chain(filesTable)
                :map(function(x) return self.slotPath .. x end)
                :filter(function(x) return lfs.getInfo(x, "directory") ~= nil end)
                :map(function(x) return { parent = x, items = lfs.getDirectoryItems(x) } end)
                :filter(function(x) return #x.items > 0 end)
                :map(function(x) return x.parent .. "/" .. lume.last(x.items) .. "/game.save" end)
                :filter(function(x) return lfs.getInfo(x, "file") ~= nil end)
                :map(function(x) return GameSaveSlot.load(x) end)
                :result()
    end
end

function M:slotCount()
    return #self:getAll()
end

return M