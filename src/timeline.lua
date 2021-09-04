local M = { }
M.__index = M

-- timeline is a table of "scene name" -> "timeline"
--
-- timeline is a sequence of entries
--   { time: <DateTime>, flags: <table of names>, action: <see parseAction> }
--
-- file is a CSV, format is
--   Scene,Time,Flags,Action
--
-- a row might look like
--   Home,1/1/2000 9:35:0-0,Hello|SecondLoop,Something something something something
function M.new()
	local lines = lfs.lines(game.strings.paths.timeline)
	local items = {}
	local lineNo = 1
	local skippingLines = false
	for line in lines do
		if line == nil or line == '' or (not skippingLines and line:sub(1, 2) == '--') then
			if line:sub(3, 5) == '[[' then
				skippingLines = true
			end
		elseif skippingLines then
			if line == '--]]' then
				skippingLines = false
			end
		else
			parseLine(items, lineNo, line)
		end
		lineNo = lineNo + 1
	end

	return setmetatable({
		items = items
	}, M)
end

function parseLine(data, lineNo, line)
	local scene, timeRaw, flagsRaw, actionRaw = line:match("^%s*(.-),%s*(.-),%s*(.-),%s*(.-)$")
	--print('scene: ' .. scene .. ', timeRaw: ' .. timeRaw .. ', flagsRaw: ' .. flagsRaw .. ', actionRaw: ' .. actionRaw)
	
	local action = parseAction(scene or error('Missing scene'), actionRaw) or error('Missing action')
	local time = DateTime.new(timeRaw or error('Missing time'), true)
	if time == nil then
		error ('Invalid time at line ' .. lineNo)
	end

	local flags = {}
	if flagsRaw ~= nil and flagsRaw ~= '' then
		for flag in flagsRaw:gmatch("([^\\|]+):?") do 
			table.insert(flags, flag)
		end
	end

	table.insert(data, { scene = scene, time = time, flags = flags, action = action })
end

function parseAction(scene, raw)
	local parts = {}
	for part in string.gmatch(raw, "[^\\|]+") do
		table.insert(parts, part)
	end

	local typeName = parts[1] or error('Missing event type');
	parts[1] = scene

	-- local type = events[typeName] or error('Could not find event type ' .. typeName);
	-- return type.new(unpack(parts)) or error('Could not create ' .. typeName)

	local type = events[typeName] or events[typeName .. 'Event'] or error('Could not find event type ' .. typeName);
	return type.new(unpack(parts)) or error('Could not create ' .. typeName)
end

-- gets the next event that is scheduled to happen
function M:nextEvent(earliest, latest)
	if earliest == nil then
		error('missing earliest')
	elseif latest == nil then
		error('missing latest')
	end

	local row = nil
	for ix, entry in pairs(self.items) do
		local stillValid = entry.time:isBetween(earliest, latest) and game.hasFlags(entry.flags)
		if stillValid then
			if row == nil then
				--print('is ' .. entry.time:tostring() .. ' between ' .. earliest:tostring() .. ' and ' .. latest:tostring() .. '? ' .. tostring(stillValid))
				row = { entry }
			elseif lume.first(row).time:greaterThan(entry.time) then
				--print('is ' .. entry.time:tostring() .. ' between ' .. earliest:tostring() .. ' and ' .. latest:tostring() .. '? ' .. tostring(stillValid))
				row = { entry }
				latest = entry.time
			elseif lume.first(row).time:equals(entry.time) then
				--print('is ' .. entry.time:tostring() .. ' between ' .. earliest:tostring() .. ' and ' .. latest:tostring() .. '? ' .. tostring(stillValid))
				table.insert(row, entry)
			end
		end
	end

	return row
end

return M