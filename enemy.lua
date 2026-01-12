--[[
    Enemy Pathfinding Module
    ------------------------
    Handles A* pathfinding navigation, movement smoothing,
    and path visualization for an enemy entity in LÖVE.
]]

local pathfinding = require("pathfinding")
pathfinding.init()

enemy = {}
enemy.x = 0
enemy.y = 0
enemy.rotation = 0
enemy.speed = 80
enemy.path = nil

function enemy:requestPath(player, enemy)
	local sx, sy = enemy.x, enemy.y
	local ex, ey = player.x, player.x

	local path = pathfinding.findPath(sx, sy, ex, ey)
end

function enemy:update(dt, player) end

function enemy:drawPath() end

return enemy
