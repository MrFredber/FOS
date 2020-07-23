local icons = {}
local gpu = require("component").gpu
local color = gpu.setBackground
local foreground = gpu.setForeground
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

color(0x171717)
fill(x, y, 8, 4, " ")
foreground(0xffb400)
set(x, y, "if")
set(x, y+2, "end")
foreground(0xad2de7)
set(x+3, y, "i = 1")
set(x+6, y+1, "i")
foreground(0xff0000)
set(x, y+1, "print(")
set(x+7, y+1, ")")
color(0x727272)
foreground(0xffffff)
fill(x, y+3, 8, 1, " ")
set(x+2, y+3, ".lua")
color(0x2b2b2b)
end

function icons.lang(x, y)
color(0x0000ff)
fill(x, y, 8, 4, " ")
set(x, y, "привет")
set(x+1, y+1, "howdy?")
set(x+1, y+2, "名前は?")
color(0x727272)
fill(x, y+3, 8, 1, " ")
set(x+2, y+3, ".lang")
color(0x2b2b2b)
end

function icons.logo(x, y)
color(0xffffff)
fill(x+2, y, 2, 8, " ")
fill(x+4, y, 4, 2, " ")
fill(x+4, y+4, 2, 2, " ")
color(0x000000)
end

return icons