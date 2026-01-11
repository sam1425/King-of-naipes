local fonts = {}
fontIndex = 1
local currentFont = nil
local files = love.filesystem.getDirectoryItems("Fonts")
for _, file in ipairs(files) do
	if file:match("%.ttf$") then
		table.insert(fonts, love.graphics.newFont("Fonts/" .. file))
	end
end

--font:setFilter("nearest")

local cardtext = "A"
local CardMapOffsetX = 32
local CardMapOffsetY = 64
local textscale = 4
local fw, fh, rx, ry, Xorig, Yorig

function UpdateFontCalculations()
	if #fonts > 0 then
		currentFont = fonts[fontIndex]
		love.graphics.setFont(currentFont)

		fw = currentFont:getWidth(cardtext)
		fh = currentFont:getHeight()

		rx = map_width - CardMapOffsetX - (fw * textscale)
		ry = map_height - CardMapOffsetY - (fh * textscale)

		Xorig = fw / 2
		Yorig = fh / 2
	end
end

UpdateFontCalculations()

function DrawFontOnMap()
	if not currentFont then
		return
	end
	love.graphics.print(cardtext, CardMapOffsetX, CardMapOffsetY, 0, textscale, textscale)
	love.graphics.print(cardtext, rx, ry, math.pi, textscale, textscale, Xorig, Yorig)
end

return fonts
