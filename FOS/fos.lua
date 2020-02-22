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

--Компоненты

local gpu = com.gpu

--Переменные

local w, h = gpu.getResolution();
local a = 0
local lang = {}
local langsett = {}
local langpath = "/fos/lang/fos"
local settpath = "/fos/system/"
local settname = "lang"
local fullsettpath = fs.concat(settpath, settname)
local settfile = io.open(fullsettpath, "r")

----------

for var in settfile:lines() do
table.insert(langsett, var)
end

local fulllangpath = fs.concat(langpath, langsett[1])
local langfile = io.open(fulllangpath, "r")

for var in langfile:lines() do
table.insert(lang, var)
end

if w < 79 or h < 24 then
print(lang[4])
os.exit()
end

desktop.workplace();

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
os.exit();
else if x == 2 and y == h-1 and a == 1 then
computer.shutdown(false)
else if x == 3 and y == h-1 and a == 1 then
computer.shutdown(true)
else if a == 1 then
gpu.setBackground(0x2b2b2b)
gpu.fill(1, h-1, 2, h-2, " ")
desktop.workplace();
end
end
end
end
end



end