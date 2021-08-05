local super = require "src.components.ui.BaseUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M

local history = {}

function M.new(img, eventToFire)
    local self = setmetatable(lume.extend(super.new('input'), {
        itemPad = 8,
        itemGap = 8,
        h = 60,
        text = '',
        cursorIndex = 0,
		historyIndex = 0,
        history = history,
        submitListeners = {},
        suggestionSources = {},
        modkeys = {
            shift = false,
            alt = false,
            capslock = false,
            ctrl = false,
        }
    }), M)
	return self
end

function M:addOnSubmitListener(handler)
    table.insert(self.submitListeners, handler)
end

function M:addSuggestionSource(handler)
    table.insert(self.suggestionSources, handler)
end

function M:reset()
    self.text = ''
    self.suggestionText = nil
    self.cursorIndex = 0
    self.historyIndex = 0
end

function M:draw()
    local charwidth = 15
    self.h = 17 * 2
    lg.setColor(1, 0, 1, 0.8)
    lg.rectangle('fill', self.cursorIndex * charwidth, 0, charwidth, self.h)
    lg.setColor(1, 1, 1, 1)
    lg.rectangle('line', 0, 0, self.w, self.h)

    for i = 1, #self.text do
        local c = self.text:sub(i,i)
        lg.print(c, (i - 1) * charwidth, 4, 0, 2, 2)
    end

    if self.suggestionText ~= nil and #self.suggestionText > 0 then
        lg.setColor(0.7, 0.7, 0.7, 1)
        lg.print(self.suggestionText, #self.text * charwidth, 4, 0, 2, 2)
    end
    lg.setColor(1, 1, 1, 1)
    -- lg.setColor(0.8, 0.8, 0.8)
    -- game.graphics:drawObject(self.img, 0, 0, self:getWidth(), self:getHeight())
    -- if self.clicked or self.hover then
    --     lg.setColor(1, 1, 1)
    -- end
end

function M:update(dt)
end

function M:activated()
end

function M:keypressed( key, scancode, isrepeat )
    if not isrepeat then
		if 'return' == key then
            local wasError = false
            for i,handler in ipairs(self.submitListeners) do
                if handler() == false then
                    wasError = true
                end
            end
            -- if not wasError then
            --     self.text = ''
            -- end
		elseif lume.find({game.keyBinds.backspace, 'backspace'}, key) ~= nil then
            if #self.text > 0 and self.cursorIndex > 0 then
                self.text = self.text:sub(0, self.cursorIndex - 1) .. self.text:sub(self.cursorIndex + 1, #self.text)
                self.cursorIndex = self.cursorIndex - 1
            end
		elseif lume.find({game.keyBinds.delete, 'delete'}, key) ~= nil then
            if #self.text > 0 and self.cursorIndex < #self.text then
                self.text = self.text:sub(0, self.cursorIndex) .. self.text:sub(self.cursorIndex + 2, #self.text)
            end
		elseif 'left' == key then
            if self.cursorIndex > 0 then
                self.cursorIndex = self.cursorIndex - 1
            end
		elseif 'right' == key then
            if self.cursorIndex < #self.text then
                self.cursorIndex = self.cursorIndex + 1
            end
		elseif 'up' == key then
            if self.historyIndex < #history then
                self.historyIndex = self.historyIndex + 1
                self.text = ''
                self.suggestionText = history[self.historyIndex]
                self.cursorIndex = #self.suggestionText
            end
		elseif 'down' == key then
            if self.historyIndex > 1 then
                self.historyIndex = self.historyIndex - 1
                self.text = ''
                self.suggestionText = history[self.historyIndex]
                self.cursorIndex = #self.suggestionText
            else
                self:reset()
            end
		elseif 'space' == key then
            self:insertChar(' ')
		elseif lume.find({'lalt', 'ralt'}, key) ~= nil then
            self.modkeys.alt = true
		elseif lume.find({'lshift', 'rshift'}, key) ~= nil then
            self.modkeys.shift = true
		elseif 'tab' == key then
            if self.suggestionText ~= nil and #self.suggestionText > 0 then
                self.text = self.text .. self.suggestionText
                self.suggestionText = nil
                self.cursorIndex = #self.text
                self.historyIndex = 0
            end
        elseif #key > 1 then
            print('Unsure how to handle ' .. key)
        else
            if self.modkeys.shift or self.modkeys.capslock then
                local mappedShift = nil

                if '[' == key then
                    mappedShift = '{'
                elseif ']' == key then
                    mappedShift = '{'
                elseif '`' == key then
                    mappedShift = '~'
                elseif '1' == key then
                    mappedShift = '!'
                elseif '2' == key then
                    mappedShift = '@'
                elseif '3' == key then
                    mappedShift = '#'
                elseif '4' == key then
                    mappedShift = '$'
                elseif '5' == key then
                    mappedShift = '%'
                elseif '6' == key then
                    mappedShift = '^'
                elseif '7' == key then
                    mappedShift = '&'
                elseif '8' == key then
                    mappedShift = '*'
                elseif '9' == key then
                    mappedShift = '('
                elseif '0' == key then
                    mappedShift = ')'
                elseif '-' == key then
                    mappedShift = '_'
                elseif '=' == key then
                    mappedShift = '+'
                elseif ';' == key then
                    mappedShift = ':'
                elseif '\'' == key then
                    mappedShift = '"'
                elseif ',' == key then
                    mappedShift = '<'
                elseif '.' == key then
                    mappedShift = '>'
                elseif '/' == key then
                    mappedShift = '?'
                elseif '\\' == key then
                    mappedShift = '|'
                end

                if mappedShift ~= nil then
                    key = mappedShift
                else
                    key = key:upper()
                end
            end

            self:insertChar(key)
		end
	end
end

function M:insertChar(c)
    if self.cursorIndex >= #self.text then
        self.text = self.text .. c
    else
        self.text = self.text:sub(0, self.cursorIndex) .. c .. self.text:sub(self.cursorIndex + 1, #self.text)
    end
    self.cursorIndex = self.cursorIndex + 1

    for i,handler in ipairs(self.suggestionSources) do
        local result = handler()
        if result ~= nil then
            self.suggestionText = result
            break
        end
    end
end

function M:keyreleased( key, scancode )
    if not isrepeat then
        if lume.find({'lalt', 'ralt'}, key) ~= nil then
            self.modkeys.alt = false
		elseif lume.find({'lshift', 'rshift'}, key) ~= nil then
            self.modkeys.shift = false
        end
    end
end

return M