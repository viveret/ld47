local M = {}
M.__index = M
M.__file = __file__()

function M.new(easingFunc, args, promise)
    local self = setmetatable(lume.extend({
        elapsedTime = 0,
        easingFunc = easingFunc,
        promise = promise,
	}, args), M)
	return self
end

function M:update(dt)
    if self.completed ~= true then
        self.elapsedTime = self.elapsedTime + dt
        if self.elapsedTime >= self.duration then
            self.elapsedTime = self.duration
            self.completed = true
            self.promise:resolve(self)
        end
    end
end

return M