local _constants = {
    minutesPerHour = 60,
    secondsPerMinute = 60,
    hoursPerDay = 24,
    monthsPerYear = 12,
    daysPerYear = 365,
    ticksPerMS = 50,
    daysPerMonth = {
        31,
        28,
        31,
        30,
        31,
        30,
        31,
        31,
        30,
        31,
        30,
        31,
    },
    month2name = {
        "January",
        "Febuary",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
    },
    day2suffix = {
        "1st",
        "2nd",
        "3rd",
        "4th",
        "5th",
        "6th",
        "7th",
        "8th",
        "9th",
        "10th",
        "11th",
        "12th",
        "13th",
        "14th",
        "15th",
        "16th",
        "17th",
        "18th",
        "19th",
        "20th",
        "21st",
        "22nd",
        "23rd",
        "24th",
        "25th",
        "26th",
        "27th",
        "28th",
        "29th",
        "30th",
        "31st",
    },
    initial = {
        year = 2000,
        month = 1,
        day = 1,
        hour = 8,
        minute = 0,
        second = 0,
        ms = 0,
    },
}

_constants.secondsPerHour = _constants.secondsPerMinute * _constants.minutesPerHour
_constants.secondsPerDay = _constants.secondsPerHour * _constants.hoursPerDay

local M = {}
M.__index = M

function M.new(str, ticksInSecondsOrMs)
    if str == nil then
        error ('str is nil')
    end

    local self = setmetatable(lume.extend({}, _constants.initial), M)

    local ticks = tonumber(str)
    if ticks ~= nil then
        error ('ticks not supported')
    elseif type(str) == 'string' then
        local a, b, c, d, e, f, g = str:match("^(%d+)/(%d+)/(%d+)%s+(%d+):(%d+):(%d+)-(%d+)$")
        self.month = tonumber(a) or error('Missing month')
        self.day = tonumber(b) or error('Missing day')
        self.year = tonumber(c) or error('Missing year')
        self.hour = tonumber(d) or error('Missing hour')
        self.minute = tonumber(e) or error('Missing minute')
        self.second = tonumber(f) or error('Missing second')
        self.ms = tonumber(g) or error('Missing ms')
    elseif type(str) == 'table' then
        lume.extend(self, str)
    else
        error('Invalid type for DateTime: ' .. type(str))
    end

	return self
end

function M:dateShort()
    return string.format("%d/%d/%s", self.month, self.day, self:yearToString())
end

function M:tostring()
    return string.format("%s %s, %s  %02d:%02d:%02d-%0004d", self:monthShort(), self:daySuffix(), self:yearToString(), self.hour, self.minute, self.second, self.ms)
end

function M:tostringLong()
    return string.format("%s %s, %s  %d:%d:%d-%d", self:monthLong(), self:daySuffix(), self:yearToString(), self.hour, self.minute, self.second, self.ms)
end

function M:daySuffix()
    return _constants.day2suffix[self.day]
end

function M:monthShort()
    return _constants.month2name[self.month] -- substring 3
end

function M:monthLong()
    return _constants.month2name[self.month]
end

function M:timeShort()
    local amOrPm = "AM"
    local hour = self.hour
    local halfHoursPerDay = _constants.hoursPerDay / 2
    if hour >= halfHoursPerDay and hour <= _constants.hoursPerDay then
        if hour > halfHoursPerDay then
            hour = hour - halfHoursPerDay
        end
        amOrPm = "PM"
    end
    local friendlyTime = hour .. ":"

    return friendlyTime .. string.format("%02d", self.minute) .. " " .. amOrPm 
end

function M:yearToString()
    if self.year >= 0 then
        return self.year
    else
        return abs(self.year) .. ' B.C.E.'
    end
end

function M:tick(ticks)
    self.ms = self.ms + _constants.ticksPerMS * (ticks or 1)
    
    while self.ms >= 1000 * _constants.secondsPerMinute do
        self:tickMinute()
        self.ms = self.ms - 1000 * _constants.secondsPerMinute
    end

    while self.ms >= 1000 do
        self:tickSecond()
        self.ms = self.ms - 1000
    end
end

function M:tickSecond()
    if self.second == _constants.secondsPerMinute then
        self:tickMinute()
        self.second = 0
    else
        self.second = self.second + 1
    end
end

function M:tickMinute()
    if self.minute == _constants.minutesPerHour then
        self:tickHour()
        self.minute = 0
    else
        self.minute = self.minute + 1
    end
end

function M:tickHour()
    if self.hour == _constants.hoursPerDay then
        self:tickDay()
        self.hour = 1
    else
        self.hour = self.hour + 1
    end
end

