local M = { }
M.__index = M

function M.new(gamestate, actor, title, text)
	if actor == nil then
		error ('actor cannot be nil')
	end

	local physicalGamestate = nil

	for i=#gamestate.stack,0,-1 do
		local state = gamestate.stack[i]
		if state.isPhysicalGameState then
			physicalGamestate = state
			break
		end
	end

	if physicalGamestate == nil then
		error("Couldn't find lower physical game state")
	end

    local self = setmetatable({
        gamestate = gamestate,
		actor = actor,
		title = title,
        text = text,
        lowerGameState = physicalGamestate,
		nextAnimation = gamestate.animations.ui.text_arrow,
	}, M)

	return self
end

function M:keypressed( key, scancode, isrepeat )
    if not isrepeat then
		if lume.find({'space', 'return', 'escape'}, key) ~= nil then
			self.gamestate.pop()
		end
	end
end

function M:keyreleased( key, scancode )
	
end

function M:activated()
end

function M:update(dt)
    self.nextAnimation:update(dt)
end

function M:load()
end

function M:save()
end

function M:draw()
	self.lowerGameState:draw()

	self.gamestate.images:drawDialogBox(self.actor, self.title, self.text, self.nextAnimation)
end

function M:getWidth()
    return self.lowerGameState:getWidth()
end

function M:getHeight()
    return self.lowerGameState:getHeight()
end

return M