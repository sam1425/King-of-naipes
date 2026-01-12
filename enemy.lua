--[[
    Enemy Pathfinding Module
    ------------------------
    Handles A* pathfinding navigation, movement smoothing,
    and path visualization for an enemy entity in LÖVE.
]]

local pathfinding = require("pathfinding")
pathfinding.init()

local enemy = {}
local TILE_SIZE = 16
enemy.x = 64
enemy.y = 64
enemy.rotation = 0
enemy.speed = 80
enemy.path = nil

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

function enemy:update(dt, player)
	local ex, ey = enemy.CoordsToWorldTile(self.x, self.y)
	local px, py = enemy.CoordsToWorldTile(player.x, player.y)

	self.path = pathfinding.findPath(ex, ey, px, py)
end

function enemy:drawPath()
	if not self.path then
		return
	end
	love.graphics.setColor(1, 0, 0)
	for _, node in ipairs(self.path) do
		local x, y = enemy.WorldTileToCoords(node.x, node.y)
		love.graphics.circle("fill", x, y, 4)
	end
	love.graphics.setColor(1, 1, 1)
end

return enemy
