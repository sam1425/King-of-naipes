--[[
    Enemy Pathfinding Module
    ------------------------
    Handles pathfinding navigation,
    and path visualization for an enemy entity in LÖVE.
    if the player is in line of sight it goes directly to it
    if not uses JPS to go arround objects
]]

local pathfinding = require("pathfinding")
local world = require("world")
local physics = require("physics")

pathfinding.init()

local TILE_SIZE = 16
local enemy = {}
enemy.__index = enemy

--enemy.x = 64
--enemy.y = 64
--enemy.rotation = 0
--enemy.speed = 100
--enemy.path = nil
--enemy.currentTargetIndex = 1
--enemy.pathIndex = 1
--enemy.currentPath = {}
--enemy.width = 16
--enemy.height = 16

--enemy constructor

function enemy.new(x, y)
	local self = setmetatable({}, enemy)
	self.speed = 50
	self.currentTargetIndex = 1
	self.width = 8
	self.height = 8

	--pathfind
	self.path = nil
	self.pathIndex = 1
	self.currentPath = {}
	self.timer = 0

	--collition
	self.collider = physics:newRectangleCollider(x, y, self.width, self.height)
	self.collider:setFixedRotation(true)
	self.collider:setCollisionClass("Enemy")

	--alive
	self.Alive = true
	return self
end

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
	return self.collider:getPosition()
end

function enemy:getPosition()
	return self.collider:getX(), self.collider:getY()
end

function enemy:setPosition(x, y)
	self.collider:setPosition(x, y)
end

function enemy:update(dt, player)
	if not self.Alive then
		return
	end
	playerx, playery = player.collider:getPosition()
	local ex, ey = self:getCenter()

	self.timer = (self.timer or 0) + dt
	if self.timer > 0.2 then
		--local ex, ey = math.floor((self.x + self.width / 2) / 16) + 1, math.floor((self.y + self.height / 2) / 16) + 1

		--local playerCenterX = playerx + player.width / 2
		--local playerCenterY = playery + player.height / 2
		--local px = math.floor(playerCenterX / 16) + 1
		--local py = math.floor(playerCenterY / 16) + 1

		local startTileX, startTileY = self.CoordsToWorldTile(ex, ey)
		local targetTileX, targetTileY = self.CoordsToWorldTile(playerx, playery)

		local path = pathfinding.findPath(startTileX, startTileY, targetTileX, targetTileY)
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
	local ex, ey = self:getCenter()

	local dx = tx - ex
	local dy = ty - ey
	--local distance = math.sqrt(dx ^ 2 + dy ^ 2)
	local distance = math.sqrt(dx * dx + dy * dy)

	if distance > 5 then
		local vx = (dx / distance) * self.speed
		local vy = (dy / distance) * self.speed
		self.collider:setLinearVelocity(vx, vy)
	else
		self.collider:setLinearVelocity(0, 0)
	end
end

function enemy:followPath(dt)
	selfx, selfy = self.collider:getX(), self.collider:getY()

	if not self.currentPath or self.pathIndex > #self.currentPath then
		self.collider:setLinearVelocity(0, 0)
		return
	end

	local node = self.currentPath[self.pathIndex]
	local targetX = (node.x - 1) * 16 + 8
	local targetY = (node.y - 1) * 16 + 8

	local ex = selfx + self.width / 2
	local ey = selfy + self.height / 2
	local dx = targetX - ex
	local dy = targetY - ey
	local distance = math.sqrt(dx ^ 2 + dy ^ 2)

	if distance > 1 then
		selfx = selfx + (dx / distance) * self.speed * dt
		selfy = selfy + (dy / distance) * self.speed * dt
	else
		self.pathIndex = self.pathIndex + 1
	end
end

function enemy:draw()
	local x, y = self:getPosition()
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", x - (self.width / 2), y - (self.height / 2), self.width, self.height)
	love.graphics.setColor(1, 1, 1)
end

return enemy
