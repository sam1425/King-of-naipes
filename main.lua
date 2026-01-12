function love.load()
	require("settings")
	cam = require("camera")
	map = require("world")
	fonts = require("fonts")
	player = require("player")
end

function love.update(dt)
	move(dt)
end

function love.draw()
	cam:attach()
	draw_map()
	DrawFontOnMap()
	draw_player()
	cam:detach()
	--love.graphics.print("Current Index: " .. fontIndex, 100, 130)
end

function love.keypressed(key) --, scancode, isrepeat)--
	if key == "space" and #fonts then
		fontIndex = fontIndex % #fonts + 1
		currentFont = fonts[fontIndex]
		love.graphics.setFont(currentFont)
	end
end

--love.graphics.scale(4)
