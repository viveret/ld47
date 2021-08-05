
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



function donothing()
end



function interpolateValues(a, b, v)
    local r = {}
    for k,av in pairs(a) do
        r[k] = lume.lerp(av, b[k], v)
    end
    return r
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