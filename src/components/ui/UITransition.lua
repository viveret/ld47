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
    print('hi')
end

return M