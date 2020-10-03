local M = {}

function M.draw()
    lg.print("You are in the overworld", 0, 0)

    _renderWidth, _renderHeight = lg.getDimensions()
    if M.gamestate ~= nil then
        lg.draw(M.gamestate.graphics.Overworld, 0, 0, 0,
            _renderWidth / M.gamestate.graphics.Overworld.getWidth(M.gamestate.graphics.Overworld),
            _renderHeight / M.gamestate.graphics.Overworld.getHeight(M.gamestate.graphics.Overworld))
    else
        lg.print("No gamestate", 0, 16)
    end
end

function M.update()
end

function M.load(gamestate)
    M.gamestate = gamestate
end

function M.save()
end


return M