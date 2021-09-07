local super = require "src.gamestates.Physical.PhysicalGameState"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new(name, graphics)
    local self = setmetatable(lume.extend(super.new(name, graphics), {

    }), M)
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
	return self
end

function M:detectWorldBounds(padding, padding_y)
    local padding_x = padding or 4
    padding_y = padding_y or padding_x
    local width, height = self.background:getDimensions()
    local halfWidth, halfHeight = width / 2, height / 2

    -- get color from top left pixel
    local raw = game.images:getImageDataFromImage(self.background)
    local r, g, b, a = raw:getPixel( 0, 0 )
    local pixel = { r, g, b }
    local left, right, up, down = nil, nil, nil, nil

    -- left
    for i = 1, width - 1, 2 do
        local tr, tg, tb, ta = raw:getPixel( i, halfHeight )
        local tpixel = { tr, tg, tb }

        if not arraysAreEqual(pixel, tpixel) then
            left = {
                x = i * game.objectScale, y = 0,
                w = padding_x, h = height * game.objectScale
            }
            break
        end
    end
    if left == nil then
        left = {
            x = 0, y = 0,
            w = padding_x, h = height * game.objectScale
        }
    end

    -- right
    for i = width - 1, 1, -2 do
        local tr, tg, tb, ta = raw:getPixel( i, halfHeight )
        local tpixel = { tr, tg, tb }

        if not arraysAreEqual(pixel, tpixel) then
            right = {
                x = i * game.objectScale - padding_x, y = 0,
                w = padding_x, h = height * game.objectScale
            }
            break
        end
    end
    if right == nil then
        right = {
            x = width * game.objectScale - padding_x, y = 0,
            w = padding_x, h = height * game.objectScale
        }
    end

    -- up
    for i = 1, height - 1, 2 do
        local tr, tg, tb, ta = raw:getPixel( halfWidth, i )
        local tpixel = { tr, tg, tb }

        if not arraysAreEqual(pixel, tpixel) then
            up = {
                x = 0, y = i * game.objectScale,
                w = width * game.objectScale, h = padding_y
            }
            break
        end
    end
    if up == nil then
        up = {
            x = 0, y = 0,
            w = width * game.objectScale, h = padding_y
        }
    end

    -- down
    for i = height - 1, 1, -2 do
        local tr, tg, tb, ta = raw:getPixel( halfWidth, i )
        local tpixel = { tr, tg, tb }

        if not arraysAreEqual(pixel, tpixel) then
            down = {
                x = 0, y = i * game.objectScale - padding_y,
                w = width * game.objectScale, h = padding_y * 2
            }
            break
        end
    end
    if down == nil then
        down = {
            x = 0, y = height * game.objectScale - padding_y,
            w = width * game.objectScale, h = padding_y * 2
        }
    end

    return left, right, up, down
end

function M:switchTo(x, y)
    super.switchTo(self, x, y)
    self:assignLightColor()
end

function M:onFlipLightSwitch()
    self.state.lightsAreOn = self.state.lightsAreOn ~= nil and not self.state.lightsAreOn
    self:assignLightColor()
end

function M:assignLightColor()
    if self.state.lightsAreOn or self.state.lightsAreOn == nil then
        lume.extend(self.colors, self.colors.lightsOn)
    else
        lume.extend(self.colors, self.colors.lightsOff)
    end
end

function M:addLightSwitch(x, y, image)
    local fn = function() game.stateMgr:current():onFlipLightSwitch() end
    local obj = self:CreateAndAddDrawableObject(x, y, image, false, fn, 'Flip Lights')

    obj.type = 'light-switch'
    obj.isInteractable = true
    table.insert(self.proximityObjects, obj)
    return obj
end

return M