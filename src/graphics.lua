local M = {}

function M.load()
    lg.setDefaultFilter('linear', 'linear')

    return lume.extend({
        Overworld = lg.newImage("assets/images/world/Overworld.png"),
        Player = lg.newImage("assets/images/people/protag.png"),
        Dialog = lg.newImage("/assets/images/screen/dialog-box.png")
    }, M)
end

function M.drawObject(img, x, y, w, h)
    local iw, ih = img:getDimensions()
    lg.draw(img, x, y, 0, w / iw, h / ih)
end

return M