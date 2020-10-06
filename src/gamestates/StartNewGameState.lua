local M = {}

function M:new(o, gamestate)
    o = o or {
        gamestate = gamestate,
        bgMusicName = "theme"
    }
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
    self.gamestate.audio:play(self.bgMusicName)
end


return M