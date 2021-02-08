local M = {}
M.__index = M

function M.new(str)
    local self = setmetatable({
        years = 0,
        months = 0,
        days = 0,
        hours = 0,
        minutes = 0,
        seconds = 0,
        mss = 0,
    }, M)

    local ticks = tonumber(str)
    if ticks ~= nil then
        error('not implemented')
        -- self.year = floor(ticks / self._constants.ticksPerYear)
        --self.month = ((floor(ticks / self._constants.ticksPerMonth) - 1) % self._constants.monthsPerYear) + 1
        --self.day = ((floor(ticks / self._constants.ticksPerDay) - 1) % self.)_lookups.daysPerMonth[self.month]) + 1
    else
        local a, b, c, d, e, f, g = str:match("^%d+ years, %d+ months, %d+ days(, %d+:%d+:%d+(-%d+)?$)?")
        print('a: ' .. a)
        print('b: ' .. b)
        print('c: ' .. c)
        print('d: ' .. d)
        print('e: ' .. e)
        print('f: ' .. f)
        print('g: ' .. g)
    end

	return self
end

function M:tostring()
    return string.format("%d years, %d months, %d days, %d:%d:%d-%d", self.years, self.months, self.days, self.hours, self.minutes, self.seconds, self.mss)
end

return M