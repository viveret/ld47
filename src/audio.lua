local M = {}

function M.load()
    return {
    	-- small tracks
        mirror = love.audio.newSource( "assets/audio/mirror.mp3", 'static' ),

        -- long tracks
        overworld = love.audio.newSource( "assets/audio/overworld.mp3", 'stream' ),
        other = love.audio.newSource( "assets/audio/other.mp3", 'stream' )
    }
end


return M