local M = { 
	visible = false,
	text = nil,
	duration = nil,
	gamestate = nil
}

function M.init(gamestate) 
    M.gamestate = gamestate
end

function M.showToast(text, name)
	M.visible = true
	M.text = text
	M.name = name
	M.duration = text:len() * 30
end

function M.draw()
	if not M.visible then
		return
	end

	local name = M.name or "???"
	M.gamestate.graphics:drawDialogBox(name, M.text, nil)
end

function M.tick()
	if not M.visible then
		return
	end

	M.duration = M.duration - 1
	if M.duration == 0 then
		M.visible = false
		M.text = nil
		M.duration = nil
	end
end

return M