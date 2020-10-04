local M = { 
	visible = false,
	text = nil,
	duration = nil,
	gamestate = nil
}

function M.init(gamestate) 
    M.gamestate = gamestate
end

function M.showToast(text)
	M.visible = true
	M.text = text
	M.duration = text:len() * 30
end

function M.draw()
	if not M.visible then
		return
	end

	local dialogBox = M.gamestate.graphics.Dialog

	local width, height = dialogBox:getDimensions()

	local y = 5
	local x = _renderWidth / 2 - width / 2

	M.gamestate.graphics.drawObject(dialogBox, x, y, width, height)

	lg.print(M.text, width / 2, height / 2)
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