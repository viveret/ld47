local cron = {}

-- Based on https://en.wikipedia.org/wiki/Cron

-- # ┌───────────── second (0 - 59)
-- # │ ┌───────────── minute (0 - 59)
-- # │ │ ┌───────────── hour (0 - 23)
-- # │ │ │ ┌───────────── day of the month (1 - 31)
-- # │ │ │ │
-- # │ │ │ │
-- # │ │ │ │
-- # │ │ │ │
-- # * * * * <command to execute>
function cron.once(s, m, h, d, fn)
    
end

-- # ┌───────────── second (0 - 59)
-- # │ ┌───────────── minute (0 - 59)
-- # │ │ ┌───────────── hour (0 - 23)
-- # │ │ │ ┌───────────── day of the month (1 - 31)
-- # │ │ │ │
-- # │ │ │ │
-- # │ │ │ │
-- # │ │ │ │
-- # * * * * <command to execute>
function cron.every(s, m, h, d, fn)
    
end





return cron