local M = {}

function M.load()
    lg.setDefaultFilter('linear', 'linear')

    return lume.extend({
        Overworld = lg.newImage("assets/images/world/Overworld.png")
    }, M)
end

function M.drawObject(img, x, y)
    lg.draw(img, x, y)
end

return M