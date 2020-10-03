-- timeline is a table of "scene name" -> "timeline"
--
-- timeline is a sequence of entries
--   { time: <long ticks>, flags: <table of names>, action: <object> }
--
-- 
-- different objects are ...
--   todo
--
-- file is a CSV, format is
--   Scene,Time,Flags,Action
--
-- a row might look like
--   Home,110,Hello|SecondLoop,Something something something something
function Timeline_load(lines) 
	local data = {}
	for line in lines do
    	local scene, timeRaw, flagsRaw, actionRaw = line:match("^%s*(.-),%s*(.-),%s*(.-),%s*(.-)$")

		local action = Timeline_parseAction(actionRaw)
		local time = tonumber(timeRaw)
		local flags = {}
		for flag in flagsRaw:gmatch("([^\\|]+):?") do 
			flags[flag] = true
		end

    	data[#data + 1] = { scene = scene, time = time, flags = flags, action = action }
	end

	return data
end

-- todo
function Timeline_parseAction(raw)
	return { actionType = "foo" }
end

-- get a subset of the timeline that applies:
--   to the given scene
--   starting from the given time
--   if the given flags are set
--
-- returns a new Timeline
function Timeline_lookup(timeline, scene, atTime, flags)
	local ret = {}
	for ix, entry in ipairs(timeline) do
		local isValid = entry.scene == scene and atTime <= entry.time


		if isValid then 
			for iy, flag in ipairs(entry.flags) do
				local hasFlag = flags[flag]

				if not hasFlag then
					isValid = false
					break
				end
			end
		end
		
		if isValid then
			ret[#ret + 1] = entry
		end
	end

	return ret
end

-- gets the next event that is scheduled to happen
function Timeline_nextEvent(timeline, currentTime)
	local row = nil

	for ix, entry in ipairs(timeline) do
		local stillValid = currentTime <= entry.time

		if stillValid then
			if row == nil or row.time > entry.time then
				row = entry
			end 
		end
	end

	local ret = { time = row.time, action = row.action }

	return ret
end