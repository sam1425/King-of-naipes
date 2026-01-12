local player = {}
player.x = 100
player.y = 100
player.speed = 200
player.width = 50
player.height = 60
player.currentdirectionx = 0
player.currentdirectiony = 0
player.currentdirection = 2
--player.moving = false

function get_movement()
	local move_x, move_y = 0, 0

	local left = love.keyboard.isDown("a")
	local right = love.keyboard.isDown("d")
	local up = love.keyboard.isDown("w")
	local down = love.keyboard.isDown("s")

	if left and not right then
		move_x = -1
		player.currentdirection = 3
	elseif right and not left then
		move_x = 1
		player.currentdirection = 4
	end

	if up and not down then
		move_y = -1
		player.currentdirection = 1
	elseif down and not up then
		move_y = 1
		player.currentdirection = 2
	end

	player.currentdirectionx = move_x
	player.currentdirectiony = move_y

	return move_x, move_y
end

function move(dt)
	--local acceleration = 400
	--local friction = 300

	local move_x, move_y = get_movement()
	local moving = move_x ~= 0 or move_y ~= 0

	local animation_speed = moving and 1.5 or 1
	local magnitude = math.sqrt(move_x * move_x + move_y * move_y)

	if magnitude > 0 then
		move_x = move_x / magnitude
		move_y = move_y / magnitude
	end
	if move_x > 0 then
		player.currentdirection = 4
		current_animation = animations[4]
	end
	if move_x < 0 then
		player.currentdirection = 3
		current_animation = animations[3]
	end
	if move_y > 0 then
		player.currentdirection = 2
		current_animation = animations[2]
	end
	if move_y < 0 then
		player.currentdirection = 1
		current_animation = animations[1]
	end

	player.x = player.x + player.speed * move_x * dt
	player.y = player.y + player.speed * move_y * dt

	if not moving then
		animation_speed = 1.2
		current_animation = animations_idle[player.currentdirection]
	end

	--colitions:
	if player.x < 0 then
		player.x = 0
	elseif player.x + player.width > map_width then
		player.x = map_width - player.width
	end

	if player.y < 0 then
		player.y = 0
	elseif player.y + player.height > map_height then
		player.y = map_height - player.height
	end

	current_animation.currentTime = current_animation.currentTime + dt * animation_speed
	if current_animation.currentTime >= current_animation.duration then
		current_animation.currentTime = current_animation.currentTime - current_animation.duration
	end
	cam:lookAt(player.x, player.y)
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

--running
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
function draw_player()
	local spriteNum = math.floor(current_animation.currentTime / current_animation.duration * #current_animation.quads)
		+ 1
	local scaleX, scaleY = 2, 2
	love.graphics.draw(
		current_animation.spriteSheet,
		current_animation.quads[spriteNum],
		player.x,
		player.y,
		0,
		scaleX,
		scaleY
	)
end

return player
