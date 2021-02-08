local super = require "src.components.ui.Scrollable"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new(items)
    local self = setmetatable(lume.extend(super.new('saveslots'), {
        items = items
    }), M)

	return self
end

function M:drawItem(el)
    --print(el.)
    local str = el.name .. ' (' .. el.difficulty .. ') - ' .. el.lastSaveDate
    game.graphics:drawTextInBox(str, self.itemPad + self.iconSize, self.itemPad, self.itemWidth - (self.itemPad + self.iconSize) * 2, self.itemHeight - self.itemPad * 2, game.images.ui.dialog_font)
    -- LoadSaveEvent.new(e)
end

return M