local M = {}

function M.fireOn(self, gs)
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
end

function M.new(scene, x, y, duration, hold) 
	local ret = { scene = scene, type = "ManualCameraEvent", x = x, y = y, duration = duration, hold = hold, fireOn = M.fireOn }

	return ret
end

return M