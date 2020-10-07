local M = setmetatable({}, { __index = MenuGameState })
M.__index = M

local journal = require "src.components.journal"

function M.new(gamestate)
    local self = setmetatable(MenuGameState.new(gamestate, 'Pause'), M)

    self:addButton('Continue', ContinueGameEvent.new())
    self:addButton('Quit', QuitGameEvent.new())

    self:addSpace(110)

    self.journal = journal.new(gamestate)
    self:addUiElement(self.journal)

	return self
end

function M:update(dt)
    self.journal:update(dt)
    MenuGameState.update(self, dt)
end

function M:keypressed( key, scancode, isrepeat )
    if not isrepeat then
        if key == 'w' then
            self.journal.scrollAccel = -1
        elseif key == 's' then
            self.journal.scrollAccel = 1
        end

        if lume.find({'p', 'escape'}, key) then
            self.gamestate.fire(ContinueGameEvent.new(), true)
            return
        elseif key == 'q' then
            self.gamestate.fire(QuitGameEvent.new(), true)
            return
        end
    end
    MenuGameState.keypressed(self, key, scancode, isrepeat)
end

function M:keyreleased( key, scancode )
    if key == 'w' or key == 's' then
        self.journal.scrollAccel = 0
    end
    MenuGameState.keyreleased(self, key, scancode)
end

return M