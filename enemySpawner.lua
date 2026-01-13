local enemy = require("enemy")
local world = require("world")

local enemySpawner = {}
enemySpawner.enemies = {}
enemySpawner.maxEnemies = 10
enemySpawner.spawnTimer = 0
enemySpawner.spawnInterval = 2 -- seconds between spawns

function enemySpawner:init(mapWidth, mapHeight)
	self.mapWidth = mapWidth
	self.mapHeight = mapHeight
end

function enemySpawner:isValidSpawnPoint(x, y)
	local tileX = math.floor(x / 16) + 1
	local tileY = math.floor(y / 16) + 1

	if world.data.layers[3].grid2D[tileY] and world.data.layers[3].grid2D[tileY][tileX] ~= 0 then
		return false
	end
	return true
end

function enemySpawner:spawnEnemy()
	if #self.enemies >= self.maxEnemies then
		return
	end

	local x, y
	local attempts = 0
	local maxAttempts = 10

	repeat
		x = math.random(0, self.mapWidth - 16)
		y = math.random(0, self.mapHeight - 16)
		attempts = attempts + 1
	until self:isValidSpawnPoint(x, y) or attempts >= maxAttempts

	if self:isValidSpawnPoint(x, y) then
		local newEnemy = {
			x = x,
			y = y,
			rotation = 0,
			speed = 100,
			path = nil,
			currentTargetIndex = 1,
			pathIndex = 1,
			currentPath = {},
			width = 16,
			height = 16,
			timer = 0,
		}
		for k, v in pairs(enemy) do
			if type(v) == "function" then
				newEnemy[k] = v
			end
		end
		table.insert(self.enemies, newEnemy)
	end
end

function enemySpawner:update(dt, player)
	self.spawnTimer = self.spawnTimer + dt
	if self.spawnTimer >= self.spawnInterval then
		self:spawnEnemy()
		self.spawnTimer = 0
	end

	for i, e in ipairs(self.enemies) do
		e:update(dt, player)
	end
end

function enemySpawner:draw()
	for i, e in ipairs(self.enemies) do
		e:draw()
	end
end

function enemySpawner:spawnMultiple(count)
	for i = 1, count do
		self:spawnEnemy()
	end
end

return enemySpawner
