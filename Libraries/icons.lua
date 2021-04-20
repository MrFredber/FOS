local icons={}
local gpu=require("component").gpu
local fill=gpu.fill
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set

function icons.unkFile(x,y)
color(0)
fcolor(0x272727)
fill(x,y,8,4,"?")
fcolor(0xffffff)
fill(x+2,y,2,1,"⣿")
fill(x+4,y+1,1,1,"⣿")
fill(x+3,y+2,1,1,"⣿")
set(x+3,y+3,"■")
end

function icons.folder(x,y)
fcolor(0xffff00)
set(x,y,"⣤⣤⣄")
fcolor(0xffcf00)
set(x,y+1,"⣿⣿⣿⣿⣿⣿⣿⣿")
color(0xffb100)
fcolor(0xff9500)
set(x,y+2,"⣤⣤⣤⣤⣤⣤⣤⣤")
color(0xff7800)
fcolor(0xff5b00)
set(x,y+3,"⣤⣤⣤⣤⣤⣤⣤⣤")
end

function icons.lua(x,y)
color(0x171717)
fill(x,y,8,4," ")
fcolor(0xffb400)
set(x,y,"if")
set(x,y+2,"end")
fcolor(0xad2de7)
set(x+3,y,"i = 1")
set(x+6,y+1,"i")
fcolor(0xff0000)
set(x,y+1,"print(")
set(x+7,y+1,")")
color(0x727272)
fcolor(0xffffff)
fill(x,y+3,8,1," ")
set(x+2,y+3,".lua")
end

function icons.lang(x,y)
color(0x0000ff)
fill(x+2,y,4,4," ")
fill(x,y+1,8,2," ")
color(0x00ff00)
fill(x+2,y+1,2,2," ")
fill(x+4,y+2,2,1," ")
end

function icons.txt(x,y)
color(0xffffff)
fcolor(0)
fill(x,y,8,4," ")
set(x,y,"abcdefgh")
set(x,y+1,"ijklmnop")
set(x,y+2,"qrstuvwx")
color(0x727272)
fcolor(0xffffff)
fill(x,y+3,8,1," ")
set(x+2,y+3,".txt")
end

function icons.cfg(x,y)
color(0x171717)
set(x,y," ⢀⣀⠜⠣⣀⡀ ")
set(x,y+1,"⣀⠜⢁⢔⡢⡈⠣⣀")
set(x,y+2,"⠉⢢⡈⠪⠕⢁⡔⠉")
color(0x727272)
fill(x,y+3,8,1," ")
set(x+2,y+3,".cfg")
end

return icons