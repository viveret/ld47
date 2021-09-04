local super = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new(saveData)
    return setmetatable(lume.extend(super.new("LoadSave"), saveData), M)
end

function M:fireOn(gs)
    print('Loading ' .. self.name)
    --game.warpTo('loadgame')
end

return M