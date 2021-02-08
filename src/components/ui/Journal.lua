local super = require "src.components.ui.Scrollable"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new()
    local self = setmetatable(lume.extend(super.new('journal'), {
        items = {
            {
                flag = "DoneJob",
                text = "You served coffee. You're a good 'lil worker!"
            },
            {
                flag = "CoffeeCultistSpoken",
                text = "Your last cup of coffee was served to a weirdo muttering about the end of the world."
            },
            {
                flag = "has-not-reserved-room",
                text = "You should check into a motel room."
            },
            {
                flag = "has-reserved-room",
                text = "You reserved a motel room, keeping a cultist away."
            },
            {
                flag = "SawSickCultist",
                text = "You witnessed a cultist's demise."
            },
            {
                flag = "NotSeenSickCultist",
                text = "You should drop by the motel room."
            },
            {
                flag = "SawCemeteryCultist",
                text = "How much do they cost?",
            },
            {
                flag = "NotSeenCemeteryCultist",
                text = "You should visit the cemetery",
            }
        }
    }), M)

    -- for _,flag in pairs(self.items) do
    --     flag.has = game.hasFlag(flag.flag)
    -- end

	return self
end

function M:drawItem(el)
    local icon = nil
    if el.has then
        icon = game.images.ui.success
    else
        icon = game.images.ui.failure
    end
    
    game.graphics:drawObject(icon, 0, self.itemHeight / 2 - self.iconSize / 2, self.iconSize, self.iconSize)
	game.graphics:drawTextInBox(el.text, self.itemPad + self.iconSize, self.itemPad, self.itemWidth - (self.itemPad + self.iconSize) * 2, self.itemHeight - self.itemPad * 2, game.images.ui.dialog_font)
end

return M