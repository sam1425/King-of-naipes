local wf = require("libraries/windfield")

world = wf.newWorld(0, 0)

world:addCollisionClass("Enemy")
world:addCollisionClass("Player")

return world
