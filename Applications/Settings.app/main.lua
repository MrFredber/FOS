local gpu = require("component").gpu
local io = require("io")
local os = require("os")
local term = require("term")
local sett = {}
local lang = {}
local foslang = {}
local settfile = io.open("/fos/system/settings.cfg", "r")
local w, h = gpu.getResolution();
local color = gpu.setBackground
local foreground = gpu.setForeground

function MainMenu( ... )
	color(0xe0e0e0)
	gpu.fill(1, 2, w, h-2, " ")
	color(0xffffff)
	foreground(0x000000)
	gpu.fill(3, 3, 23,6," ")
	gpu.fill(29, 3, 23,6," ")
	gpu.fill(55,3,23,6," ")
	gpu.fill(4,4,8,4,"?")
	gpu.fill(30,4,8,4,"?")
	gpu.fill(56,4,8,4,"?")
	gpu.set(13,4, string.sub("Coming Soon!",1,12))
	gpu.set(39,4, string.sub("Coming Soon!",1,12))
	gpu.set(65,4, string.sub("Coming Soon!",1,12))
	os.sleep(5)
end

MainMenu()