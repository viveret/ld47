local M = { }

-- timeline is a table of "scene name" -> "timeline"
--
-- timeline is a sequence of entries
--   { time: <long ticks>, flags: <table of names>, action: <see parseAction> }
--
-- file is a CSV, format is
--   Scene,Time,Flags,Action
--
-- a row might look like
--   Home,110,Hello|SecondLoop,Something something something something
function M.load(lines) 
	local data = {}
	for line in lines do

    	local scene, timeRaw, flagsRaw, actionRaw = line:match("^%s*(.-),%s*(.-),%s*(.-),%s*(.-)$")
		
		local action = parseAction(actionRaw)
		local time = tonumber(timeRaw)
		local flags = {}
		for flag in flagsRaw:gmatch("([^\\|]+):?") do 
			flags[flag] = true
		end

    	data[#data + 1] = { scene = scene, time = time, flags = flags, action = action }
	end

	return data
end

-- Kinds of actions
--   actor spawns
--   actor moves somewhere
--   actor despawns
--   actor speak
--   room text
-- 
-- format is <type>|<parameter #1>|<parameter #2> ...
--
-- Spawn
--   1. Name
--   2. X
--   3. Y
-- Move
--   1. Name
--   2. ToX
--   3. ToY
-- Despawn
--   1. Name
-- Speak
--   1. Name
--   2. Text
-- Sound
--   1. Path to sound file  
-- RoomText
--   1. Text
-- ToggleFlag
--   1. FlagName
function parseAction(raw)
	local parts = {}
	for part in string.gmatch(raw, "[^\\|]+") do
		table.insert(parts, part)
	end

	local type = parts[1];

	if type == "Spawn" then
		local name = parts[2]
		local x = tonumber(parts[3])
		local y = tonumber(parts[4])

		return ActorSpawnEvent.new(name, x, y)
	elseif type == "Move" then
		local name = parts[2]
		local toX = tonumber(parts[3])
		local toY = tonumber(parts[4])

		return ActorMoveEvent.new(name, toX, toY)
	elseif type == "Despawn" then
		local name = parts[2]

		return ActorDespawnEvent.new(name)
	elseif type == "Speak" then
		local name = parts[2]
		local text = parts[3]

		return ActorSpeakEvent.new(name, text)
	elseif type == "PlaySound" then
		local path = parts[2]

		return PlaySoundEvent.new(path)
	elseif type == "RoomText" then
		local text = parts[2]

		return RoomTextEvent.new(text)
	elseif type == "ToggleFlag" then
		local flagName = parts[2]

		return ToggleFlagEvent.new(flagName)
	else 
		error("Unexpected type:"..type)
	end 
end

-- get a subset of the timeline that applies:
--   to the given scene
--   starting from the given time
--   if the given flags are set
--
-- returns a new Timeline
function M.lookup(timeline, scene, atTime, flags)
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
function M.nextEvent(timeline, currentTime)
	local row = nil

	for ix, entry in ipairs(timeline) do
		local stillValid = currentTime < entry.time

		if stillValid then
			if row == nil or row.time > entry.time then
				row = entry
			end 
		end
	end

	if row == nil then
		return nil
	end

	local ret = { time = row.time, action = row.action }

	return ret
end

return M