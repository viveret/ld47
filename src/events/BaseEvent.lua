local M = {}
M.__index = M

function M.new()
    local self = setmetatable({
	}, M)
	return self
end

function M:fireOn()
end

return M