local ogmo = require("libraries/ogmo")
local tileset = love.graphics.newImage("assets/tiles/carta_base.png")
tileset:setFilter("nearest", "nearest")
tileset:setWrap("clamp", "clamp")
map = ogmo.read_map("maps/default.json", tileset)
map_height = map.height + 16
map_width = map.width + 16

local collitionlayer = map.data.layers[3]
for i = 1, #collitionlayer.grid do
	collitionlayer.grid[i] = tonumber(collitionlayer.grid[i]) or collitionlayer.grid[i]
end

print("Tiles loaded :" .. #collitionlayer.grid)

function draw_map()
	if map then
		map:draw(0, 0)
	end
end

return map
