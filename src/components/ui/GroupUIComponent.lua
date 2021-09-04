local super = require "src.components.ui.BaseUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new(type)
    local self = setmetatable(lume.extend(super.new(type or 'group'), {
        wasClickedBefore = false,
        uielements = {},
        direction = 'vertical',
        scrollForce = 0,
        scroll = {
            x = 0,
            y = 0,
        },
        scrollVel = {
            x = 0,
            y = 0,
        },
        scrollAccel = {
            x = 0,
            y = 0,
        },
        itemGap = {
            x = 8,
            y = 8,
        },
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

function M:hasInnerContent()
    return #self.uielements > 0
end

function M:drawInnerContent()
    local offsetX, offsetY = 0, 0
    if self.direction == 'vertical' then
        if self.justify == 'center' then
            offsetX = self:getWidth() / 2
        end
    else
        if self.justify == 'center' then
            offsetY = self:getHeight() / 2
        end
    end

    lg.translate(-self.scroll.x + offsetX,
                 -self.scroll.y + offsetY)

    if self.direction == 'vertical' then
        if self.justify == 'center' then
            for k, el in pairs(self.uielements) do
                local hw = el:getContentWidth() / 2
                lg.translate(-hw + el.margin.l, el.margin.t)
                el:draw()
                lg.translate(hw - el.margin.l, el:getContentHeight() + el.margin.b)
            end
        else
            for k, el in pairs(self.uielements) do
                lg.translate(el.margin.l, el.margin.t)
                el:draw()
                lg.translate(-el.margin.l, el:getContentHeight() + el.margin.b)
            end
        end
    else
        if self.justify == 'center' then
            for k, el in pairs(self.uielements) do
                local hh = el:getContentHeight() / 2
                lg.translate(el.margin.l, -hh + el.margin.t)
                el:draw()
                lg.translate(el:getContentWidth() + el.margin.r, hh - el.margin.t)
            end
        else
            --lg.translate(-self:getExternalWidth(), 0)
            for k, el in pairs(self.uielements) do
                lg.translate(el.margin.l, el.margin.t)
                el:draw()
                lg.translate(el:getContentWidth() + el.margin.r, -el.margin.t)
            end
        end
    end
end

function M:drawFlow(elems)
    lg.push()
    
    for k, el in pairs(elems) do
        lg.translate(el.margin.l, el.margin.t)
        el:draw()
        lg.translate(el.margin.r, el:getContentHeight() + el.margin.b)
    end
    
    lg.pop()
end

function M:getAbsoluteOffsetX()
    local offsetX = 0
    if self.direction == 'vertical' then
        if self.justify == 'center' then
            offsetX = self:getWidth() / 2
        end
    end

    if self.positioning == 'relative' then
        offsetX = offsetX + self.offsetX
    end

    if self.parent == nil then
        return self.offsetX + offsetX
    else
        return self.offsetX + offsetX - self.parent.scroll.x + self.parent:getOffsetXForElement(self) + self.parent:getAbsoluteOffsetX()
    end
end

function M:getOffsetXForElement(el)
    local elIndex = lume.find(self.uielements, el)
    if elIndex == nil then
        error('element not found: ' .. inspect(el))
        return 0
    end

    if self.direction == 'vertical' then
        if self.justify == 'center' then
            return -el:getExternalWidth() / 2
        else
            return 0
        end
    else
        if elIndex == 1 then
            return 0
        else
            return lume.chain(self.uielements)
                        :slice(1, elIndex - 1)
                        :map(function (el) return el:getExternalWidth() end)
                        :reduce(function(a, b) return a + b end)
                        :result()
        end
    end

    return 0
end

function M:getAbsoluteOffsetY()
    local offsetY = 0
    if self.direction == 'horizontal' then
        if self.justify == 'center' then
            offsetY = self:getHeight() / 2
        end
    end

    if self.positioning == 'relative' then
        offsetY = offsetY + self.offsetY
    end

    if self.parent == nil then
        return offsetY
    else
        return offsetY - self.parent.scroll.y + self.parent:getOffsetYForElement(self) + self.parent:getAbsoluteOffsetY()
    end
end

function M:getOffsetYForElement(el)
    local elIndex = lume.find(self.uielements, el)
    if elIndex == nil then
        error('element not found: ' .. inspect(el))
        return 0
    end

    if self.direction == 'vertical' then
        if elIndex == 1 then
            return 0
        else
            return lume.chain(self.uielements)
                        :slice(1, elIndex - 1)
                        :map(function (el) return el:getExternalHeight() end)
                        :reduce(function(a, b) return a + b end)
                        :result()
        end
    else
        if self.justify == 'center' then
            return 0--el:getExternalHeight() / 2
        else
            return 0
        end
    end

    return 0
end

-- this isn't totally working with scroll (should make this in root view and call mousemoved)
function M:update(dt)
    local x = love.mouse.getX()
    local y = love.mouse.getY()
    local isClicked = (not self.wasClickedBefore) and love.mouse.isDown(1)
    self.wasClickedBefore = love.mouse.isDown(1)
    local elx = self.padding.l + self.margin.l + self:getAbsoluteOffsetX()
    local ely = self.padding.t + self.margin.t + self:getAbsoluteOffsetY()

    if self.direction == 'vertical' then
        if self.justify == 'center' then
            for k,el in pairs(self.uielements) do
                local hw = el:getExternalWidth() / 2
                --local hh = el:getExternalHeight() / 2
                el.hover = elx - hw <= x and elx + hw >= x and
                    ely <= y and ely + el:getExternalHeight() >= y
                el:mousemoved(isClicked, x, y, elx, ely)
                el:update(dt)
                ely = ely + el:getExternalHeight()
            end
        else
            for k,el in pairs(self.uielements) do
                el.hover = elx <= x and elx + el:getExternalWidth() >= x and
                    ely <= y and ely + el:getExternalHeight() >= y
                el:mousemoved(isClicked, x, y, elx, ely)
                el:update(dt)
                ely = ely + el:getExternalHeight()
            end
        end
    else
        if self.justify == 'center' then
            for k,el in pairs(self.uielements) do
                local hh = el:getExternalHeight() / 2
                --local hh = el:getExternalHeight() / 2
                el.hover = ely - hh <= y and ely + hh >= y and
                    elx <= x and elx + el:getExternalWidth() >= x
                el:mousemoved(isClicked, x, y, elx, ely)
                el:update(dt)
                elx = elx + el:getExternalWidth()
            end
        else
            for k,el in pairs(self.uielements) do
                el.hover = ely <= y and ely + el:getExternalHeight() >= y and
                    elx <= x and elx + el:getExternalWidth() >= x
                el:mousemoved(isClicked, x, y, elx, ely)
                el:update(dt)
                elx = elx + el:getExternalWidth()
            end
        end
    end
end

function M:addUiElement(el)
    table.insert(self.uielements, el)
    el.parent = self
end

function M:removeUiElement(el)
    table.remove(self.uielements, lume.find(self.uielements, el))
    el.parent = nil
end

function M:addButton(text, eventToFire)
    local el = uiComponents.inputs.TextButton.new(text, eventToFire)
    self:addUiElement(el)
    return el
end

function M:addImageButton(img, eventToFire)
    local el = uiComponents.inputs.ImageButton.new(img, eventToFire)
    self:addUiElement(el)
    return el
end

function M:addBackButton()
    return self:addButton('Back', events.gamestate.PopEvent.new())
end

function M:addReturnButton()
    self.returnButton = self:addButton('Return', events.game.ContinueGame.new())
    return self.returnButton
end

function M:addSpace(distance)
    local el = uiComponents.Space.new(distance)
    self:addUiElement(el)
    return el
end

function M:addInspection(data, backtrace)
    local el = self:createInspection(data, backtrace)
    self:addUiElement(el)
    return el
end

function M:createInspection(data, backtrace)
    local t = type(data)
    if t == 'string' then
        return uiComponents.inputs.TextButton.new(data)
    elseif t == 'number' then
        return uiComponents.inputs.TextButton.new('' .. data)
    elseif t == 'boolean' then
        return uiComponents.inputs.TextButton.new('' .. inspect(data))
    elseif t == 'function' then
        return uiComponents.inputs.TextButton.new('function')
    elseif t == 'nil' then
        return uiComponents.inputs.TextButton.new('nil')
    elseif t == 'userdata' then
        return uiComponents.inputs.TextButton.new('<custom data>')
    elseif t == 'table' then
        if backtrace == nil then
            backtrace = { self }
        elseif lume.find(backtrace, self) ~= nil or #backtrace > 4 then
            return uiComponents.inputs.TextButton.new('<recursive>')
        else
            table.insert(backtrace, self)
        end

        local group = M.new()
        group.bgColor = { r = 0, g = 0, b = 1, a = 0.2 }
        if data[1] == nil then -- can assume is object
            for k,v in pairs(data) do
                local row = M.new()
                row.bgColor = { r = 0, g = 1, b = 0, a = 0.2 }
                row.direction = 'horizontal'
                row:addUiElement(uiComponents.inputs.TextButton.new(k .. ':'))
                row:addSpace(16)
                row:addInspection(v, backtrace)
                group:addUiElement(row)
                group:addSpace(10)
            end
        else -- is array
            for k,v in pairs(data) do
                local row = M.new()
                row.bgColor = { r = 0, g = 1, b = 0, a = 0.2 }
                row.direction = 'horizontal'
                row:addInspection(v, backtrace)
                group:addUiElement(row)
                group:addSpace(10)
            end
        end
        table.remove(group.uielements, #group.uielements)
        return group
    else
        error('unknown type ' .. t)
    end
end

function M:getWidth()
    if self.w > 0 then
        return self.w
    elseif self.direction == 'vertical' then
        local v = 0
        for k, el in pairs(self.uielements) do
            v = max(v, el:getExternalWidth())
        end
        return v
    else
        local v = 0
        for k, el in pairs(self.uielements) do
            v = v + el:getExternalWidth()
        end
        return v
    end
end

function M:getHeight()
    if self.h > 0 then
        return self.h
    elseif self.direction == 'vertical' then
        local v = 0
        for k, el in pairs(self.uielements) do
            v = v + el:getExternalHeight()
        end
        return v
    else
        local v = 0
        for k, el in pairs(self.uielements) do
            v = max(v, el:getExternalHeight())
        end
        return v
    end
end

return M