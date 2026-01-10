function love.load()
	camera = require("lib/camera")
	cam = camera()

	love.window.setMode(1280, 720)
	love.window.setTitle("tiny zelda game")
	love.graphics.setDefaultFilter("nearest", "nearest")
	player = {}
	player.x = 200
	player.y = 200
	player.speed = 200
	player.width = 50
	player.height = 60
	player.currentdirectionx = 0
	player.currentdirectiony = 0
	player.currentdirection = 2
	player.moving = false

	-- running
	animations = {}
	animations[1] = newAnimation(love.graphics.newImage("assets/oldHero_up.png"), 16, 18, 1)
	animations[2] = newAnimation(love.graphics.newImage("assets/oldHero_down.png"), 16, 18, 1)
	animations[3] = newAnimation(love.graphics.newImage("assets/oldHero_left.png"), 16, 18, 1)
	animations[4] = newAnimation(love.graphics.newImage("assets/oldHero_right.png"), 16, 18, 1)

	-- idle
	animations_idle = {}
	animations_idle[1] = newAnimation(love.graphics.newImage("assets/idle_up.png"), 16, 18, 1)
	animations_idle[2] = newAnimation(love.graphics.newImage("assets/idle_down.png"), 16, 18, 1)
	animations_idle[3] = newAnimation(love.graphics.newImage("assets/idle_left.png"), 16, 18, 1)
	animations_idle[4] = newAnimation(love.graphics.newImage("assets/idle_right.png"), 16, 18, 1)

	current_animation = animations_idle[2]
end

function love.update(dt)
	local acceleration = 400
	local friction = 300

	local move_x, move_y = get_movement()
	local moving = move_x ~= 0 or move_y ~= 0

	local animation_speed = moving and 1.5 or 1
	local magnitude = math.sqrt(move_x * move_x + move_y * move_y)
	if magnitude > 0 then
		move_x = move_x / magnitude
		move_y = move_y / magnitude
	end
	if move_x > 0 then
		player.currentdirection = 4 -- right
		current_animation = animations[4]
	end
	if move_x < 0 then
		player.currentdirection = 3 -- left
		current_animation = animations[3]
	end
	if move_y > 0 then
		player.currentdirection = 2 -- down
		current_animation = animations[2]
	end
	if move_y < 0 then
		player.currentdirection = 1 -- up
		current_animation = animations[1]
	end

	-- Apply movement
	player.x = player.x + player.speed * move_x * dt
	player.y = player.y + player.speed * move_y * dt
	-- Idle check if player is not moving
	if not moving then
		animation_speed = 1.2
		current_animation = animations_idle[player.currentdirection]
	end

	if player.x < 0 then
		player.x = 0
	elseif player.x + player.width > love.graphics.getWidth() then
		player.x = love.graphics.getWidth() - player.width
	end

	if player.y < 0 then
		player.y = 0
	elseif player.y + player.height > love.graphics.getHeight() then
		player.y = love.graphics.getHeight() - player.height
	end

	-- Update animation time
	current_animation.currentTime = current_animation.currentTime + dt * animation_speed
	if current_animation.currentTime >= current_animation.duration then
		current_animation.currentTime = current_animation.currentTime - current_animation.duration
	end
end

function love.draw()
	-- Draw the player
	local spriteNum = math.floor(current_animation.currentTime / current_animation.duration * #current_animation.quads)
		+ 1
	local scaleX, scaleY = 4, 4 -- Adjust these values to scale the sprite
	love.graphics.draw(
		current_animation.spriteSheet,
		current_animation.quads[spriteNum],
		player.x,
		player.y, -- Use player's position here
		0,
		scaleX,
		scaleY
	)
	-- love.graphics.setColor(1,1,1)
	-- love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
	-- love.graphics.polygon("fill", 60, 30, 3, 10, 19, 1)
	-- love.graphics.circle("line" , 60, 60, 5, 40)
	local margin = 10 -- Margin from the edges of the screen
	local x_text_pos = love.graphics.getWidth() - margin - 100 -- Adjust 100 based on text length
	local y_text_pos = love.graphics.getHeight() - margin - 20 -- Adjust 20 based on text height

	draw_direction("x:", player.currentdirectionx, x_text_pos, y_text_pos)
	draw_direction("y:", player.currentdirectiony, x_text_pos, y_text_pos - 20)
end

function newAnimation(image, width, height, duration)
	local animation = {}
	animation.spriteSheet = image
	animation.quads = {}

	for y = 0, image:getHeight() - height, height do
		for x = 0, image:getWidth() - width, width do
			table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
		end
	end

	animation.duration = duration or 1
	animation.currentTime = 0

	return animation
end

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.event.quit(exitstatus)
	end
end

function get_movement()
	local move_x, move_y = 0, 0

	if love.keyboard.isDown("a") then
		move_x = -1
		player.currentdirection = 3
		player.currentdirectionx = -1
		moving = true
	end
	if love.keyboard.isDown("d") then
		move_x = 1
		player.currentdirection = 4
		player.currentdirectionx = 1
		moving = true
	end
	if love.keyboard.isDown("w") then
		move_y = -1
		player.currentdirection = 1
		player.currentdirectiony = -1
		moving = true
	end
	if love.keyboard.isDown("s") then
		move_y = 1
		player.currentdirection = 2
		player.currentdirectiony = 1
		moving = true
	end

	return move_x, move_y
end

function draw_direction(name, current, x_text_pos, y_text_pos)
	love.graphics.print(name, x_text_pos + 70, y_text_pos)
	love.graphics.print(current, x_text_pos + 10, y_text_pos)
end

function draw_map() end
