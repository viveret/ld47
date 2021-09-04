local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({ aliases = { "SetSave" } }, { __index = BaseEvent })
M.__index = M
M.__file = __file__()

function M.new(path, data)
    local self = setmetatable(lume.extend(BaseEvent.new("SetSaveData"), {
        path = path,
        data = data,
    }), M)
    return self
end

function M:fireOn(gs)
    local data = binser.deserialize(self.data)
    print(self:tostring())
    game.saveData[self.path] = data
    return true
end

function M:tostring()
    local asString = ''
    if type(data) == 'string' then
        asString = data
    else
        asString = inspect(data)
    end
	return 'Saving ' .. self.path .. ': ' .. asString
end

return M