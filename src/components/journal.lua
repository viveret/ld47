local M = {}
M.__index = M

function M.new(gamestate)
    local self = setmetatable({
        gamestate = gamestate,
        scroll = 0.5,
        scrollVel = 0,
        scrollAccel = 0,
        pageSize = 2,
        itemWidth = 420,
        itemHeight = 28 * 3,
        itemPad = 8,
        itemGap = 8,
        iconSize = 32,
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
    }, M)

    -- for _,flag in pairs(self.items) do
    --     flag.has = gamestate.hasFlag(flag.flag)
    -- end

	return self
end

function M:draw()
    lg.push()
    lg.translate(-self.itemWidth / 4, 0)
    lg.setColor(1, 1, 1)
    --lg.rectangle('line', 0, 0, self.itemWidth, (self.itemHeight + self.itemGap) * self.pageSize)
    
    local scrolli, scrollf = modf(self.scroll)

    lg.translate(0, (-scrollf) * (self.itemHeight + self.itemGap))
    for i,v in pairs(self.items) do
        if i >= self.scroll and i <= self.scroll + self.pageSize + 1 then
            self:drawItem(v)
            lg.translate(0, self.itemHeight + self.itemGap)
        end
    end
    lg.setColor(1, 1, 1)
    lg.pop()
end

function M:drawItem(el)
    local icon = nil
    if el.has then
        icon = self.gamestate.images.ui.success
    else
        icon = self.gamestate.images.ui.failure
    end
    
    self.gamestate.graphics:drawObject(icon, 0, self.itemHeight / 2 - self.iconSize / 2, self.iconSize, self.iconSize)
	self.gamestate.graphics:renderTextInBox(el.text, self.itemPad + self.iconSize, self.itemPad, self.itemWidth - (self.itemPad + self.iconSize) * 2, self.itemHeight - self.itemPad * 2, self.gamestate.images.ui.dialog_font)
end

function M:update(dt)
    local scrollMax = #self.items - self.pageSize + .5
    self.scrollVel = self.scrollVel + self.scrollAccel * dt
    self.scroll = min(max(self.scroll + self.scrollVel * dt, 0.5), scrollMax)
    if self.scroll == 0.5 and self.scrollVel < 0 then
        self.scrollVel = 0
    elseif self.scroll == scrollMax and self.scrollVel > 0 then
        self.scrollVel = 0
    else
        self.scrollVel = self.scrollVel - self.scrollVel * dt
    end
end

function M:reset()
    
end

return M