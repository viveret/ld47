local M = {}
M.__index = M
M.__file = __file__()

function M.new()
    local self = setmetatable({
        currentSlot = 0,
        saving = false,
        slotPath = 'savedata/',
        elapsedTime = 0
    }, M)

	return self
end

function M:update(dt)
end

function M:clear()
end

function M:clearAll()
end

function M:current()
    if self.currentSlot > 0 then
        return binser.readFile(self:currentSlotPath())
    else
        return nil
    end
end

function M:slotCount()
    return lfs.getDirectoryItems(self.slotPath)
end

function M:currentSlotPath()
    return self.slotPath .. self.currentSlot .. '/save.lua'
end

function M:load(autosave)
    --local encoded = kuey.encode(lume.serialize(self.saveData), game.getSaveKey()) // https://github.com/bakpakin/binser
    --local encoded = kuey.encode(binser.serialize(self.saveData), game.getSaveKey())
    --self.saveData = lume.deserialize(kuey.decode(loadData, game.getSaveKey()))
    --self.saveData = binser.deserialize(kuey.decode(loadData, game.getSaveKey()))
end

function M:save()
    --local encoded = kuey.encode(lume.serialize(self.saveData), game.getSaveKey()) // https://github.com/bakpakin/binser
    --local encoded = kuey.encode(binser.serialize(self.saveData), game.getSaveKey())
    --self.saveData = lume.deserialize(kuey.decode(loadData, game.getSaveKey()))
    --self.saveData = binser.deserialize(kuey.decode(loadData, game.getSaveKey()))
end

function M:quicksave(autosave)
    self.saving = true
    self.saving = false
    if autosave then
    else
    end
end

function M:quickload()
end

function M:getAll(testData)
    if testData == true then
        return {
            {
                name = 'Run 1',
                lastSaveDate = '1/1/2020 at 1:11 pm',
                difficulty = 'medium',
            },
            {
                name = 'Run 2',
                lastSaveDate = '1/1/2020 at 1:11 pm',
                difficulty = 'medium',
            }
        }
    else
        local filesTable = lfs.getDirectoryItems(self.slotPath)
        return lume.chain(filesTable)
                :map(function(x) return self.slotPath .. x end)
                :filter(function(x) return lfs.isDirectory(x) end)
                :map(function(x) return x .. "save.json" end)
                :filter(function(x) return lfs.isFile(x) end)
                :map(function(x) return binser.read(x) end)
                :result()
    end
end

return M