--FOS (Fredber Operational System) is a Russian os made to facilitate the use of the OpenComputers computer

--debugs functions: print(tableprint(table))

--Libraries
local c = require("component")
local gpu = c.gpu
local w, h = gpu.getResolution();
local icons = require("fos/icons")
icons.logo(w/2-5, h/2-4)
local screen = c.screen
local fs = require("filesystem")
local term = require("term")
local event = require("event")
local os = require("os")
local comp = require("computer")
local io = require("io")

local desktop = require("fos/desktop")
local debug = require("fos/debug")

--Variables

local a = 0
local ver = "a4"
local path = "/fos/desktop"
local lang = {}
local sett = {}
local filesname = {}
local settfile = io.open("/fos/system/settings.cfg", "r")

--Before starting

for var in settfile:lines() do
table.insert(sett, var)
end
langpath = fs.concat("/fos/lang/fos", sett[1])
langfile = io.open(langpath, "r")
for var in langfile:lines() do
table.insert(lang, var)
end

if w < 79 or h < 24 then
term.clear();
print(lang[5])
os.exit()
end

--Functions

local function draw(path, sett)
	desktop.sysBackground()
	gpu.set(1, 1, lang[8] .. ver) --Version
	local filesname = desktop.files(path);
	local cords = desktop.createButtons(filesname, sett, 1, 1)
	desktop.workplace(filesname, path, lang);
return filesname
end

----------

draw(path, sett);
local smax = 0

while true do

local _,_,x,y = event.pull("touch")

if x ~= nil and y ~= nil and y ~= h and a ~= 1 then
	desktop.sysBackground()
	local filesname = desktop.files(path);
	local cords = desktop.createButtons(filesname, sett, 1, 1)

	local openfilename = desktop.pressButton(cords,filesname, x, y)
	gpu.set(1, 1, lang[8] .. ver) --Версия
	desktop.workplace(filesname, path, lang);
	local openfile = fs.concat(path, openfilename)
	if fs.isDirectory(openfile) ~= true and openfilename ~= nil then
		gpu.setBackground(0xffffff)
		gpu.fill(1,1,w,1," ")
		gpu.setBackground(0xb40000)
		gpu.fill(w-2,1,3,1," ")
		gpu.set(w-1, 1, "X")
		if openfilename == "Settings.lua" then
			gpu.setBackground(0x1e90ff)
			slen = string.len(lang[9])
			if sett[1] == "russian.lang" then
				slen = slen/2
			end
			gpu.fill(3, h, slen+2, 1, " ")
			gpu.set(4, h, lang[9])
			gpu.setForeground(0x000000)
			gpu.setBackground(0xffffff)
			gpu.set(1, 1, lang[9])
		else
			gpu.setBackground(0x1e90ff)
			slen = string.len(openfilename)
			gpu.fill(3, h, slen+2, 1, " ")
			gpu.set(4, h, openfilename)
			gpu.setForeground(0x000000)
			gpu.setBackground(0xffffff)	
			gpu.set(1, 1, openfilename)
		end
		gpu.setForeground(0xffffff)
		os.execute("'" .. openfile .. "'")
		draw(path, sett, lang)
	end
end

--Рисование меню
if x == 1 and y == h and sleep ~= 1 then
	smax = desktop.drawMenu(lang, sett)
	a = 1
	delay = 1
end

if x >= 1 and x <= smax and y == h-4 and a == 1 and sleep ~= 1 then

	--Go To Shell
	gpu.setBackground(0x000000)
	term.clear();
	gpu.setBackground(0x2b2b2b)
	gpu.fill(1, 1, w, 1, "-")
	if sett[1] == "russian.lang" then
		gpu.set(w/2-4, 1, lang[6])
		gpu.set(w/2-21, 2, lang[7])
		else
		gpu.set(w/2-3, 1, lang[6])
		gpu.set(w/2-19, 2, lang[7])
	end
	term.setCursor(1, 3)
	os.sleep(0)
	os.exit();

--Shutdown and Reboot
elseif x > 0 and x <= smax and y == h-3 and a == 1 and sleep ~= 1 then
	sleep = 1
	screen.turnOff()
elseif x > 0 and x <= smax and y == h-2 and a == 1 and sleep ~= 1 then
	comp.shutdown(false)
elseif x > 0 and x <= smax and y == h-1 and a == 1 and sleep ~= 1 then
	comp.shutdown(true)
elseif sleep == 1 and x ~= 0 then
	sleep = 0
	screen.turnOn()
elseif a == 1 and delay ~= 1 then --закрытие меню
	local filesname, cords = draw(path, sett);
	a = 0 --закрытое меню
else 
	delay = 0
end
end