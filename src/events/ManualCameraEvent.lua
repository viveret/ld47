local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = BaseEvent })
M.__index = M
M.__file = __file__()

function M:fireOn(gs)
	local currentGS = gs:current()

    if currentGS.name ~= self.scene then
        print("Skipping manual camera, not in scene")
        return
    end

    if not currentGS.isPhysicalGameState then
        print("Current state has no cameras")
        return
    end

    local currentCamera = currentGS:currentCamera()

    local newCamera = ManualCamera.new(gs, currentGS, currentCamera, self.x, self.y, self.duration, self.hold)

    currentGS:pushCamera(newCamera)
    return true
end

function M.new(scene, x, y, duration, hold)
    local self = setmetatable(BaseEvent.new(), M)
    self.scene = scene
    self.type = "ManualCameraEvent"
    self.x = x
    self.y = y
    self.duration = duration
    self.hold = hold
	return self
end

return M