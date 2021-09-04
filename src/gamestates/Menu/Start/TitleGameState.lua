local super = require "src.gamestates.Menu.MenuGameState"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new()
    local self = setmetatable(lume.extend(super.new('title', 'Title'), {
    }), M)
    self.root.bg = game.images.ui.title
    self.root.direction = 'horizontal'
    self.root.padding.t = 125
    self.root.padding.l = 75
    
    if #game.saves:slotCount() > 0 then
        self.root:addButton('Continue', events.game.ContinueGameEvent.new())
        self.root:addButton('Load', events.WarpEvent.new('loadgame'))
    end
    
    self.root:addImageButton(game.images.ui.start_btn, events.game.NewGameEvent.new())

    self.root:addButton('Options', events.WarpEvent.new('options'))

    if game.config.debug then
        self.root:addButton('Debug', events.WarpEvent.new('debug'))
    end

    self.scene = "Title"

	return self
end

function M:keypressed( key, scancode, isrepeat )
    if not isrepeat then
        if lume.find({'space', 'return'}, key) then
            lume.first(lume.chain(self.root.uielements)
                :filter(function (el) return el.event ~= nil end)
                :result())
                :onClick()
            return
        end
    end
    super.keypressed(self, key, scancode, isrepeat)
end

return M