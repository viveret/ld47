local M = {}

function M.load()
    lg.setDefaultFilter('linear', 'linear')

    return lume.extend({
        Overworld = lg.newImage("assets/images/world/Overworld.png")
    }, M)
end

function M.drawObjectFit(img, x, y, r)
    local _renderWidth, _renderHeight = lg.getDimensions()
    local _ratio = _renderWidth / _renderHeight

    local w = img.getWidth(img)
    local h = img.getHeight(img)
    local ratio = w / h

    local scaledw = 0
    local scaledh = 0

    local xmargin = 0
    local ymargin = 0

    if _ratio > ratio then
        scaledw = _renderWidth / w
        scaledh = _renderWidth * h / w
        xmargin = (_renderWidth - w * scaledw) / 2
    else
        scaledw = _renderWidth / w
        scaledh = 1 / ratio
        ymargin = (_renderHeight - h * scaledh) / 2
    end

    lg.draw(img, x + xmargin, y + ymargin, 0, scaledw, scaledh)
end

return M