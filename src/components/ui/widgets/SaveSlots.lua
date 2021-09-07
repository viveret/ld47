local super = require "src.components.ui.navs.Scrollable"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new(items)
    local self = setmetatable(lume.extend(super.new('saveslots'), {
        items = items
    }), M)

	return self
end

function M:drawItem(el)
    local str = el.name .. ' (' .. el.difficulty .. ') - ' .. el.lastSaveDate
    game.graphics:drawTextInBox(str, self.itemPad + self.iconSize, self.itemPad, self.itemWidth - (self.itemPad + self.iconSize) * 2, self.itemHeight - self.itemPad * 2, game.images.ui.dialog_font)
end

return M