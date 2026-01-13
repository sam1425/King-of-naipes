camera = require("libraries/camera")
cam = camera()
zoom = 2
cam.scale = zoom

function love.wheelmoved(x, y)
	if y > 0 then
		zoom = zoom + 0.1
	elseif y < 0 then
		zoom = zoom - 0.1
	end
	zoom = math.max(0.5, math.min(zoom, 4))
	cam.scale = zoom
end

return cam
