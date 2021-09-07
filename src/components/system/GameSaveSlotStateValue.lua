local M = {}
M.__index = M
M.__file = __file__()

function M.new(key, parentState)
    return setmetatable({
        key = key or error("key is nil"),
        path = parentState.path .. "/" .. key .. ".save",
        parentState = parentState
    }, M)
end

function M:computeHash()
end

function M:readHash()
end

function M:save(data)
    if data == nil or (type(data) == "table" and #lume.keys(data) == 0) then
        if self:exists() then
            print("Deleting " .. self.path)
            lfs.remove(self.path)
            return
        end
    else
        print("Saving " .. self.path .. " (" .. type(data) .. "): " .. inspect(data))
        local serializedData = binser.serialize(data)
        --print("Create directory: " .. inspect(lfs.createDirectory(self.slotPath .. self.currentSlot)))
        lfs.write(self.path, serializedData)
        return
    end

    print("Nothing done for " .. self.path)
end

function M:load(default)
    if self:exists() then
        local serializedData = lfs.read(self.path)
        print("serializedData: " .. inspect(serializedData))
        local deserialized = unpack(binser.deserialize(serializedData))
        print("deserialized: " .. inspect(deserialized))
        return deserialized
    else
        print("load " .. self.path .. ": nil")
        return default or nil
    end
end

function M:exists()
    local r = lfs.getInfo(self.path, "file") ~= nil
    print("self.path -> " .. self.path)
    print("lfs.getInfo(self.path, \"file\") ~= nil -> " .. inspect(r))
    return r
end

return M