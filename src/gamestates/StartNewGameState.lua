local M = {}

function M.draw()
    love.graphics.print("Starting a new game on " .. OS .. "!", _renderWidth / 2, _renderHeight / 2)
end

function M.update()
end

function M.load(gamestate)
end

function M.save()
end


return M