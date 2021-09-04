local M = {}
M.__index = M

function M.new(id, icon, title, description, primaryUseInfo, secondaryUseInfo)
    local self = setmetatable({
        id = id or error('missing id'),
        icon = icon or error('missing icon'),
        title = title or error('missing title'),
        description = description or error('missing description'),
        primaryUseInfo = primaryUseInfo,
        secondaryUseInfo = secondaryUseInfo,
        sidePad = 8,
        sideWidth = 220,
	}, M)
	return self
end

function M:drawWorld(item)
    lg.setColor(1, 0, 1)
    lg.rectangle(0, 0, 16, 16)
    lg.setColor(1, 1, 1)
end

function M:drawUI(count)
    local itemW = 100
    local itemH = 100
    --lg.draw(self.icon)
    if count == 0 then
        lg.setColor(0.2, 0.2, 0.2)
    else
        lg.setColor(1, 1, 1)
    end
    
    lg.setColor(1, 1, 1)
    game.graphics:drawTextInBox('' .. count, itemW / 3, itemH / 3, itemW, itemH, game.images.ui.dialog_font, nil, true)
end

function M:drawUISideInfo()
    game.graphics:drawTextInBox(self.title, 0, 0, self.sideWidth - self.sidePad * 2, 32, game.images.ui.dialog_font, nil, false)
    lg.translate(0, 32)
    game.graphics:drawTextInBox(self.description, 0, 0, self.sideWidth - self.sidePad * 2, 32, game.images.ui.dialog_font, nil, false)
    -- for i,kb in pairs(self.keyBinds) do
    --     lg.translate(0, 34)
    --     local str = i .. ' [' .. (game.config.keyBinds[i] or 'unbound') .. '] - ' .. kb.title
    --     game.graphics:drawTextInBox(str, 0, 0, self.sideWidth - self.sidePad * 2, 32, game.images.ui.dialog_font, nil, false)
    -- end
end

function M:use()
    print('used')
end

function M:useAlt()
    print('used alt')
end

return M