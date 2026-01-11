function love.load()
	require("settings")
	local player = require("player")
	local ogmo = require("libraries/ogmo")
	local tileset = love.graphics.newImage("assets/tiles/Overworld_Tileset.png")
	tileset:setFilter("nearest", "nearest")
	tileset:setWrap("clamp", "clamp")
	map = ogmo.read_map("maps/default.json", tileset)
	map_height = map.height + 16
	map_width = map.width + 16

	camera = require("libraries/camera")
	cam = camera()
	zoom = 2
	cam:zoom(zoom)

	-- running
end

function love.wheelmoved(x, y)
	if y > 0 then
		zoom = zoom + 0.01
	elseif y < 0 then
		zoom = zoom - 0.01
	end
	--zoom = math.max(0.5, math.min(zoom, 4)) -- clamp zoom
	cam:zoom(zoom)
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

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit(1)
	end
end

function draw_direction(name, current, x_text_pos, y_text_pos)
	love.graphics.print(name, x_text_pos + 70, y_text_pos)
	love.graphics.print(current, x_text_pos + 10, y_text_pos)
end

function draw_map()
	if map then
		map:draw(0, 0)
	end
end

function DrawDebug()
	local margin = 10
	local offset = 20
	local x_text_pos = love.graphics.getWidth() - margin - 100
	local y_text_pos = love.graphics.getHeight() - margin - 20

	draw_direction("x:", player.currentdirectionx, x_text_pos, y_text_pos)
	draw_direction("y:", player.currentdirectiony, x_text_pos, y_text_pos - offset)
end
