local M = {}

function M.fireOn(self, gs)
	local currentGS = gs:current()

    if not currentGS.isPhysicalGameState then
        print("Current state has no cameras")
        return
    end

    local currentCamera = currentGS:currentCamera()

    local newCamera = ManualCamera.new(gs, currentGS, currentCamera, self.x, self.y, self.duration, self.hold)

    currentGS:pushCamera(newCamera)
end

function M.new(x, y, duration, hold) 
	local ret = { type = "ManualCameraEvent", x = x, y = y, duration = duration, hold = hold, fireOn = M.fireOn }

	return ret
end

return M