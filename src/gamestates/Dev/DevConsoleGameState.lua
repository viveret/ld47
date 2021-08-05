local KeyboardInput = require "src.components.ui.KeyboardInput"

local M = { }
M.__index = M

function M.new()
    local self = setmetatable({
        isTransparent = true,
		kb = KeyboardInput.new(),
		content = 'dev console\n'
	}, M)

	self.kb:addOnSubmitListener(
		function()
			local cmd = self.kb.text
			self.kb:reset()
			self:executeCommand(cmd)
		end
	)

	self.kb:addSuggestionSource(
		function()
			local split = {}
			for s in self.kb.text:gmatch("(%w+)%.?") do  
				table.insert(split, s)
			end

			local autocompletePath = {}

			if #split > 0 then
				for i = #split, 1, -1 do
					local token = split[i]
					if token:match("%w") then
						table.insert(autocompletePath, 1, token)
					else
						print('breaking on ' .. token)
						break
					end
				end
			else
				table.insert(autocompletePath, self.kb.text)
			end
			
			if #autocompletePath == 1 then
				for k,v in pairs(_G) do
					if k:sub(0, #self.kb.text):lower() == self.kb.text:lower() then
						return k:sub(#self.kb.text + 1)
					end
				end

				return ''
			elseif #autocompletePath > 0 then
				local ctx = _G
				for i = 1, #autocompletePath - 1, 1 do
					local key = autocompletePath[i]
					ctx = ctx[key]
					if ctx == nil or type(ctx) == 'function' then
						return ''
					end
				end
				
				local lastKey = autocompletePath[#autocompletePath]
				local lastKeyLength = #lastKey
				for k,v in pairs(ctx) do
					if k:sub(0, lastKeyLength) == lastKey then
						return k:sub(lastKeyLength + 1)
					end
				end

				return ''
			else
				return ''
			end
		end
	)

	return self
end

function M:executeCommand(cmd)
	if cmd == 'clear' then
		self.content = 'dev console\n'
	else
		local cmdLoaded = load('return ' .. cmd)
		local cmdOutput = nil
		if cmdLoaded ~= nil then
			cmdOutput = cmdLoaded()
			if type(cmdOutput) == 'table' then
				cmdOutput = inspect(cmdOutput)
			elseif type(cmdOutput) == 'function' then
				cmdOutput = cmdOutput()
			end
		end
		
		local output = cmd .. ': ' .. (cmdOutput or 'nil')
		self.content = self.content .. output .. '\n'
	end
end

function M:keypressed( key, scancode, isrepeat )
	if not isrepeat and key == 'escape' then
		game.pop(game.stackTransitions.DialogOut)
		return
	end
	self.kb:keypressed( key, scancode, isrepeat )
end

function M:keyreleased( key, scancode )
	self.kb:keyreleased( key, scancode )
end

function M:activated()
end

function M:update(dt)
end

function M:load()
end

function M:save()
end

function M:draw()
	local outerXGutter = 5
	local innerXGutter = 18
	local outerYGutter = 5
	local innerYGutter = 14
	local maximumTextWidth = (572 - (innerXGutter * 2))
	local maximumTextHeight = 200
	local maximumNameWidth = 125
	local maximumNameHeight = 30

	-- calculate dialog placement
	local width, height = game.images.ui.dialog:getDimensions()
	
	local maximumTextHeight = height - (innerYGutter * 2)

	-- render the dialog box
	lg.push()
	lg.translate(outerXGutter, outerYGutter)

	lg.setColor(0.8, 0, 0.8, 0.8)
	lg.rectangle('fill', 0, 0, width, height)
	lg.setColor(1, 1, 1, 1)
	
	-- render the text
	lg.push()
	lg.translate(innerXGutter, innerYGutter)

	lg.printf(self.content, 0, 0, width - innerXGutter)

	lg.translate(0, height - self.kb.h - innerYGutter * 2)
	self.kb.w = width - innerXGutter * 2
	self.kb:draw()

	lg.pop()
	lg.pop()
end

function M:getWidth()
    return lg.getWidth()
end

function M:getHeight()
    return lg.getHeight()
end

return M