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

        }
	}, M)
	return self
end

function M:draw()
    self.gamestate.graphics:drawObject(self.gamestate.graphics.ui.menu_bg, 0, 0, lg.getWidth(), lg.getHeight())
    
    if self.title ~= nil then
        lg.print(self.title, 0, 0)
    end

    lg.push()
    self.offsetX = lg.getWidth() / 2 - 230 / 2
    self.offsetY = 60 * 3
    lg.translate(self.offsetX, self.offsetY)
    for k, el in pairs(self.uielements) do
        self:drawUiElement(el)
    end
    lg.pop()
end

function M:drawFlow(elems)
    lg.push()
    
    for k, el in pairs(elems) do
        --lg.translate(0, 60)
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
    self.gamestate.graphics:drawObject(self.gamestate.graphics.ui.button_bg, 0, 0, 230, 60)
	self.gamestate.graphics:renderTextInBox(el.text, 0, 0, 230, 60)
    lg.translate(0, 60 + 16)
    if el.clicked then
        lg.setColor(1, 1, 1)
    elseif el.hover then
        lg.setColor(1, 1, 1)
    end
end

function M:drawUiElement(el)
    local actions = {
        ["button"] = function (el) self:drawButton(el) end,
        --["button"] = function (el) self.drawButton(el) end
    }
    local actionHandler = actions[el.type]
    if actionHandler ~= nil then
        actionHandler(el)
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
        if el.type == 'button' then
            el.hover = elx <= x and elx + (el.w or 230) >= x and
                ely <= y and ely + (el.h or 60) >= y
            if el.hover and isClicked then
                el.clicked = true
                if el.onClicked ~= nil then
                    el.onClicked()
                elseif el.event ~= nil then
                    self.gamestate.fire(el.event)
                end
            end
            ely = ely + 60
        end
    end
end

function M:addButton(text, eventToFire)
    table.insert(self.uielements, {
        type = 'button',
        text = text,
        event = eventToFire
    })
end

function M:load()
	--local buttons = {}
	-- for line in lines do
    -- 	local scene, timeRaw, flagsRaw, actionRaw = line:match("^%s*(.-),%s*(.-),%s*(.-),%s*(.-)$")
		
	-- 	local action = parseAction(actionRaw)
	-- 	local time = tonumber(timeRaw)
	-- 	local flags = {}
	-- 	for flag in flagsRaw:gmatch("([^\\|]+):?") do 
	-- 		flags[flag] = true
	-- 	end

    -- 	data[#data + 1] = { scene = scene, time = time, flags = flags, action = action }
	-- end
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