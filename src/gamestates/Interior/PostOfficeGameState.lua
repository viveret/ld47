IndoorsGameState = require "src.gamestates.Interior.IndoorsGameState"
local M = setmetatable({}, { __index = IndoorsGameState })
M.__index = M

-- TODO: viv

function M.new(gamestate)
    local self = setmetatable(IndoorsGameState.new(gamestate, 'PostOffice', gamestate.images.places.post_office), M)
    
    self:addWorldBounds({
        { -- Divider
            x = 0, y = 30,
            w = self:getWidth(), h = 4
        },
    })
    
    self.warps = {
        { -- Main door
            x = 45, y = 68,
            w = 10, h = 10,
            path = 'Overworld,130,145,x'
        }
    }
    
    self.renderWarps = false
    self.renderBounds = false

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

    self:addStaticObjects({
        construction = StaticObject.new(self.world, 40, 40, self.gamestate.images.decor.construction),
    })
end

function M:switchTo(x, y)
    IndoorsGameState.switchTo(self, x, y)
end

function M.save()
end

return M