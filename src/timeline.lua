local M = { }

-- time!
--  1 tick = 1/60 of a real time second
--  60 ticks = 1 real time second
--  1 in game hour = 1.3 real time minutes
--  1 in game hour = (1.3 real time minutes * 60 real time seconds) * 60 ticks = 4680 ticks

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

		if line == nil or line == '' or line:sub(1, 2) == '--' then
			-- comments, skip em
		else
	    	local scene, timeRaw, flagsRaw, actionRaw = line:match("^%s*(.-),%s*(.-),%s*(.-),%s*(.-)$")
			
			local action = parseAction(scene, actionRaw)
			local time = tonumber(timeRaw)
			local flags = {}
			for flag in flagsRaw:gmatch("([^\\|]+):?") do 
				table.insert(flags, flag)
			end

	    	data[#data + 1] = { scene = scene, time = time, flags = flags, action = action }
	    end
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
--   2. AssertName
--   2. X
--   3. Y
--   4. callback name (optional) [comes from actorCallback.lua]
-- Move
--   1. Name
--   2. ToX
--   3. ToY
--   4. Speed
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
-- ManualCamera
--   1. X
--   2. Y
--   3. Duration (time to span there and back)
--   4. Hold (time to just look at the X,Y)
function parseAction(scene, raw)
	local parts = {}
	for part in string.gmatch(raw, "[^\\|]+") do
		table.insert(parts, part)
	end

	local type = parts[1];

	if type == "Spawn" then
		local name = parts[2]
		local assetName = parts[3]
		local x = tonumber(parts[4])
		local y = tonumber(parts[5])

		local callbackName = parts[6]
		local callback = nil

		if callbackName ~= nil then
			callback = actorCallbacks[callbackName]
			if callback == nil then
				error("could find actorCallbacks."..callbackName)
			end
		end

		return ActorSpawnEvent.new(scene, name, assetName, x, y, callback)
	elseif type == "Move" then
		local name = parts[2]
		local toX = tonumber(parts[3])
		local toY = tonumber(parts[4])
		local speed = tonumber(parts[5])

		return ActorMoveEvent.new(scene, name, toX, toY, speed)
	elseif type == "Despawn" then
		local name = parts[2]

		return ActorDespawnEvent.new(scene, name)
	elseif type == "Speak" then
		local name = parts[2]
		local text = parts[3]

		return ActorSpeakEvent.new(scene, name, text)
	elseif type == "PlaySound" then
		local path = parts[2]

		return PlaySoundEvent.new(scene, path)
	elseif type == "RoomText" then
		local text = parts[2]

		return RoomTextEvent.new(scene, text)
	elseif type == "ToggleFlag" then
		local flagName = parts[2]

		return ToggleFlagEvent.new(scene, flagName)
	elseif type == "ManualCamera" then
		local x = tonumber(parts[2])
		local y = tonumber(parts[3])
		local duration = tonumber(parts[4])
		local hold = tonumber(parts[5])
		
		return ManualCameraEvent.new(scene, x, y, duration, hold)
	elseif type == "GameOver" then
		return GameOverEvent.new()
	elseif type == "GlobalAmbientColor" then
		local r = tonumber(parts[2])
		local g = tonumber(parts[3])
		local b = tonumber(parts[4])
		return GlobalAmbientColorEvent.new(r, g, b)
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
function M.lookup(timeline, scene, atTime)
	local ret = {}
	for ix, entry in ipairs(timeline) do
		local isValid = entry.scene == scene and atTime <= entry.time

		if isValid then
			ret[#ret + 1] = entry
		end
	end

	return ret
end

-- gets the next event that is scheduled to happen
function M.nextEvent(timeline, currentTime, flags)
	local row = nil

	for ix, entry in ipairs(timeline) do
		local stillValid = currentTime < entry.time

		if stillValid then 
			for iy, flag in ipairs(entry.flags) do
				local hasFlag = false

				for ij, setFlag in ipairs(flags) do
					if setFlag == flag then
						hasFlag = true
						break
					end
				end

				if not hasFlag then
					stillValid = false
					break
				end
			end
		end

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