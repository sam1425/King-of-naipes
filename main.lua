function love.load()
	require("settings")
	cam = require("camera")
	map = require("world")
	player = require("player")
end

function love.update(dt)
	move(dt)
end

function love.draw()
	cam:attach()
	draw_map()
	draw_player()
	cam:detach()
end
