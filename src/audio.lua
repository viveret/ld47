local M = {}

function M.load()
    return {
        mirror = love.audio.newSource( "assets/audio/mirror.mp3", 'static' )
    }
end


return M