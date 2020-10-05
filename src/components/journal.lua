local M = {}
M.__index = M

function M.new(gamestate)
    local self = setmetatable({
        gamestate = gamestate,
        scroll = 0,
        scrollVel = 0,
        scrollAccel = 0,
        pageSize = 10,
        itemWidth = 420,
        itemHeight = 60,
        itemPad = 8,
        itemGap = 8,
        items = {
            {
                flag = "ServedAllCustomers",
                text = "You served coffee. You're a good 'lil worker!"
            },
            {
                flag = "has-not-reserved-room",
                text = "You should check out a motel room"
            },
            {
                flag = "has-reserved-room",
                text = "You reserved a motel room, keeping a cultist away"
            }
        }
    }, M)

    for _,flag in pairs(self.items) do
        flag.has = gamestate.hasFlag(flag.flag)
    end

	return self
end

function M:draw()
    lg.push()
    lg.translate(-self.itemWidth / 4, 0)
    lg.setColor(0, 1, 1)
    lg.rectangle('line', 0, 0, self.itemWidth, (self.itemHeight + self.itemGap) * self.pageSize)
    for _,v in pairs(lume.slice(self.items, floor(self.scroll), self.pageSize + 1)) do
        self:drawItem(v)
        lg.translate(0, self.itemHeight + self.itemGap)
    end
    lg.setColor(1, 1, 1)
    lg.pop()
end

function M:drawItem(el)
    if el.has then
        lg.setColor(0, 1, 0)
    else
        lg.setColor(1, 0, 0)
    end
    lg.rectangle('line', 0, 0, self.itemWidth, self.itemHeight)
    lg.setColor(1, 1, 1)
	self.gamestate.graphics:renderTextInBox(el.text, self.itemPad, self.itemPad, self.itemWidth - self.itemPad * 2, self.itemHeight - self.itemPad * 2, self.gamestate.images.ui.dialog_font)
end

function M:update(dt)
    self.scrollAccel = self.scrollAccel - self.scrollAccel * 0.9 * dt
    self.scrollVel = self.scrollVel + self.scrollAccel * dt
    self.scroll = min(max(self.scroll + self.scrollVel * dt, 0), #self.items - self.pageSize)
end

function M:reset()
    
end

return M