function M:tickDay()
    if self.day == _constants.daysPerMonth[self.month] then
        self:tickMonth()
        self.day = 1
    else
        self.day = self.day + 1
    end
end

function M:tickMonth()
    if self.month == _constants.monthsPerYear then
        self:tickYear()
        self.month = 1
    else
        self.month = self.month + 1
    end
end

function M:tickYear()
    self.year = self.year + 1
end

function M:getAtMidnight()
    return lume.extend(M.new(self), {
        hour = 23,
        minute = 59,
        second = 59,
        ms = 999,
    })
end

function M:addTick()
    local ret = M.new(self)
    ret:tick()
    return ret
end

function M:addMS()
    local ret = M.new(self)
    ret:tick(_constants.ticksPerMS)
    return ret
end

function M:normalizedTimeOfDay24()
    return (self.hour - 1 + (self.minute - 1 + ((self.second - 1) / 60) / 60) / 60) / 24
end

function M:normalizedTimeOfDay12()
    local hour = self.hour + 1
    if hour > 12 then
        hour = hour - 12
    end
    return (hour - 1 + (self.minute - 1 + ((self.second - 1) / 60) / 60) / 60) / 12
end

function M:isBetween(earliest, latest)
    return self:greaterThanOrEqualTo(earliest) and self:lessThan(latest)
end

function M:lessThan(other)
    if other == nil then
        error ('other is nil')
    elseif self.year < other.year then
        return true
    elseif self.year > other.year then
        return false
    elseif self.month < other.month then
        return true
    elseif self.month > other.month then
        return false
    elseif self.day < other.day then
        return true
    elseif self.day > other.day then
        return false
    elseif self.hour < other.hour then
        return true
    elseif self.hour > other.hour then
        return false
    elseif self.minute < other.minute then
        return true
    elseif self.minute > other.minute then
        return false
    elseif self.second < other.second then
        return true
    elseif self.second > other.second then
        return false
    elseif self.ms < other.ms then
        return true
    elseif self.ms > other.ms then
        return false
    else
        return false
    end
end

function M:lessThanOrEqualTo(other)
    if other == nil then
        error ('other is nil')
    elseif self.year < other.year then
        return true
    elseif self.year > other.year then
        return false
    elseif self.month < other.month then
        return true
    elseif self.month > other.month then
        return false
    elseif self.day < other.day then
        return true
    elseif self.day > other.day then
        return false
    elseif self.hour < other.hour then
        return true
    elseif self.hour > other.hour then
        return false
    elseif self.minute < other.minute then
        return true
    elseif self.minute > other.minute then
        return false
    elseif self.second < other.second then
        return true
    elseif self.second > other.second then
        return false
    elseif self.ms < other.ms then
        return true
    elseif self.ms > other.ms then
        return false
    else
        return true
    end
end

function M:greaterThanOrEqualTo(other)
    if other == nil then
        error ('other is nil')
    elseif self.year > other.year then
        return true
    elseif self.year < other.year then
        return false
    elseif self.month > other.month then
        return true
    elseif self.month < other.month then
        return false
    elseif self.day > other.day then
        return true
    elseif self.day < other.day then
        return false
    elseif self.hour > other.hour then
        return true
    elseif self.hour < other.hour then
        return false
    elseif self.minute > other.minute then
        return true
    elseif self.minute < other.minute then
        return false
    elseif self.second > other.second then
        return true
    elseif self.second < other.second then
        return false
    elseif self.ms > other.ms then
        return true
    elseif self.ms < other.ms then
        return false
    else
        return true
    end
end

function M:greaterThan(other)
    if other == nil then
        error ('other is nil')
    elseif self.year > other.year then
        return true
    elseif self.year < other.year then
        return false
    elseif self.month > other.month then
        return true
    elseif self.month < other.month then
        return false
    elseif self.day > other.day then
        return true
    elseif self.day < other.day then
        return false
    elseif self.hour > other.hour then
        return true
    elseif self.hour < other.hour then
        return false
    elseif self.minute > other.minute then
        return true
    elseif self.minute < other.minute then
        return false
    elseif self.second > other.second then
        return true
    elseif self.second < other.second then
        return false
    elseif self.ms > other.ms then
        return true
    elseif self.ms < other.ms then
        return false
    else
        return false
    end
end

function M:equals(other)
    if other == nil then
        return false
    elseif self.year ~= other.year then
        return false
    elseif self.month ~= other.month then
        return false
    elseif self.day ~= other.day then
        return false
    elseif self.hour ~= other.hour then
        return false
    elseif self.minute ~= other.minute then
        return false
    elseif self.second ~= other.second then
        return false
    elseif self.ms ~= other.ms then
        return false
    else
        return true
    end
end

return M