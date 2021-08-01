local super = require "src.events.TimeLineEvent"
local M = setmetatable({ aliases = { "Speak" } }, { __index = super })
M.__index = M

function M.new(scene, name, text)
    local self = setmetatable(super.new(scene, "ActorSpeakEvent"), M)
	self.name = name or error('Name required')
	self.text = text or error('Text required')
    return self
end

function M:fireOn()
	local scene = game.current()
	local currentScene = scene.scene
	
	if currentScene == self.scene then
		local actor = scene:getActor(self.name)

		if actor == nil then
			print("Actor not found "..self.name)
			return
		end

		local assetName = nil
		if actor ~= nil then
			assetName = actor.assetName
		end

		game.note((self.name or '???') .. ': ' .. self.text)
		
    	local dialogState = game.createStates.DialogGame.new(assetName, self.name, self.text)
    	game.push(dialogState, nil, game.stackTransitions.DialogIn)
    else
    	print("skipping dialog, not in scene " .. self.scene)
    end
end

function M:tostring()
	return '[' .. self.scene .. '] ' .. self.name .. ' says ' .. self.text
end

return M