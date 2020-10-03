local M = {}

function M.load()
    lg.setDefaultFilter('linear', 'linear')

    return {
        Overworld = lg.newImage("assets/images/world/Overworld.png")
    }
end

return M