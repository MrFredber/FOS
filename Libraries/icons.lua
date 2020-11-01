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
end

function icons.folder(x, y)
foreground(0xffff00)
set(x,y,"⣤⣤⣄")
foreground(0xffcf00)
set(x,y+1,"⣿⣿⣿⣿⣿⣿⣿⣿")
color(0xffb100)
foreground(0xff9500)
set(x,y+2,"⣤⣤⣤⣤⣤⣤⣤⣤")
color(0xff7800)
foreground(0xff5b00)
set(x,y+3,"⣤⣤⣤⣤⣤⣤⣤⣤")
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
end

function icons.lang(x, y)
color(0x0000ff)
fill(x+2, y, 4, 4, " ")
fill(x, y+1, 8, 2, " ")
color(0x00ff00)
fill(x+2, y+1,2,2," ")
fill(x+4,y+2,2,1," ")
end

function icons.man(x,y)
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
set(x+2, y+3, ".man")
end

function icons.txt(x,y)
	color(0xffffff)
	foreground(0x000000)
	fill(x,y,8,4," ")
	set(x,y,"abcdefgh")
	set(x,y+1,"ijklmnop")
	set(x,y+2,"qrstuvwx")
	color(0x727272)
	foreground(0xffffff)
	fill(x,y+3,8,1," ")
	set(x+2,y+3,".txt")
end

function icons.cfg(x, y)
color(0x171717)
fill(x, y, 8, 4,"-")
color(0x727272)
fill(x, y+3, 8, 1," ")
set(x+2,y+3,".cfg")
end

function icons.spic(icondata, x, y)
	count = 1
	while count-1 ~= #icondata do
		if string.find(icondata[count], "set") ~= nil then
			set(x+tonumber(icondata[count+1]), y+tonumber(icondata[count+2]), icondata[count+3])
			count = count+3
		elseif string.find(icondata[count], "color") ~= nil then
			color(tonumber(icondata[count+1]))
			count = count+1
		else
			print("SPIC: UnkCommand")
		end
		count = count+1
	end
end

return icons