local PlayerStartPositionX = 200
local PlayerStartPositionY = 200

local player = {}
player.speed = 200
player.width = 12
player.height = 16
player.currentdirection = 2
player.collider = world:newRectangleCollider(PlayerStartPositionX, PlayerStartPositionY, player.width, player.height)
player.collider:setCollisionClass("Player")
player.collider:setFixedRotation(true)

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
	return move_x, move_y
end

function move(dt)
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

	local vx = player.speed * move_x
	local vy = player.speed * move_y
	player.collider:setLinearVelocity(vx, vy)
	local px, py = player.collider:getPosition()
	cam:lookAt(px, py)
	--player.x = player.collider:getX()
	--player.y = player.collider:getY()

	if not moving then
		animation_speed = 1.2
		current_animation = animations_idle[player.currentdirection]
	end
	current_animation.currentTime = current_animation.currentTime + dt * animation_speed
	if current_animation.currentTime >= current_animation.duration then
		current_animation.currentTime = current_animation.currentTime - current_animation.duration
	end
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
	local offset = 4
	local px, py = player.collider:getPosition()
	local spriteNum = math.floor(current_animation.currentTime / current_animation.duration * #current_animation.quads)
			+ 1
	local scaleX, scaleY = 2, 2
	love.graphics.draw(
		current_animation.spriteSheet,
		current_animation.quads[spriteNum],
		px - (player.width + offset),
		py - player.height,
		0,
		scaleX,
		scaleY
	)
end

return player
