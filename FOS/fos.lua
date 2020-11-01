--FOS (Fredber Operational System) is a Russian os made to facilitate the use of the OpenComputers computer

--debugs functions: print(debug.tableprint(table))

--Libraries
local c = require("component")
local term = require("term")
local gpu = c.gpu
local w, h = gpu.getResolution();
term.clear()
gpu.fill(w/2-3, h/2-4, 2, 9, "⣿")
gpu.fill(w/2-1, h/2-4, 4, 2, "⣿")
gpu.fill(w/2-1, h/2, 3, 2, "⣿")
local screen = c.screen
local fs = require("filesystem")
local event = require("event")
local os = require("os")
local comp = require("computer")
local io = require("io")

local system = require("fos/system")
local finder = require("fos/finder")
local debug = require("fos/debug")
local icons = require("fos/icons")

--Variables

local a = 0
local ver = "a5"
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
print(system)
local function draw(path, sett)
	system.background();
	gpu.set(1, 1, lang[8] .. ver) --Version
	local filesname = finder.files(path);
	local cords = system.createButtons(filesname, sett, 1, 1)
	system.workplace(filesname, path, lang);
return filesname
end

----------

draw(path, sett);
local smax = 0

while true do

local _,_,x,y = event.pull("touch")

if x ~= nil and y ~= nil and y ~= h and a ~= 1 then
	local filesname = finder.files(path);
	local cords = system.createButtons(filesname, sett, 1, 1)
	local openfilename, filepos = system.pressButton(cords,filesname, x, y)
	system.updAfterPress(openfilename, filepos, lang)
	local openfile = fs.concat(path, openfilename)
 	if string.find(openfile, ".app") ~= nil then
		openfile = openfile.."/main.lua"
	end
	if openfile ~= nil and openfilename ~= nil then
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
		print(openfilename)
		gpu.setForeground(0xffffff)
		if string.find(openfilename, ".txt") ~= nil then
			openfiletext = {}
			for var in io.open(openfile, "r"):lines() do
				table.insert(openfiletext, var)
			end
			i = 1
			gpu.setForeground(0x000000)
			gpu.fill(1, 2, w, h-2," ")
			while i-1 ~= #openfiletext do
				print(openfiletext[i])
				i = i+1
			end
			while true do
				local _,_,x,y = event.pull("touch")
				if x >= w-2 and x <= w and y == 1 then
					break
				end
			end
		else
			os.execute("'" .. openfile .. "'")
		end
		draw(path, sett)
	end
end

--Рисование меню
if x == 1 and y == h and sleep ~= 1 then
	smax = system.drawMenu(lang, sett)
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