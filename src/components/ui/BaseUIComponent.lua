local M = {}
M.__index = M

function M.new(type)
    local self = setmetatable({
        type = type or "generic ui component",
        w = 0,
        h = 0,
	}, M)
	return self
end

function M:draw()
    error ('not implemented')
end

function M:update(dt)
end

function M:load()
end

function M:save()
end

function M:activated()
end

function M:tostring()
    return self.type
end

function M:keypressed( key, scancode, isrepeat )
end

function M:keyreleased( key, scancode )
end

function M:getWidth()
    return self.w
end

function M:getHeight()
    return self.h
end

return M