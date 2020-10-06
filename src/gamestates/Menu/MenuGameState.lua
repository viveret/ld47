local M = {}
M.__index = M

function M.new(gamestate, title)
    local self = setmetatable({
        gamestate = gamestate,
        title = title,
        offsetX = 0,
        offsetY = 0,
        wasClickedBefore = false,
        uielements = {

        },
        bg = gamestate.images.ui.menu_bg,
        bgMusicName = "day2",
    }, M)
    
	return self
end

function M:keypressed( key, scancode, isrepeat )
end

function M:keyreleased( key, scancode )
end

function M:activated()
    self.gamestate.audio:play(self.bgMusicName)
end

function M:draw()
    self.gamestate.graphics:drawObject(self.bg, 0, 0, lg.getWidth(), lg.getHeight())

    lg.push()
    self.offsetX = lg.getWidth() / 2 - 230 / 2
    self.offsetY = 60 * 2
    lg.translate(self.offsetX, self.offsetY)
    for k, el in pairs(self.uielements) do
        self:drawUiElement(el)
    end
    lg.pop()
end

function M:drawFlow(elems)
    lg.push()
    
    for k, el in pairs(elems) do
        self:drawUiElement(el)
    end
    
    lg.pop()
end

function M:drawButton(el)
    if el.clicked then
        lg.setColor(0.6, 0.6, 0.6)
    elseif el.hover then
        lg.setColor(0.8, 0.8, 0.8)
    end
    self.gamestate.graphics:drawObject(self.gamestate.images.ui.button_bg, 0, 0, 230, 60)
	self.gamestate.graphics:renderTextInBox(el.text, 0, 0, 230, 60, self.gamestate.images.ui.dialog_font)
    lg.translate(0, 60 + 16)
    if el.clicked then
        lg.setColor(1, 1, 1)
    elseif el.hover then
        lg.setColor(1, 1, 1)
    end
end

function M:drawImageButton(el)
    if el.clicked then
        lg.setColor(0.6, 0.6, 0.6)
    elseif el.hover then
        lg.setColor(0.8, 0.8, 0.8)
    end
    self.gamestate.graphics:drawObject(el.img, 0, 0, 230, 60)
    lg.translate(0, 60 + 16)
    if el.clicked then
        lg.setColor(1, 1, 1)
    elseif el.hover then
        lg.setColor(1, 1, 1)
    end
end

function M:drawSpace(el)
    lg.translate(0, el.distance)
end

function M:drawUiElement(el)
    local actions = {
        ["button"] = function (el) self:drawButton(el) end,
        ["imgbutton"] = function (el) self:drawImageButton(el) end,
        ["space"] = function (el) self:drawSpace(el) end,
    }
    local actionHandler = actions[el.type]
    if actionHandler ~= nil then
        actionHandler(el)
    elseif el.draw ~= nil then
        el:draw()
    end
end

function M:update(dt)
    local x = love.mouse.getX() - self.offsetX
    local y = love.mouse.getY() - self.offsetY
    local isClicked = (not self.wasClickedBefore) and love.mouse.isDown(1)
    self.wasClickedBefore = love.mouse.isDown(1)
    local elx = 0
    local ely = 0
    
    for k,el in pairs(self.uielements) do
        if el.type == 'button' or el.type == 'imgbutton' then
            el.hover = elx <= x and elx + (el.w or 230) >= x and
                ely <= y and ely + (el.h or 60) >= y
            if el.hover and isClicked and el.clicked ~= true then
                el.clicked = true
                if el.onClicked ~= nil then
                    el.onClicked()
                elseif el.event ~= nil then
                    self.gamestate.fire(el.event)
                end
            end
            ely = ely + 60
        elseif el.type == 'space' then
            ely = ely + el.distance
        elseif el.update ~= nil then
            el:update(dt)
        end
    end
end

function M:addUiElement(el)
    table.insert(self.uielements, el)
end

function M:addButton(text, eventToFire)
    self:addUiElement({
        type = 'button',
        text = text,
        event = eventToFire
    })
end

function M:addImageButton(img, eventToFire)
    self:addUiElement({
        type = 'imgbutton',
        img = img,
        event = eventToFire
    })
end

function M:addSpace(distance)
    self:addUiElement({
        type = 'space',
        distance = distance,
    })
end

function M:load()
end

function M:save()
end

function M:getWidth()
    return lg.getWidth()
end

function M:getHeight()
    return lg.getHeight()
end

return M