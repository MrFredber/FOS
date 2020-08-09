--FOS (Fredber Operational System) is a Russian os made to facilitate the use of the OpenComputers computer

--debugs functions: tableprint(table)

--Библиотеки

local fs = require("filesystem")
local term = require("term")
local event = require("event")
local os = require("os")
local comp = require("computer")
local io = require("io")

--Мои Библиотеки

local desktop = require("fos/desktop")
local icons = require("fos/icons")
--local pgbar = require("fos/pgbar")
local debug = require("fos/debug")

--Компоненты

local gpu = require("component").gpu

--Переменные

local w, h = gpu.getResolution();
local a = 0
local ver = "a2-2"
local path = "/fos"
local lang = {}
local sett = {}
local filesname = {}
local langpath = "/fos/lang/fos"
local settpath = "/fos/system/"
local settname = "settings.cfg"
local fullsettpath = fs.concat(settpath, settname)
local settfile = io.open(fullsettpath, "r")

--Функции

local function load(x, y)
icons.logo(x/2-5, y/2-4)
end

local function draw(path, sett)
	desktop.sysBackground()
	local filesname = desktop.files(path);
	local cords = desktop.createButtons(filesname, sett, 1, 1)
	gpu.set(1, 1, "V:") --Версия
	gpu.set(4, 1, ver) --Версия
	desktop.workplace(filesname, path);
return filesname
end

----------

load(w, h);

--Проверка перед запуском

for var in settfile:lines() do
table.insert(sett, var)
end

local fulllangpath = fs.concat(langpath, sett[1])
local langfile = io.open(fulllangpath, "r")

--lang = langfile:read("*a")

for var in langfile:lines() do
table.insert(lang, var)
end

if w < 79 or h < 24 then
term.clear();
print(lang[4])
os.exit()
end

----------

draw(path, sett);

while true do

local _,_,x,y = event.pull("touch")

if x ~= nil and y ~= nil and y ~= h and a ~= 1 then
	desktop.sysBackground()
	local filesname = desktop.files(path);
	local cords = desktop.createButtons(filesname, sett, 1, 1)

	local openfilename = desktop.pressButton(cords,filesname, x, y)
	gpu.set(1, 1, "V:") --Версия
	gpu.set(4, 1, ver) --Версия
	desktop.workplace(filesname, path);
	local openfile = fs.concat(path, openfilename)
	if fs.isDirectory(openfile) ~= true and openfilename ~= nil then
		os.execute("'" .. openfile .. "'")
	end
end

--Рисование меню

if x == 1 and y == h then
gpu.setBackground(0x009400)
gpu.set(1, h-1, lang[1])
gpu.setBackground(0xff0000)
gpu.set(2, h-1, lang[2])
gpu.setBackground(0xffb400)
gpu.set(3, h-1, lang[3])
a = 1 --открытое меню


elseif x == 1 and y == h-1 and a == 1 then

--Выход в Shell
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

--Выключение и перезагрузка
elseif x == 2 and y == h-1 and a == 1 then
comp.shutdown(false)
elseif x == 3 and y == h-1 and a == 1 then
comp.shutdown(true)
--Закрытие меню
elseif a == 1 then
gpu.setBackground(0x2b2b2b)
gpu.fill(1, h-1, 2, h-2, " ")
local filesname, cords = draw(path, sett, cords);
a = 0 --закрытое меню
end
end