--FOS (Fredber Operational System) is a Russian os made to facilitate the use of the OpenComputers computer

--debugs functions: tableprint(table)

--Libraries
local gpu = require("component").gpu
local w, h = gpu.getResolution();
local icons = require("fos/icons")
icons.logo(w/2-5, h/2-4)

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
local ver = "a3"
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
print(lang[4])
os.exit()
end

--Functions

local function draw(path, sett)
	desktop.sysBackground()
	gpu.set(1, 1, lang[7]) --Version
	gpu.set(6, 1, ver) --Version
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
	gpu.set(1, 1, lang[7]) --Версия
	gpu.set(6, 1, ver) --Версия
	desktop.workplace(filesname, path, lang);
	local openfile = fs.concat(path, openfilename)
	if fs.isDirectory(openfile) ~= true and openfilename ~= nil then
		os.execute("'" .. openfile .. "'")
		draw(path, sett, lang)
	end
end

--Рисование меню
if x == 1 and y == h then
	i = 1
	smax = 0
	while i ~= 4 do
		slen = string.len(lang[i])
		if slen > smax then
			smax = slen
		end
		i = i+1
	end 
	if sett[1] == "russian.lang" then
		smax = smax/2
	end
	gpu.setBackground(0x009400)
	gpu.fill(1, h-3, smax, 1, " ")
	gpu.set(1, h-3, lang[1])
	gpu.setBackground(0xb40000)
	gpu.fill(1, h-2, smax, 1, " ")
	gpu.set(1, h-2, lang[2])
	gpu.setBackground(0xffb400)
	gpu.fill(1, h-1, smax, 1, " ")
	gpu.set(1, h-1, lang[3])
	a = 1 --открытое меню

elseif x >= 1 and x <= smax and y == h-3 and a == 1 then

	--Go To Shell
	gpu.setBackground(0x000000)
	term.clear();
	gpu.setBackground(0x2b2b2b)
	gpu.fill(1, 1, w, 1, "-")
	if sett[1] == "russian.lang" then
		gpu.set(w/2-4, 1, lang[5])
		gpu.set(w/2-21, 2, lang[6])
		else
		gpu.set(w/2-3, 1, lang[5])
		gpu.set(w/2-19, 2, lang[6])
	end
	term.setCursor(1, 3)
	os.sleep(0)
	os.exit();

--Shutdown and Reboot
elseif x > 0 and x <= smax and y == h-2 and a == 1 then
	comp.shutdown(false)
elseif x > 0 and x <= smax and y == h-1 and a == 1 then
	comp.shutdown(true)
elseif a == 1 then --закрытие меню
	local filesname, cords = draw(path, sett);
	a = 0 --закрытое меню
end
end