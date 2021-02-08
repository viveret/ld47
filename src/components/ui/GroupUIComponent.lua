local super = require "src.components.ui.BaseUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new(type)
    local self = setmetatable(lume.extend(super.new(type or 'group'), {
        offsetX = 0,
        offsetY = 0,
        wasClickedBefore = false,
        uielements = {},
        itemGap = 8,
        direction = 'vertical',
	}), M)
	
	return self
end

function M:keypressed( key, scancode, isrepeat )
    for k,el in pairs(self.uielements) do
        el:keypressed( key, scancode, isrepeat )
    end
end

function M:keyreleased( key, scancode )
    for k,el in pairs(self.uielements) do
        el:keyreleased( key, scancode )
    end
end

function M:activated()
    for k,el in pairs(self.uielements) do
        el:activated()
    end
end

function M:tick(ticks)
	-- self.duration = self.duration - 1
	-- if self.duration == 0 then
	-- 	self:remove()
	-- end
end

function M:draw()
    if self.bg then
        game.graphics:drawObject(self.bg, 0, 0, self:getWidth(), self:getHeight())
    end

    if self.justify == 'center' then
        self.offsetX = self:getWidth() / 2
    end

    lg.push()
    lg.translate(self.offsetX, self.offsetY)

    if self.direction == 'vertical' then
        if self.justify == 'center' then
            for k, el in pairs(self.uielements) do
                local hw = el:getWidth() / 2
                lg.translate(-hw, self.itemGap)
                el:draw()
                lg.translate(hw, el:getHeight() + self.itemGap)
            end
        else
            for k, el in pairs(self.uielements) do
                lg.translate(0, self.itemGap)
                el:draw()
                lg.translate(0, el:getHeight() + self.itemGap)
            end
        end
    else
        if self.justify == 'center' then
            for k, el in pairs(self.uielements) do
                local hh = el:getHeight() / 2
                lg.translate(self.itemGap, -hh)
                el:draw()
                lg.translate(el:getWidth() + self.itemGap, hh)
            end
        else
            lg.translate(-self:getWidth() - self.itemGap * 3, 0)
            for k, el in pairs(self.uielements) do
                lg.translate(self.itemGap, 0)
                el:draw()
                lg.translate(el:getWidth() + self.itemGap, 0)
            end
        end
    end
    lg.pop()
end

function M:drawFlow(elems)
    lg.push()
    
    for k, el in pairs(elems) do
        lg.translate(0, self.itemGap)
        el:draw()
        lg.translate(0, el:getHeight() + self.itemGap)
    end
    
    lg.pop()
end

function M:update(dt)
    local x = love.mouse.getX()
    local y = love.mouse.getY()
    local isClicked = (not self.wasClickedBefore) and love.mouse.isDown(1)
    self.wasClickedBefore = love.mouse.isDown(1)
    local elx = self.offsetX
    local ely = self.offsetY
    if self.direction == 'vertical' then
        if self.justify == 'center' then
            for k,el in pairs(self.uielements) do
                ely = ely + self.itemGap
                local hw = (el:getWidth() or el.w) / 2
                --local hh = (el:getHeight() or el.h) / 2
                if el.type == 'text button' or el.type == 'image button' then
                    el.hover = elx - hw <= x and elx + hw >= x and
                        ely <= y and ely + (el:getHeight() or el.h) >= y
                    if el.hover and isClicked and el.clicked ~= true then
                        el.clicked = true
                        if el.onClicked ~= nil then
                            el.onClicked()
                        elseif el.event ~= nil then
                            game.fire(el.event)
                        end
                    end
                else--if el.update ~= nil then
                    el:update(dt)
                end
                ely = ely + el:getHeight() + self.itemGap
            end
        else
            for k,el in pairs(self.uielements) do
                ely = ely + self.itemGap
                if el.type == 'text button' or el.type == 'image button' then
                    el.hover = elx <= x and elx + (el:getWidth() or el.w) >= x and
                        ely <= y and ely + (el:getHeight() or el.h) >= y
                    if el.hover and isClicked and el.clicked ~= true then
                        el.clicked = true
                        if el.onClicked ~= nil then
                            el.onClicked()
                        elseif el.event ~= nil then
                            game.fire(el.event)
                        end
                    end
                else--if el.update ~= nil then
                    el:update(dt)
                end
                ely = ely + el:getHeight() + self.itemGap
            end
        end
    else
        if self.justify == 'center' then
            for k,el in pairs(self.uielements) do
                elx = elx + self.itemGap
                local hh = (el:getHeight() or el.h) / 2
                --local hh = (el:getHeight() or el.h) / 2
                if el.type == 'text button' or el.type == 'image button' then
                    el.hover = ely - hh <= y and ely + hh >= y and
                        elx <= x and elx + (el:getWidth() or el.w) >= x
                    if el.hover and isClicked and el.clicked ~= true then
                        el.clicked = true
                        if el.onClicked ~= nil then
                            el.onClicked()
                        elseif el.event ~= nil then
                            game.fire(el.event)
                        end
                    end
                else--if el.update ~= nil then
                    el:update(dt)
                end
                elx = elx + el:getWidth() + self.itemGap
            end
        else
            for k,el in pairs(self.uielements) do
                elx = elx + self.itemGap
                if el.type == 'text button' or el.type == 'image button' then
                    el.hover = ely <= y and ely + (el:getHeight() or el.h) >= y and
                        elx <= x and elx + (el:getWidth() or el.w) >= x
                    if el.hover and isClicked and el.clicked ~= true then
                        el.clicked = true
                        if el.onClicked ~= nil then
                            el.onClicked()
                        elseif el.event ~= nil then
                            game.fire(el.event)
                        end
                    end
                else--if el.update ~= nil then
                    el:update(dt)
                end
                elx = elx + el:getWidth() + self.itemGap
            end
        end
    end
end

function M:addUiElement(el)
    table.insert(self.uielements, el)
    el.parent = self
end

function M:removeUiElement(el)
    lume.remove(self.uielements, el)
    el.parent = nil
end

function M:addButton(text, eventToFire)
    self:addUiElement(uiComponents.TextButton.new(text, eventToFire))
end

function M:addImageButton(img, eventToFire)
    self:addUiElement(uiComponents.ImageButton.new(img, eventToFire))
end

function M:addSpace(distance)
    self:addUiElement(uiComponents.Space.new(distance))
end

function M:getWidth()
    local v = 0
    for k, el in pairs(self.uielements) do
        v = max(v, el:getWidth())
    end
    return v
end

function M:getHeight()
    local v = 0
    for k, el in pairs(self.uielements) do
        v = v + el:getHeight() + self.itemGap * 2
    end
    return v
end

return M