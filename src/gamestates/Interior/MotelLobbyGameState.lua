IndoorsGameState = require "src.gamestates.Interior.IndoorsGameState"
local M = setmetatable({}, { __index = IndoorsGameState })
M.__index = M

function M.new(gamestate)
    local self = setmetatable(IndoorsGameState.new(gamestate, 'MotelLobby', gamestate.images.places.motel_lobby), M)
    
    self:addWorldBounds({
        { -- Left
            x = 15, y = 8,
            w = 4, h = 80
        },
        { -- Top
            x = 0, y = 20,
            w = 100, h = 4
        },
        { -- Right
            x = 85, y = 0,
            w = 4, h = 80
        },
        { -- Chairs Right
            x = 80, y = 45,
            w = 20, h = 13
        },
        { -- Chairs Bottom Right
            x = 60, y = 60,
            w = 20, h = 13
        },
        { -- file cabinet
            x = 62, y = 24,
            w = 22, h = 5
        },
        { -- table
            x = 26, y = 26,
            w = 23, h = 10
        }
    })
	
    self.warps = {
        { -- Main door
            x = 45, y = 68,
            w = 10, h = 10,
            path = 'Overworld,48,43,x'
        }
    }

	return self
end

function M:draw()
    IndoorsGameState.draw(self)
end

function M:update(dt)
    IndoorsGameState.update(self, dt)
end

function M:load()
    IndoorsGameState.load(self)
end

function M:switchTo(x, y)
    IndoorsGameState.switchTo(self, x, y)

    -- todo: time of day check

    if self.guy == nil then
        local onMotelGuyInteract = function(player)
            if (self.gamestate.hasFlag('has-not-reserved-room')) then
                self.gamestate.clearFlag('has-not-reserved-room')
                self.gamestate.setFlag('has-reserved-room')
                self.gamestate.fire(self.onReserveRoomEvent, true)
            else
                -- you have already reserved a room
                self.gamestate.fire(self.onReReserveRoomEvent, true)
            end
        end

        self.guy = ActorSpawnEvent.new("MotelLobby", "MotelGuy", "motel_guy", 37, 31, onMotelGuyInteract)
        self.gamestate.fire(self.guy)
    end

    self.greeting = ActorSpeakEvent.new("MotelLobby", "MotelGuy", "'sup. Are you here for the convention?")
    self.onReserveRoomEvent = ActorSpeakEvent.new("MotelLobby", "MotelGuy", "Here are the keys to the last room.")
    self.onReReserveRoomEvent = ActorSpeakEvent.new("MotelLobby", "MotelGuy", "You already reservd a room.")

    self.gamestate.fire(self.greeting)
end

function M.save()
end


function M:activated()
    self.gamestate.ensureBGMusic("theme")
end

return M