local _constants = {
    
}

local M = {}
M.__index = M

function M.new(str, g, b)
    if str == nil then
        error ('str is nil')
    end

    local self = setmetatable(lume.extend({}, _constants.initial), M)

    local raw = tonumber(str)
    if raw ~= nil then
        local green = tonumber(g)
        local blue = tonumber(b)
        if green ~= nil and blue ~= nil then
            self.r = raw
            self.g = green
            self.b = blue
        else
            error ('raw not supported')
        end
    elseif type(str) == 'string' then
        error ('string not supported')
    elseif type(str) == 'table' then
        lume.extend(self, str)
    else
        error('Invalid type for DateTime: ' .. type(str))
    end

	return self
end

function M:tostring()
    return string.format("%f,%f,%f", self.r, self.g, self.b)
end

return M