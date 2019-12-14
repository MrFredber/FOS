local icons = {}
local gpu = require("component").gpu
local color = gpu.setBackground
local fill = gpu.fill
local set = gpu.set

function icons.unkFile(x, y)

color(0x000000)
fill(x, y, 8, 4, " ")
set(x+2, y, "chto")
set(x+3, y+1, "za")
set(x+1, y+2, "hernya")
color(0x727272)
fill(x, y+3, 8, 1, " ")
set(x+2, y+3, ".???")
color(0x2b2b2b)

end

function icons.folder(x, y)

color(0xffb800)
fill(x, y, 2, 1, " ")
fill(x, y+1, 8, 3, " ")
set(x+1, y+3, "folder")
color(0x2b2b2b)

end

function icons.lua(x, y)

color(0x292929)
fill(x, y, 8, 4, " ")

color(0x727272)
fill(x, y+3, 8, 1, " ")
set(x+3, y+3, ".lua")
end

return icons