local M = {}
M.__index = M

function M.new(id, assets)
    local self = setmetatable({
        id = id,
        items = {},
        itemOrder = {},
        itemWidth = 4,
        itemHeight = 3,
        itemGap = 8,
        itemSize = 100,
        sideWidth = 220,
        sidePad = 8,
        assets = assets or game.images.inventories[id],
        selectedIndex = 1,
	}, M)
	return self
end

function M:refreshOrder()
    local tmp = {}
    for k in pairs(self.items) do
        table.insert(tmp, k)
    end
    table.sort(tmp)

    self.itemOrder = tmp
end

function M:addItem(item)
    self.items[item] = (self.items[item] or 0) + 1
    self:refreshOrder()
end

function M:removeItem(item)
    self.items[item] = nil
    table.remove(self.items, item)
end

function M:drawWorld(item)
    for k,it in pairs(self.items) do
        it:drawWorld()
    end
end

function M:quicksave()
    game.saveData.inventories = game.saveData.inventories or {}
    game.saveData.inventories[self.id] = lume.extend({}, self.items)
end

function M:quickload()
    game.saveData.inventories = game.saveData.inventories or {}
    self.items = lume.extend({}, game.saveData.inventories[self.id])
end

function M:selectLeft()
    if self.selectedIndex ~= 1 then
        self.selectedIndex = self.selectedIndex - 1
    end
end

function M:selectRight()
    if self.selectedIndex ~= self.itemWidth * self.itemHeight then
        self.selectedIndex = self.selectedIndex + 1
    end
end

function M:selectUp()
    if self.selectedIndex > self.itemWidth then
        self.selectedIndex = self.selectedIndex - self.itemWidth
    end
end

function M:selectDown()
    if self.selectedIndex < self.itemWidth * (self.itemHeight - 1) then
        self.selectedIndex = self.selectedIndex + self.itemWidth
    end
end

function M:activateSelected()
    if self.activatedIndex == nil then
        self.activatedIndex = self.selectedIndex
        print('Activated ' .. self:selectedItem())
    else
        print('Using ' .. self:activatedItem() .. ' on ' .. self:selectedItem())
        self:activatedItemOn(self.activatedIndex, self.selectedIndex)
        self.activatedIndex = nil
    end
end

function M:selectedItem()
    return self.itemOrder[self.selectedIndex]
end

function M:activatedItem()
    if self.activatedIndex ~= nil then
        return self.itemOrder[self.activatedIndex]
    else
        return nil
    end
end

function M:activatedItemOn(activatedIndex, selectedIndex)
    game.items[self:activatedItem()].useWith(game.items[self:selectedItem()])
end

return M