local super = require "src.gamestates.BaseGameState"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new(scene)
    local self = setmetatable(lume.extend(super.new(scene or "dialog"), {
        isTransparent = true,
		nextAnimation = game.animations.ui.text_arrow,
		charsToShow = 0,
		charsPerSecond = game.options.textSpeed,
	}), M)

	return self
end

function M:onCreate(args)
	super.onCreate(self, args)
	local actor, title, text = unpack(args)
	if actor == nil then
		error ('actor cannot be nil')
	end
	self.actor = actor
	self.title = title
	self.text = text
end

function M:onKeyPressed( key, scancode, isrepeat )
    if not isrepeat then
		if lume.find({game.strings.keyBinds.interact, 'return', 'escape'}, key) ~= nil then
			if self.charsToShow >= #self.text then
				game.stateMgr:popTop(gamestateTransitions.DialogOut)
			else
				self.charsToShow = #self.text
			end
		end
	end
end

function M:onKeyReleased( key, scancode )
	
end

function M:update(dt)
	self.nextAnimation:update(dt)
	self.charsToShow = min(self.charsToShow + dt * self.charsPerSecond, #self.text)
end

function M:draw()
	local actor = self.actor
	local title = self.title
	local text = self.text
	local animation = self.nextAnimation

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

	local y = outerYGutter
	local x = outerXGutter + _renderWidth / 2 - width / 2

	-- render the profile picture
	local profile = nil

	if actor == '???' then
		profile = game.images.ui.portraits.unknown
	else
		profile = game.images.ui.portraits[actor]
	end

	if profile == nil then
		profile = game.images.ui.portraits.unknown
	end

	if profile ~= nil then 
		local profileX = x + 28
		local profileY = y + 16

		game.graphics:drawObject(profile, profileX, profileY, 152, 152)
	end

	-- render the dialog box
	
	game.graphics:drawObject(game.images.ui.dialog, x, y, width, height)
	
	-- render the text
	game.graphics:drawTextInBox(text:sub(0, floor(self.charsToShow)), x + 180 + innerXGutter, y, maximumTextWidth, maximumTextHeight, game.images.ui.dialog_font)

	-- render the name
	game.graphics:drawTextInBox(title, x + 40, y + 175, maximumNameWidth, maximumNameHeight, game.images.ui.dialog_font, nil, true)

	if animation ~= nil then
		local animSize = animation:getFrameSize()

		local animX = x + width - innerXGutter - animSize.width
		local animY = y + height - innerYGutter - animSize.height

		animation:draw(animX, animY, true)
	end
end

function M:getWidth()
    return lg.getWidth()
end

function M:getHeight()
    return lg.getHeight()
end

return M