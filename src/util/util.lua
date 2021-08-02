

function recursiveRequire(path)
    local tree = {}
    for i, f in ipairs(love.filesystem.getDirectoryItems(path)) do
        local fpath = path .. '/' .. f
        if love.filesystem.getInfo(fpath, 'directory') then
            if f ~= '..' and f ~= '.' then
                tree[f] = recursiveRequire(fpath)
            end
        else love.filesystem.getInfo(fpath, 'file')
            if f:sub(-#'.lua') == '.lua' then
                local key = f:sub(0, -#'.lua' - 1)
                tree[key] = require(fpath:sub(0, -#'.lua' - 1):gsub("%^/", "."))
            end
        end
    end
    return tree
end


function recursiveAliasTypes(types, suffix, root)
    for k,t in pairs(types) do
        if k:match(suffix .. '$') then
            local key = k:sub(0, -#suffix - 1)
            root[key] = t
            types[key] = t
        end

        if t.aliases then
            for i,alias in pairs(t.aliases) do
                root[alias] = t
                types[alias] = t
            end
        end

        if not t.__index then
            recursiveAliasTypes(t, suffix, root)
        end
    end    
end



function donothing()
end



function interpolateValues(a, b, v)
    local r = {}
    for k,av in pairs(a) do
        r[k] = lume.lerp(av, b[k], v)
    end
    return r
end

