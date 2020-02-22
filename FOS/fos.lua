--Библиотеки

local com = require("component")
local fs = require("filesystem")
local term = require("term")
local event = require("event")
local os = require("os")
local computer = require("computer")

--Мои Библиотеки

local desktop = require("fos/desktop")
local icons = require("fos/icons")

--Компоненты

local gpu = com.gpu

--Переменные

local w, h = gpu.getResolution();
local a = 0

----------

desktop.workplace();

while true do

local _,_,x,y = event.pull("touch")

if x == 1 and y == h then
gpu.setBackground(0x009400)
gpu.set(1, h-1, "S")
gpu.setBackground(0xff0000)
gpu.set(2, h-1, "O")
gpu.setBackground(0xffb400)
gpu.set(3, h-1, "R")
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