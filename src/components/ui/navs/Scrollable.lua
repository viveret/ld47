local super = require "src.components.ui.GroupUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new(type)
    local self = setmetatable(lume.extend(super.new(type or 'scrollable'), {
        scrollForce = 100,
    }), M)

	return self
end

function M:update(dt)
    if self.scrollVel.x ~= 0 or self.scrollVel.y ~= 0 or
        self.scrollAccel.x ~= 0 or self.scrollAccel.y ~= 0 then

        local scrollMax = {
            x = max(0, self:getWidth()),
            y = max(0, self:getHeight()),
        }

        for _, d in ipairs({ "x", "y" }) do
            self.scrollVel[d] = self.scrollVel[d] + self.scrollAccel[d] * dt
            self.scroll[d] = min(max(self.scroll[d] + self.scrollVel[d] * dt, 0), scrollMax[d])
            if self.scroll[d] < 0 and self.scrollVel[d] < 0 then
                self.scrollVel[d] = 0
                self.scroll[d] = 0
            elseif self.scroll[d] > scrollMax[d] and self.scrollVel[d] > 0 then
                self.scrollVel[d] = 0
                self.scroll[d] = scrollMax[d]
            else
                self.scrollVel[d] = self.scrollVel[d] - self.scrollVel[d] * dt
            end
        end
    end
    super.update(self, dt)
end

function M:keypressed( key, scancode, isrepeat )
    if not isrepeat then
        if key == 'w' then
            self.scrollAccel.y = -self.scrollForce
            return
        elseif key == 's' then
            self.scrollAccel.y = self.scrollForce
            return
        elseif key == 'a' then
            self.scrollAccel.x = -self.scrollForce
            return
        elseif key == 'd' then
            self.scrollAccel.x = self.scrollForce
            return
        end
    end
    super.keypressed(self, key, scancode, isrepeat)
end

function M:keyreleased( key, scancode )
    if key == 'w' or key == 's' then
        self.scrollAccel.y = 0
        return
    elseif key == 'a' or key == 'd' then
        self.scrollAccel.x = 0
        return
    end
    super.keyreleased(self, key, scancode)
end

return M