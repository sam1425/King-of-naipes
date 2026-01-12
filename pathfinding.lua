local world = require("world")
local Grid = require("libraries/jumper.grid")
local Pathfinder = require("libraries/jumper.pathfinder")

local pathfinding = {}
local walkable = 0
local finder

local function normalizeGrid(grid2D)
	for y = 1, #grid2D do
		for x = 1, #grid2D[y] do
			grid2D[y][x] = tonumber(grid2D[y][x]) or 0
		end
	end
end

function pathfinding.init()
	local layer = world.data.layers[3]
	normalizeGrid(layer.grid2D)
	local grid = Grid(layer.grid2D)
	finder = Pathfinder(grid, "JPS", walkable)
	print("pathfinding initialized")
end

function pathfinding.findPath(startx, starty, endx, endy)
	if not finder then
		error("Pathfinding not initialized. Call pathfinding.init() first.")
	end
	local path, lenght = finder:getPath(startx, starty, endx, endy)
	if path then
		print(("Path found! Length: %.2f"):format(length))
		for node, count in path:iter() do
			print(("Step: %d - x: %d - y: %d"):format(count, node.x, node.y))
		end
	end

	return nil
end

return pathfinding
