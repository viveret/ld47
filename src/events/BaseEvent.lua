local M = {}
M.__index = M

function M.new(type)
    local self = setmetatable({
		type = type
	}, M)
	return self
end

function M:fireOn()
end

function M:tostring()
	if self.type == nil then
		return "no type"
	else
		return self.type
	end
end

return M