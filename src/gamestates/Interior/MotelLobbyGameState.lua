local super = require "src.gamestates.Physical.IndoorsGameState"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new()
    local self = setmetatable(super.new('MotelLobby', game.images.places.motel_lobby), M)
	
    self.warps = {
        { -- Main door
            x = 45, y = 75,
            w = 10, h = 10,
            path = 'Overworld,48,43,x'
        }
    }
    
    local left, right, up, down = self:detectWorldBounds()
    local bottomLeft, bottomRight = self:splitBoundHorizontal(down, self.warps[1])
    self:addWorldBounds({
        left, right, up, bottomLeft, bottomRight,
        { -- Chairs Right
            x = 77, y = 45,
            w = 23, h = 13
        },
        { -- Chairs Bottom Right
            x = 57, y = 57,
            w = 20, h = 18
        },
        { -- file cabinet
            x = 59, y = 24,
            w = 28, h = 5
        },
        { -- table
            x = 26, y = 26,
            w = 23, h = 10
        }
    })

	return self
end

function M:setupPhysics(args)
    super.setupPhysics(self, args)

    -- todo: time of day check

    if self.guy == nil then
        local onMotelGuyInteract = function(player)
            if (game.hasFlag('has-not-reserved-room')) then
                game.clearFlag('has-not-reserved-room')
                game.setFlag('has-reserved-room')
                game.fire(self.onReserveRoomEvent, true)
            else
                -- you have already reserved a room
                game.fire(self.onReReserveRoomEvent, true)
            end
        end

        self.guy = events.actor.ActorSpawnEvent.new("MotelLobby", "MotelGuy", "motel_guy", 37, 31, onMotelGuyInteract)
        game.fire(self.guy)
    end

    self.greeting = events.actor.ActorSpeakEvent.new("MotelLobby", "MotelGuy", "'sup. Are you here for the convention?")
    self.onReserveRoomEvent = events.actor.ActorSpeakEvent.new("MotelLobby", "MotelGuy", "Here are the keys to the last room.")
    self.onReReserveRoomEvent = events.actor.ActorSpeakEvent.new("MotelLobby", "MotelGuy", "You already reservd a room.")

    game.fire(self.greeting)
end

return M