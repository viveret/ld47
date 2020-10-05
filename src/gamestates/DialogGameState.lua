local M = { }
M.__index = M

function M.new(gamestate, name, text)
	print("new "..name)

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
        name = name,
        text = text,
        lowerGameState = physicalGamestate,
        nextAnimation = animation.new(gamestate.graphics.TextArrow, 32, 32, 0, 2, 0, 1, false),
        scene = name
	}, M)

    self.scene = name

	return self
end

function M:update(dt)
	if lk.isDown('space', 'return', 'escape') then
        self.gamestate.pop()
    end

    self.nextAnimation:update(dt)
end

function M:load()
end

function M:save()
end

function M:draw()
	self.lowerGameState:draw()

	self.gamestate.graphics:drawDialogBox(self.name, self.text, self.nextAnimation)
end

function M:getWidth()
    return self.lowerGameState:getWidth()
end

function M:getHeight()
    return self.lowerGameState:getHeight()
end

return M