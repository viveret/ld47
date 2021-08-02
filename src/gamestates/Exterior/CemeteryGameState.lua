local super = require "src.gamestates.PhysicalGameState"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new()
    local self = setmetatable(PhysicalGameState.new('Cemetery', game.images.places.cemetery), M)
    self.bgMusicName = "dreamSequence"
    self:addExteriorWorldBounds(8)
    
    self:addWorldBounds({
        { -- Building
            x = 130, y = 0,
            w = 80, h = 50
        },
    })
    
    self.warps = {
        { -- Home
            x = 88, y = 130,
            w = 30, h = 10,
            path = 'Overworld,90,30,x'
        }
    }

    -- self:addStaticObjects({
    --     grave1 = AnimatedObject.new(self.world, 3.5, 5, game.animations.decor.freezer),
    --     grave2 = AnimatedObject.new(self.world, 15.5, 5, game.animations.decor.freezer),
    --     grave3 = AnimatedObject.new(self.world, 27.5, 5, game.animations.decor.freezer),

    --     backcounter = StaticObject.new(self.world, 70, 10, game.images.decor.back_counter),
    --     counter = StaticObject.new(self.world, 71, 35, game.images.decor.counter)
    -- })

    local rows = 5
    local cols = 6
    local xoff = 15
    local yoff = 15

    for r = 0,rows,1 do
        for c = 0,cols,1 do
            local x = xoff + c * (self:getWidth() - 100) / cols + random(1, 2)
            local y = yoff + r * (self:getHeight() - 70) / rows + random(1, 2)

            table.insert(self.staticObjects, StaticObject.new(self.world, x, y, game.images.places.cemetery['grave' .. random(1,8)]))

            if random() < 0.05 then
                table.insert(self.staticObjects, StaticObject.new(self.world, x, y + 8, game.images.places.cemetery.bones))
            elseif random() < 0.1 then
                table.insert(self.staticObjects, StaticObject.new(self.world, x, y + 8, game.images.places.cemetery.dugUp))
            elseif random() < 0.1 then
                table.insert(self.staticObjects, StaticObject.new(self.world, x, y + 8, game.images.places.cemetery.fresh))
            end
        end
    end
    
	return self
end

function M:draw()
    PhysicalGameState.draw(self)
end

function M:drawInWorldView()
    PhysicalGameState.drawInWorldView(self)
end

function M:update(dt)
    PhysicalGameState.update(self, dt)
end

function M:load(x, y)
    PhysicalGameState.load(self, x, y)
end

function M:switchTo(x, y)
    PhysicalGameState.switchTo(self, x, y)
end

function M:save()
end


return M