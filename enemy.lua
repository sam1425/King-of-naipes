--[[
    Enemy Pathfinding Module
    ------------------------
    Handles A* pathfinding navigation, movement smoothing,
    and path visualization for an enemy entity in LÖVE.
]]

local pathfinding = require("pathfinding")
local world = require("world")
local physics = require("physics")

pathfinding.init()

local enemy = {}
local TILE_SIZE = 16
enemy.x = 64
enemy.y = 64
--enemy.rotation = 0
enemy.speed = 100
enemy.path = nil
enemy.currentTargetIndex = 1
enemy.pathIndex = 1
enemy.currentPath = {}
enemy.width = 16
enemy.height = 16

function enemy.WorldTileToCoords(tx, ty)
	local px = tx * TILE_SIZE + (TILE_SIZE / 2)
	local py = ty * TILE_SIZE + (TILE_SIZE / 2)
	return px, py
end

function enemy.CoordsToWorldTile(px, py)
	local tileX = math.floor(px / TILE_SIZE) + 1
	local tileY = math.floor(py / TILE_SIZE) + 1

	return tileX, tileY
end

function enemy:getCenter()
	return self.x + self.width / 2, self.y + self.height / 2
end

function enemy:update(dt, player)
	playerx = player.collider:getX()
	playery = player.collider:getY()

	self.timer = (self.timer or 0) + dt
	if self.timer > 0.2 then
		local ex, ey = math.floor((self.x + self.width / 2) / 16) + 1, math.floor((self.y + self.height / 2) / 16) + 1

		local playerCenterX = playerx + player.width / 2
		local playerCenterY = playery + player.height / 2
		local px = math.floor(playerCenterX / 16) + 1
		local py = math.floor(playerCenterY / 16) + 1

		local path = pathfinding.findPath(ex, ey, px, py)
		if path then
			self.currentPath = {}
			for node in path:nodes() do
				table.insert(self.currentPath, node)
			end
			self.pathIndex = #self.currentPath > 1 and 2 or 1
		end
		self.timer = 0
	end

	if self:hasLineOfSight(player) then
		self:moveDirectlyToPlayer(playerx, playery, dt)
	else
		self:followPath(dt)
	end
end

function enemy:hasLineOfSight(target)
	local x1 = playerx + self.width / 2
	local y1 = playery + self.height / 2

	local x2 = playerx + target.width / 2
	local y2 = playery + target.height / 2

	for i = 1, 5 do
		local t = i / 5
		local checkX = x1 + (x2 - x1) * t
		local checkY = y1 + (y2 - y1) * t

		local tx = math.floor(checkX / 16) + 1
		local ty = math.floor(checkY / 16) + 1

		if world.data.layers[3].grid2D[ty] and world.data.layers[3].grid2D[ty][tx] ~= 0 then
			return false
		end
	end
	return true
end

function enemy:moveDirectlyToPlayer(tx, ty, dt)
	local ex = self.x + self.width / 2
	local ey = self.y + self.height / 2

	local dx = tx - ex
	local dy = ty - ey
	local distance = math.sqrt(dx ^ 2 + dy ^ 2)

	if distance > 5 then
		self.x = self.x + (dx / distance) * self.speed * dt
		self.y = self.y + (dy / distance) * self.speed * dt
	end
end

function enemy:followPath(dt)
	if not self.currentPath or self.pathIndex > #self.currentPath then
		return
	end

	local node = self.currentPath[self.pathIndex]
	local targetX = (node.x - 1) * 16 + 8
	local targetY = (node.y - 1) * 16 + 8

	local ex = self.x + self.width / 2
	local ey = self.y + self.height / 2
	local dx = targetX - ex
	local dy = targetY - ey
	local distance = math.sqrt(dx ^ 2 + dy ^ 2)

	if distance > 1 then
		self.x = self.x + (dx / distance) * self.speed * dt
		self.y = self.y + (dy / distance) * self.speed * dt
	else
		self.pathIndex = self.pathIndex + 1
	end
end

function enemy:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.setColor(1, 1, 1)
end

return enemy
