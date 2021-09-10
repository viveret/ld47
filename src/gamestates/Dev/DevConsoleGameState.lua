local super = require "src.gamestates.BaseGameState"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

local KeyboardInput = require "src.components.ui.inputs.KeyboardInput"


function M.new()
    local self = setmetatable(lume.extend(super.new("dev-console"), {
        isTransparent = true,
		kb = KeyboardInput.new(),
		content = 'dev console\n',
	}), M)

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
			local restOfString = self.kb.text
			for s in self.kb.text:gmatch("(%w+)") do
				table.insert(split, s)
				restOfString = restOfString:sub(#s + 1)
				local sep = restOfString:match('(%W+)')
				if sep ~= nil and sep ~= restOfString then
					table.insert(split, sep)
					restOfString = restOfString:sub(#sep + 1)
				end
			end
			-- print('split: ' .. inspect(split))

			local autocompletePath = {}

			if #split > 0 then
				for i = #split, 1, -1 do
					local token = split[i]
					if token:match("%w") then
						table.insert(autocompletePath, 1, token)
					elseif token ~= '.' then
						-- print('breaking on ' .. token)
						break
					end
				end
			else
				table.insert(autocompletePath, self.kb.text)
			end
			-- print('autocompletePath: ' .. inspect(autocompletePath))
			
			if #autocompletePath > 0 then
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
		table.insert(self.kb.history, cmd)
		--local cmdLoaded = load('return ' .. cmd)
		local cmdLoaded = load(cmd)
		local cmdOutput = nil
		if cmdLoaded ~= nil then
			cmdOutput = cmdLoaded()
			
			if type(cmdOutput) == 'function' then
				cmdOutput = cmdOutput()
			end

			if type(cmdOutput) == 'table' then
				cmdOutput = inspect(cmdOutput)
			end
		end
		
		local output = cmd .. ': ' .. (cmdOutput or 'nil')
		self.content = self.content .. output .. '\n'
	end
end

function M:onKeyPressed( key, scancode, isrepeat )
	if not isrepeat and key == 'escape' then
		game.stateMgr:popTop(gamestateTransitions.DialogOut)
		return
	end
	self.kb:onKeyPressed( key, scancode, isrepeat )
end

function M:onKeyReleased( key, scancode )
	self.kb:onKeyReleased( key, scancode )
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