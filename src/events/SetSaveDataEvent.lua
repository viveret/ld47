local BaseEvent = require "src.events.BaseEvent"
local M = setmetatable({ aliases = { "SetSave" } }, { __index = BaseEvent })
M.__index = M

function M.new(path, data) -- r, g, b
    local self = setmetatable(lume.extend(BaseEvent.new("SetSaveData"), {
        path = path,
        data = data,
    }), M)
    -- self.r = r;
    -- self.g = g;
    -- self.b = b;
    return self
end

function M:fireOn(gs)
    local data = binser.deserialize(self.data)
    print(self:tostring())
    game.saveData[self.path] = data
    -- gs.saveData.globalAmbientColor = self
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