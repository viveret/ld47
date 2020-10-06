local M = {}
M.__index = M

function M.new()
    return setmetatable({
        -- long tracks
        tracks = {
            theme = love.audio.newSource( "assets/audio/theme.ogg", 'stream' ),
            chill = love.audio.newSource( "assets/audio/chill-bg.ogg", 'stream' ),
            day2 = love.audio.newSource( "assets/audio/day2-bg.ogg", 'stream' ),
            dreamSequence = love.audio.newSource( "assets/audio/dream-sequence-bg.ogg", 'stream' ),
            nightSpooky = love.audio.newSource( "assets/audio/night-spooky-bg.ogg", 'stream' ),
        },
        playing = {},
        fadingIn = {},
        fadingOut = {},
        queued = {},
        fadeDurationSeconds = 0.8,
    }, M)
end

function M:play(name)
    local isPlaying = lume.find(self.playing, name) ~= nil
    local isQueued = lume.find(self.queued, name) ~= nil
    local isFadingIn = lume.find(self.fadingIn, name) ~= nil
    local isPlayingOrQueued = isPlaying or isQueued or isFadingIn
    if isPlayingOrQueued then
        return
    end

    --print("Queued " .. name)
    self:fadeAllOut()

    if lume.find(self.fadingOut, name) then
        lume.remove(self.fadingOut, name)
    end
    table.insert(self.queued, name)
end

function M:removeFrom(list, toRemove)
    for _,src in pairs(toRemove) do
        lume.remove(list, src)
    end
end

function M:update(dt)
    local queued = #self.queued
    local fadingIn = #self.fadingIn
    local fadingOut = #self.fadingOut
    local active = queued + fadingIn + fadingOut
    if active == 0 then
        return
    end

    if fadingIn > 0 then
        local doneFadingIn = {}
        for _,name in pairs(self.fadingIn) do
            local src = self.tracks[name]
            local vol = src:getVolume()
            if vol < 1 then
                src:setVolume(vol + dt / self.fadeDurationSeconds)
            else
                --print("Done fading in " .. name)
                src:setVolume(1)
                table.insert(self.playing, name)
                table.insert(doneFadingIn, name)
            end
        end
        self:removeFrom(self.fadingIn, doneFadingIn)
    end

    if queued > 0 then
        local tmp = self.queued
        self.queued = {}
        for _,name in pairs(tmp) do
            --print("Fading in " .. name)
            local src = self.tracks[name]
            src:setVolume(0)
            src:setLooping(true)
            src:play()
            table.insert(self.fadingIn, name)
        end
    end

    if fadingOut > 0 then
        local doneFadingOut = {}
        for _,name in pairs(self.fadingOut) do
            local src = self.tracks[name]
            local vol = src:getVolume()
            if vol > 0 then
                src:setVolume(vol - dt / self.fadeDurationSeconds)
            else
                --print("Done fading out " .. name)
                src:setVolume(0)
                src:stop()
                
                table.insert(doneFadingOut, name)
            end
        end
        self:removeFrom(self.fadingOut, doneFadingOut)
    end
end

function M:fadeAllOut()
    local playing = lume.concat(self.playing, self.fadingIn)
    self.playing = {}
    self.fadingIn = {}
    for _,name in pairs(playing) do
        --print("Fading out " .. name)
        table.insert(self.fadingOut, name)
    end
end

return M