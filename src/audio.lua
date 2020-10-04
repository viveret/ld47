local M = {}

function M.load()
    return {
    	-- small tracks
        mirror = love.audio.newSource( "assets/audio/mirror.mp3", 'static' ),
        doorbell = love.audio.newSource("assets/audio/doorbell.mp3", "static"),

        -- long tracks
        theme = love.audio.newSource( "assets/audio/theme.ogg", 'stream' ),
        chill = love.audio.newSource( "assets/audio/chill-bg.ogg", 'stream' ),
        day2 = love.audio.newSource( "assets/audio/day2-bg.ogg", 'stream' ),
        dreamSequence = love.audio.newSource( "assets/audio/dream-sequence-bg.ogg", 'stream' ),
        nightSpooky = love.audio.newSource( "assets/audio/night-spooky-bg.ogg", 'stream' ),
    }
end


return M