function copy(src, dest, recursive)
    if dest == nil then
        dest = {}
    end

    for k,v in pairs(src) do
        if recursive and type(v) == "table" then
            dest[k] = copy(v, {}, recursive)
        else
            dest[k] = v
        end
    end

    return dest
end

function path2package(path)
    return path:sub(0, -#'.lua' - 1):gsub("%^/", ".")
end

function recursiveRequire(path, options)
    path = path:gsub('%.', '/')
    local tree = {}
    if options == nil then
        options = {}
    end
    
    for i, f in ipairs(love.filesystem.getDirectoryItems(path)) do
        local fpath = path .. '/' .. f
        if love.filesystem.getInfo(fpath, 'directory') then
            if f ~= '..' and f ~= '.' then
                tree[f] = recursiveRequire(fpath, options)
            end
        else love.filesystem.getInfo(fpath, 'file')
            if f:sub(-#'.lua') == '.lua' then
                local key = f:sub(0, -#'.lua' - 1)
                if options.suffixToRemove then
                    local keySuffix = key:sub(-#options.suffixToRemove)
                    if keySuffix == options.suffixToRemove then
                        local b4 = 'before: ' .. key
                        key = key:sub(0, #key - #options.suffixToRemove)
                        -- print('suffixToRemove: ' .. options.suffixToRemove .. ', ' .. b4 .. ', after: ' .. key)
                    end
                end
                tree[key] = require(path2package(fpath))
            end
        end
    end
    return tree
end

function recursiveAliasTypes(types, suffix, root)
    for k,t in pairs(types) do
        if suffix ~= nil then
            if k:match(suffix .. '$') then
                local key = k:sub(0, -#suffix - 1)
                root[key] = t
                types[key] = t
            end
        else
            root[k] = t
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

function requireAll(path)
    local tree = recursiveRequire(path)
    local root = {}

    recursiveAliasTypes(tree, nil, root)

    return root
end

function __file__()
    return debug.getinfo(2, "S").source:sub(2)
end

function donothing()
end



function graphTransform(data, fn, backtrace)
    local t = type(data)
    if t == 'table' then
        if backtrace == nil then
            backtrace = { data }
        elseif lume.find(backtrace, data) ~= nil then
            return data
        else
            table.insert(backtrace, data)
        end

        local transformed = {}
        if data[1] == nil then -- can assume is object
            for k,v in pairs(data) do
                transformed[k] = graphTransform(v, fn, backtrace)
            end
        else -- is array
            for k,v in pairs(data) do
                table.insert(transformed, graphTransform(v, fn, backtrace))
            end
        end
        return transformed
    else
        return fn(data)
    end
end

function ParseFilename(path)
    for k, v in string.gmatch(path, "(%w+)([/.])%w+$") do
        if v == '.' then
            return k
        end
    end
end

function arraysAreEqual(a, b, fn)
    if fn == nil then
        fn = function(a, b) return a == b end
    end

    if a == nil or b == nil or #a ~= #b then
        return false
    end

    for i = 1, #a do
        local r = fn(a[i], b[i])
        if r == false then
            return false
        end
    end

    return true
end

function trycatch(tryfn, catchfn, finallyfn)
    local status, ex, ret = xpcall(tryfn, debug.traceback)
    if not status and catchfn ~= nil then
        catchfn(ex)
    end
    if finallyfn ~= nil then
        finallyfn(ex)
    end
    return ret
end


function debugtrycatch(isDebuging, tryfn, catchfn, finallyfn)
    local ret = nil
    if isDebuging then
        local status, ex, r = xpcall(tryfn, debug.traceback)
        ret = r
        if not status then
            print(ex)
            if catchfn ~= nil then
                catchfn(ex)
            end
        end
    else
        tryfn()
    end

    if finallyfn ~= nil then
        finallyfn(ex)
    end

    return ret
end


function simplify(tbl, depth)
    local ret = {}
    for k,v in pairs(tbl) do
        if type(v) ~= 'function' then
            if type(v) ~= 'table' then
                ret[k] = v
            elseif depth == nil then
                ret[k] = simplify(v, 3)
            elseif depth > 0 then
                ret[k] = simplify(v, depth - 1)
            end
        end
    end
    return ret
end

function extendMissingKeysOrError(dest, tbl)
    if type(dest) ~= "table" then
        error("Type of dest was not table (was " .. type(dest) .. ")")
    elseif type(tbl) ~= "table" then
        error("Type of tbl was not table (was " .. type(tbl) .. ")")
    end

    local keysThatAreForbidden = lume.keys(dest)
    local isForbiddenKey = function(e)
        return lume.find(keysThatAreForbidden, e) ~= nil
    end
    local invalidKeys = lume.match(lume.keys(tbl), isForbiddenKey) or {}

    if #invalidKeys == 0 then
        return lume.extend(dest, tbl)
    else
        error("Invalid keys that were forbidden: " .. inspect(invalidKeys))
    end
end