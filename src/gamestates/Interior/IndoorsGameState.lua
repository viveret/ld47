local super = require "src.gamestates.PhysicalGameState"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new(name, graphics)
    local self = setmetatable(super.new(name, graphics), M)
    lume.extend(self.colors, {
        lightsOff = {
            night = Color.new({ r = 0.2, g = 0, b = 0 }),
            day = Color.new({ r = 0.9, g = 0.7, b = 0.7 })
        },
        lightsOn = {
            night = Color.new({ r = 0.9, g = 0.7, b = 0.7 }),
            day = Color.new({ r = 1, g = 1, b = 1 })
        },
    })
    self:addExteriorWorldBounds()
	return self
end

function M:draw()
    super.draw(self)

    if self.objects ~= nil then
        for _, obj in pairs(self.objects) do
            obj:draw()
        end
    end
end

function M:update(dt)
    super.update(self, dt)
end

function M:load(x, y)
    super.load(self, x, y)
end

function M:switchTo(x, y)
    super.switchTo(self, x, y)
    self:assignLightColor()
end

function M.save()
end

function M:onFlipLightSwitch()
    self.lightsAreOn = self.lightsAreOn ~= nil and not self.lightsAreOn
    self:assignLightColor()
end

function M:assignLightColor()
    if self.lightsAreOn or self.lightsAreOn == nil then
        lume.extend(self.colors, self.colors.lightsOn)
    else
        lume.extend(self.colors, self.colors.lightsOff)
    end
end

function M:addLightSwitch(x, y, image)
    local obj = self:CreateAndAddDrawableObject(x, y, image, false, function() game.current():onFlipLightSwitch() end, 'Flip Lights')

    obj.type = 'light-switch'
    obj.isInteractable = true
    table.insert(self.proximityObjects, obj)
    return obj
end

function M:addInteractDialog(x, y, image, animated, label, name, text)
    local obj = self:CreateAndAddDrawableObject(x, y, image, animated, function()
		game.toast((name or '???') .. ': ' .. text)
    end, label)

    obj.type = 'dialog'
    obj.isInteractable = true
    table.insert(self.proximityObjects, obj)
    return obj
end

return M