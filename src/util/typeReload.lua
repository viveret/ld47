local M = {}


function M.reloadWithinObject(data)
    if data.__index ~= nil then
        local newType = M.reloadType(data.__index)
        -- print(inspect(newType))
        setmetatable(data, newType)
        data:onTypeReloaded()
    else
        error("data.__index was nil")
    end
end

function M.reloadType(__index)
    if type(__index) == "table" then
        if __index.__file == nil then
            error("type(__index.__file) was nil")
        elseif type(__index.__file) == "string" then
            return M.reloadValidType(__index)
        else
            error("type(__index.__file) was not string")
        end
    else
        error("type(__index) was not table")
    end
end

function M.reloadValidType(__index)
    local packageName = path2package(__index.__file)
    local oldType = package.loaded[packageName]

    package.loaded[packageName] = nil
    local new__index = require(packageName)
    if new__index then
        return new__index
    else
        error("new__index after reload not a type or not true (was " .. inspect(new__index) .. ")")
    end
end


return M