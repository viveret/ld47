local M = {}
M.__index = M
M.__file = __file__()

local cachedImageData = {}
local cachedFonts = {}
local cachedImages = {}

local fontEnding = '-font.png'

--local filename2key = ParseFilename
local filename2key = function(filename)
	return filename:gsub('/', '_')
end

local cachedNewImageData = function(filename)
	local key = filename2key(filename)
	local cached = cachedImageData[key]
	if cached == nil then
		local fileExt = filename:sub(-#fontEnding)
		if fileExt == fontEnding then
			cached = lg.newImageFont(
				filename,
				" abcdefghijklmnopqrstuvwxyz"..
				"ABCDEFGHIJKLMNOPQRSTUVWXYZ0"..
				"123456789.,!?-+/():;%&`'*#=[]\""
			)
			cachedFonts[key] = cached
		else
			cached = love.image.newImageData(filename)
			cachedImageData[key] = cached
		end
	end
	return cached
end

local cachedNewImage = function(filename)
	local key = filename2key(filename)
	local cached = cachedImages[key]
	if cached == nil then
		local cachedData = cachedImageData[key]
		if cachedData ~= nil then
			cached = lg.newImage(cachedData)
		else
			cached = cachedFonts[key]
		end
		cachedImages[key] = cached
	end
	
	return cached
end

function M.new()
    lg.setDefaultFilter('linear', 'linear')
	local imageDataCache = graphTransform(game.strings.images, cachedNewImageData)
	local imagesCache = graphTransform(game.strings.images, cachedNewImage)
    local self = setmetatable(lume.extend({ imageData = imageDataCache }, imagesCache), M)
	return self
end

function M:getImageData(path)
	local key = filename2key(path)
	return cachedImageData[key]
end

function M:getImage(path)
	local key = filename2key(path)
	return cachedImages[key]
end

function M:getImageDataFromImage(image)
	local key = lume.find(cachedImages, image)
	return cachedImageData[key]
end

return M