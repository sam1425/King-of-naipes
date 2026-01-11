local fonts = {}
local fontSize = 32
fontIndex = 1
local currentFont = nil
local files = love.filesystem.getDirectoryItems("Fonts")
for _, file in ipairs(files) do
	if file:match("%.ttf$") then
		table.insert(fonts, love.graphics.newFont("Fonts/" .. file, fontSize))
	end
end

--font:setFilter("nearest")

local cardtext = "A"
local CardMapOffsetX = 48
local CardMapOffsetY = 32
local textscale = 4
local fw, fh, rx, ry, Xorig, Yorig

function UpdateFontCalculations()
	if #fonts > 0 then
		currentFont = fonts[fontIndex]

		fw = currentFont:getWidth(cardtext)
		fh = currentFont:getHeight()

		Xorig = fw / 2
		Yorig = fh / 2

		rx = map_width - CardMapOffsetX - (fw * textscale / 2) - 16
		ry = map_height - CardMapOffsetY - (fh * textscale / 2) - 16
	end
end

UpdateFontCalculations()

function DrawFontOnMap()
	if not currentFont then
		return
	end
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(cardtext, CardMapOffsetX, CardMapOffsetY, 0, textscale, textscale)
	love.graphics.print(cardtext, rx, ry, math.pi, textscale, textscale, Xorig, Yorig)
	love.graphics.setColor(1, 1, 1, 1)
end

return fonts
