local super = require "src.gamestates.Menu.MenuGameState"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new()
    local self = setmetatable(lume.extend(super.new('start-new', 'Start New'), {
        bgMusicName = "theme"
    }), M)
    setmetatable(o, self)
    self.__index = self

    return o
end

function M:draw()
    love.graphics.print("Starting a new game on " .. OS .. "!", _renderWidth / 2, _renderHeight / 2)
end

function M:update()
end

function M:load()
end

function M:save()
end

function M:activated()
    game.audio:play(self.bgMusicName)
end


return M