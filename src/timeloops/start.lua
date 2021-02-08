local super = TimeLoop
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new(game, name)
    local self = setmetatable(super.new(game, name), M)
	return self
end



return M