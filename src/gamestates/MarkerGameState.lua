local super = require "src.gamestates.BaseGameState"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new(scene)
    return setmetatable(lume.extend({}, super.new(scene)), M)
end

return M