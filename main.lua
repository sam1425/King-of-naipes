function love.load()
	require("settings")
	cam = require("camera")
	map = require("world")
	world = map.physics
	physics = require("physics")
	fonts = require("fonts")
	player = require("player")
	enemySpawner = require("enemySpawner")
	enemySpawner:init(map_width, map_height)
	enemySpawner:spawnMultiple(5)
end

function love.update(dt)
	world:update(dt)
	move(dt)
	enemySpawner:update(dt, player)
end

function love.draw()
	cam:attach()
	draw_map()
	DrawFontOnMap()
	enemySpawner:draw()
	draw_player()
	love.graphics.setColor(0, 0, 0)
	world:draw()
	love.graphics.setColor(1, 1, 1)
	cam:detach()
	--love.graphics.print("Current Index: " .. fontIndex, 100, 130)
end

--function love.keypressed(key) --, scancode, isrepeat)--
--if key == "space" and #fonts then
--fontIndex = fontIndex % #fonts + 1
--currentFont = fonts[fontIndex]
--love.graphics.setFont(currentFont)
--end
--end
