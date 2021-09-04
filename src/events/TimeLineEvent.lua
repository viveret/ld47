local super = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M:fireOn()
	local scene = game.current().scene

	if scene == self.scene then
        self:fireWhenInScene()
    else
        self:fireWhenOutOfScene()
    end
    return true
end

function M:fireWhenInScene()
end

function M:fireWhenOutOfScene()
end

function M.new(scene, type)
    if scene == nil or scene == '' then
        error('scene cannot be nil or empty')
    end
    local self = setmetatable(super.new(type), M)
	self.scene = scene
	return self
end

return M