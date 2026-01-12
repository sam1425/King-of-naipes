local fonts = {}
local fontSize = 32
fontIndex = 2
local currentFont = love.graphics.newFont("Fonts/Poker.ttf", fontSize)
love.graphics.setFont(currentFont)

--font:setFilter("nearest")

local cardtext = "A"
local CardMapOffsetX = 48
local CardMapOffsetY = 32
local textscale = 4
local fw, fh, rx, ry, Xorig, Yorig

function UpdateFontCalculations()
	fw = currentFont:getWidth(cardtext)
	fh = currentFont:getHeight()

	Xorig = fw / 2
	Yorig = fh / 2

	rx = map_width - CardMapOffsetX - (fw * textscale / 2) - 16
	ry = map_height - CardMapOffsetY - (fh * textscale / 2) - 16
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
