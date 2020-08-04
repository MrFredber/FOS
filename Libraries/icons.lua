local icons = {}
local gpu = require("component").gpu
local color = gpu.setBackground
local foreground = gpu.setForeground
local fill = gpu.fill
local set = gpu.set

function icons.unkFile(x, y)

color(0x000000)
foreground(0x272727)
fill(x, y, 8, 4, "?")
foreground(0xffffff)
fill(x+2, y, 2, 1, "⣿")
fill(x+4, y+1, 1, 1, "⣿")
fill(x+3, y+2, 1, 1, "⣿")
set(x+3, y+3, "■")
--●
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
fill(x+2, y, 4, 4, " ")
fill(x, y+1, 8, 2, " ")
color(0x00ff00)
fill(x+2, y+1,2,2," ")
fill(x+4,y+2,2,1," ")
color(0x2b2b2b)
end

function icons.logo(x, y)
color(0xffffff)
fill(x+2, y, 2, 9, " ")
fill(x+4, y, 4, 2, " ")
fill(x+4, y+4, 3, 2, " ")
color(0x000000)
end

function icons.help(x,y)
color(0x171717)
foreground(0xffffff)
fill(x, y, 8, 4, " ")
set(x+2, y+1, "is a")
foreground(0xff0000)
set(x+3, y, "err")
set(x+2, y+2, "error")
color(0x727272)
foreground(0xffffff)
fill(x, y+3, 8, 1, " ")
set(x+1, y+3, ".help")
color(0x2b2b2b)
end

function icons.cfg(x, y)
color(0x171717)
fill(x, y, 8, 4,"-")
color(0x727272)
fill(x, y+3, 8, 1," ")
set(x+2,y+3,".cfg")
color(0x2b2b2b)
end
function icons.settings(x, y)
color(0x171717)
fill(x, y, 8, 4, " ")
set(x+2, y, "╭--╮")
set(x+2, y+1,"│╲╱│")
set(x+2, y+2,"│╱╲│")
set(x+2, y+3,"╰--╯")
color(0x2b2b2b)
end

return icons