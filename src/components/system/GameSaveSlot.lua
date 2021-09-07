local M = {}
M.__index = M
M.__file = __file__()

local GameSaveState = require "src.components.system.GameSaveState"

function M.new(nameOrState, path, lastSaveDate, difficulty)
    if type(nameOrState) == "table" then
        return setmetatable(lume.extend({}, nameOrState), M)
    else
        local self = setmetatable({
            name = nameOrState,
            path = path,
            lastSaveDate = lastSaveDate,
            difficulty = difficulty,
            currentSaveIndex = 0,
        }, M)
        return self
    end
end

function M.exists(path)
    if lfs.getInfo(path, "directory") ~= nil then
        local slotPath = path .. '/slot.save'
        if lfs.getInfo(path, "file") ~= nil then
            return true
        end
    end
    return false
end

function M.load(path)
    if lfs.getInfo(path, "directory") ~= nil then
        local slotPath = path .. '/slot.save'
        if lfs.getInfo(path, "file") ~= nil then
            local args = binser.readFile(slotPath)
            args.path = path
            return M.new(args)
        else
            error("Slot path " .. slotPath .. " does not exist")
        end
    else
        error("Slot path " .. path .. " is not a directory")
    end
end

function M:getMostRecentSaveState(testData)
    return lume.last(self:getAllStates(testData))
end

function M:newSaveState()
    self.currentSaveIndex = self.currentSaveIndex + 1
    return GameSaveState.new(self.path .. "/" .. self.currentSaveIndex, self.currentSaveIndex)
end

function M:getSaveState()
    return copy(self)
end

function M:getAllStates(testData)
    if testData == true then
        return {
            --GameSaveState.new("Run 1", "1/1/2020 at 1:11 pm", "medium"),
            --GameSaveState.new("Run 2", "1/1/2020 at 1:11 pm", "medium"),
        }
    else
        local filesTable = lfs.getDirectoryItems(self.path)
        return lume.chain(filesTable)
                :map(function(x) return self.path .. "/" .. x end)
                :filter(function(x) return lfs.getInfo(x, "directory") ~= nil end)
                :map(function(x) return { parent = x, items = lfs.getDirectoryItems(x) } end)
                :filter(function(x) return #x.items > 0 end)
                :map(function(x) return x.parent .. "/" .. lume.last(x.items) end)
                :filter(function(x) return lfs.getInfo(x, "directory") ~= nil end)
                :map(function(x) return GameSaveState.new(x.path, x.id) end)
                :result()
    end
end

return M