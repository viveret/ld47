local M = {}
M.__index = M

function M.new(game, datetime)
    local self = setmetatable({
        game = game,
        datetime = datetime,
	}, M)
	return self
end

function M:update(dt)
end

return M