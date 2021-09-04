local M = {}

M.easings = {
    linear = function (v) return v end,
    square = function (v) return v * v end,
    easeInCubic = function (v) return v * v * v end,
    easeOutCubic = function (v) return 1 - pow(1 - v, 3) end,
    easeInOutCubic = function (v) if v < 0.5 then return 4 * v * v * v else return 1 - pow(-2 * v + 2, 3) / 2 end end,
    easeInSin = function (v) return 1 - cos((pi * v) / 2) end,
    easeOutSin = function (v) return sin((pi * v) / 2) end,
    easeInOutSin = function (v) return -(cos(pi * v) - 1) / 2 end,
}

function M.interpolateValues(a, b, v)
    local r = {}
    for k,av in pairs(a) do
        r[k] = lume.lerp(av, b[k], v)
    end
    return r
end


return M