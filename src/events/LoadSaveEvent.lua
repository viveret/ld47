local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({}, { __index = BaseEvent })
M.__index = M

function M.new(saveData)
    return setmetatable(lume.extend(BaseEvent.new("LoadSave"), saveData), M)
end

function M:fireOn(gs)
    print('Loading ' .. self.name)
    --gs.warpTo('loadgame')
end

return M