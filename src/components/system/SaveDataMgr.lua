local M = {}
M.__index = M

function M.new()
    local slots = {}
    local self = setmetatable({
        slots = slots,
        currentSlot = 0,
        elapsedTime = 0,
        saving = false,
    }, M)

	return self
end

function M:update(dt)
    self.elapsedTime = self.elapsedTime + dt
end

function M:clear()
end

function M:clearAll()
end

function M:current()
    if self.currentSlot == 0 then
        return self.slots[self.currentSlot]
    else
        return nil
    end
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

function M:getAll()
    --[[
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
    ]]--
    return {}
end

return M