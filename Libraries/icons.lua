local icons={}
local gpu=require("component").gpu
local fill=gpu.fill
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set

function icons.unkFile(x,y)
color(0)
fcolor(0xffffff)
set(x,y,"⠀⢠⣶⠟⠛⢶⡄⠀")
set(x,y+1,"⠀⠈⠁⠀⢀⣼⠇⠀")
set(x,y+2,"⠀⠀⠀⢰⡟⠁⠀⠀")
set(x,y+3,"⠀⠀⠀⠰⠆⠀⠀⠀")
end

function icons.folder(x,y)
fcolor(0xffff00)
set(x,y,"⣤⣤⣄")
color(0xffcf00)
set(x,y+1,"        ")
color(0xffb100)
fcolor(0xff9500)
set(x,y+2,"⣤⣤⣤⣤⣤⣤⣤⣤")
color(0xff7800)
fcolor(0xff5b00)
set(x,y+3,"⣤⣤⣤⣤⣤⣤⣤⣤")
end

function icons.lua(x,y)
color(0x171717)
fcolor(0xffb400)
set(x,y,"if      ")
set(x,y+2,"end     ")
fcolor(0xad2de7)
set(x+3,y,"i = 1")
set(x+6,y+1,"i")
fcolor(0xff0000)
set(x,y+1,"print(")
set(x+7,y+1,")")
color(0x727272)
fcolor(0xffffff)
set(x,y+3,"  .lua  ")
end

function icons.lang(x,y)
fcolor(0x0000ff)
set(x+6,y,"⣶⡄")
set(x,y+3,"⠘⠿    ⠿⠃")
fcolor(0x00ff00)
set(x,y,"⢠⣶")
color(0x0000ff)
set(x+2,y,"⣿⣿⡟⣿")
set(x,y+1,"⣿⣿⣿⠟⠋ ⡀ ")
set(x,y+2," ⠉⠿⣆⣠⠈  ")
set(x+2,y+3," ⠛⠁ ")
end

function icons.txt(x,y)
color(0xffffff)
fcolor(0)
set(x,y,"abcdefgh")
set(x,y+1,"ijklmnop")
set(x,y+2,"qrstuvwx")
color(0x727272)
fcolor(0xffffff)
set(x,y+3,"  .txt  ")
end

function icons.cfg(x,y)
color(0x171717)
fcolor(0xffffff)
set(x,y,"⠀⡠⠢⠎⠱⠔⢄⠀")
set(x,y+1,"⡨⠆⠀⣷⣄⠀⠰⢅")
set(x,y+2,"⢑⠆⠀⡿⠋⠀⠰⡊")
set(x,y+3,"⠀⠑⠔⢆⡰⠢⠊⠀")
end

function icons.app(x,y)
color(0x0094ff)
fcolor(0xffffff)
set(x,y,"⠀⠀⠀⠀⠀⠀⠀⠀")
set(x,y+1,"⢰⣉⡆⡤⢄⢠⠤⡀")
set(x,y+2,"⠸⠀⠇⡧⠜⢸⠤⠃")
set(x,y+3,"⠀⠀⠀⠁⠀⠈⠀⠀")
end

function icons.pic(x,y)
color(0x00ffff)
fcolor(0xffffff)
set(x,y,"⠀⠴⠦⠠⠦   ")
fcolor(0x267f00)
set(x,y+1,"⠀⠀⣠⣾⣷⣄  ")
fcolor(0x7f3300)
set(x,y+2,"   ⢸⡇   ")
fcolor(0xffd800)
set(x+5,y,"⢈⢅⢛")
set(x+6,y+1,"⠁⠈")
fcolor(0xffd2b5)
set(x+2,y+2,"⣤")
fcolor(0x4cff00)
set(x,y+3,"⣠⣤⣤⣾⣷⣤⣤⣄")
color(0x0026ff)
set(x+2,y+3,"⣤")
end

return icons