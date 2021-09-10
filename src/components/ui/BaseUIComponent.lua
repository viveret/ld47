local M = {}
M.__index = M
M.__file = __file__()

local UITransition = require "src.components.ui.UITransition"

function M.new(type)
    local self = setmetatable({
        type = type or "generic ui component",
        offsetX = 0,
        offsetY = 0,
        positioning = 'static',
        w = 0,
        h = 0,
        padding = {
            l = 0,
            r = 0,
            t = 0,
            b = 0,
        },
        margin = {
            l = 0,
            r = 0,
            t = 0,
            b = 0,
        },
        positioning = 'static', -- see https://www.w3schools.com/css/css_positioning.asp,
        activeTransitions = {},
	}, M)
	return self
end

function M:draw()
    lg.push()
    if self.positioning == 'relative' then
        lg.translate(self.offsetX, self.offsetY)
    end

    self:drawContent()

    lg.pop()
end

function M:drawContent()
    if self.bgColor then
        lg.setColor(self.bgColor.r, self.bgColor.g, self.bgColor.b, self.bgColor.a)
        lg.rectangle('fill',
                     0, 0,
                     self:getContentWidth(),
                     self:getContentHeight())
        lg.setColor(1, 1, 1, 1)
    elseif self.bg then
        game.graphics:drawObject(self.bg, 0, 0, self:getWidth(), self:getHeight())
    end

    if self:hasInnerContent() then
        lg.push()
        lg.translate(self.padding.l, self.padding.t)
        self:drawInnerContent()
        lg.pop()
    end
end

function M:hasInnerContent()
    return self.text and self.text ~= ''
end

function M:drawInnerContent()
    if self.justify == "center" then
        game.graphics:drawTextInBox(self.text, 0, 0, self:getWidth(), self:getHeight(), game.images.ui.dialog_font)
    else
        game.graphics:drawTextInBox(self.text, 0, 0, self:getWidth(), self:getHeight(), game.images.ui.dialog_font)
    end
end

function M:update(dt)
    for i,v in ipairs(self.activeTransitions) do
        v:update(dt)
    end
end

function M:activated()
end

function M:tostring()
    return self.type
end

function M:onKeyPressed( key, scancode, isrepeat )
end

function M:onKeyReleased( key, scancode )
end

function M:mousemoved(isClicked, x, y, elx, ely)
    if self.hover and isClicked and self.clicked ~= true then
        self:onClick()
    end
end

function M:onClick()
    self.clicked = true

    local afterClick = function()
        self.click = nil
    end

    if self.event ~= nil then
        return game.fire(self.event, true, { self }):next(afterClick)
    else
        self.clicked = nil
    end
end

function M:getWidth()
    return self.w
end

function M:getHeight()
    return self.h
end

function M:getContentWidth()
    return self:getWidth() + self.padding.l + self.padding.r
end

function M:getContentHeight()
    return self:getHeight() + self.padding.t + self.padding.b
end

function M:getExternalWidth()
    return self:getWidth() + self.padding.l + self.padding.r + self.margin.l + self.margin.r
end

function M:getExternalHeight()
    return self:getHeight() + self.padding.t + self.padding.b + self.margin.t + self.margin.b
end

local initialArgs = { name = "fade", duration = 1, easing = "linear" }
function M:transitionThenRemoveFromParent(args)
    if args == nil then
        args = initialArgs
    else
        args = lume.extend({}, initialArgs, args)
    end

    local easing = easings[args.easing] or error("invalid easing")
    local promise = Promise.new()
    promise:next(
        function()
            self.parent:removeUiElement(self)
        end
    )
    local transition = UITransition.new(easing, args, promise)
    table.insert(self.activeTransitions, transition)
    return transition.promise
end

return M