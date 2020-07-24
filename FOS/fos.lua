--Библиотеки

local com = require("component")
local fs = require("filesystem")
local term = require("term")
local event = require("event")
local os = require("os")
local computer = require("computer")
local io = require("io")

--Мои Библиотеки

local desktop = require("fos/desktop")
local icons = require("fos/icons")
local pgbar = require("fos/pgbar")
local debug = require("fos/debug")

--Компоненты

local gpu = com.gpu

--Переменные

local w, h = gpu.getResolution();

--загрузка
local function load(x, y, procent)
icons.logo(x/2-5, y/2-4)
pgbar.bar(x/2-5, y+6, 10, procent)
end
--

load(w, h, 0);

local a = 0
local lang = {}
local langsett = {}
local ver = {}
local langpath = "/fos/lang/fos"
local settpath = "/fos/system/"
local langname = "lang"
local vername = "ver"
local fulllangpath = fs.concat(settpath, langname)
local langfile = io.open(fulllangpath, "r")
local fullverpath = fs.concat(settpath, vername)
local verfile = io.open(fullverpath, "r")

----------

load(w, h, 50);

for var in langfile:lines() do
table.insert(langsett, var)
end

for var in verfile:lines() do
table.insert(ver, var)
end

local fulllangpath = fs.concat(langpath, langsett[1])
local langfile = io.open(fulllangpath, "r")

for var in langfile:lines() do
table.insert(lang, var)
end

if w < 79 or h < 24 then
term.clear();
print(lang[4])
os.exit()
end

load(w, h, 100);

gpu.setForeground(0xffffff)

desktop.workplace();

gpu.set(4, 1, ver[1])
gpu.set(1, 1, "V:")

while true do

local _,_,x,y = event.pull("touch")

if x == 1 and y == h then
gpu.setBackground(0x009400)
gpu.set(1, h-1, lang[1])
gpu.setBackground(0xff0000)
gpu.set(2, h-1, lang[2])
gpu.setBackground(0xffb400)
gpu.set(3, h-1, lang[3])
a = 1
else if x == 1 and y == h-1 and a == 1 then

gpu.setBackground(0x000000)
term.clear();
gpu.setBackground(0x2b2b2b)
gpu.fill(1, 1, w, 1, "-")
gpu.set(w/2-3, 1, "Shell")
gpu.set(w/2-19, 2, "(to return to the system, write 'fos')")
term.setCursor(1, 3)
os.exit();

else if x == 2 and y == h-1 and a == 1 then
computer.shutdown(false)
else if x == 3 and y == h-1 and a == 1 then
computer.shutdown(true)
else if a == 1 then
gpu.setBackground(0x2b2b2b)
gpu.fill(1, h-1, 2, h-2, " ")
desktop.workplace();
a = 0
end
end
end
end
end
end