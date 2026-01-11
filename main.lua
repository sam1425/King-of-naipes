function love.load()
	require("settings")
	cam = require("camera")
	map = require("world")
	font = require("font")
	player = require("player")
	print(map_height, map_width)
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
end

function love.keypressed(key) --, scancode, isrepeat)--
	if key == "escape" then
		love.event.quit(1)
	end
end

--love.graphics.scale(4)
