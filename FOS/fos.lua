--Библиотеки

local com = require("component")
local fs = require("filesystem")
local term = require("term")
local event = require("event")
local os = require("os")

--Мои Библиотеки

local desktop = require("fos/desktop")
local icons = require("fos/icons")

--Компоненты

local gpu = com.gpu

------------

local w, h = gpu.getResolution();

gpu.setBackground(0x9f9f9f)
gpu.fill(1, 1, w, 1, " ")
gpu.set(1, 1, "FOS")
gpu.setBackground(0x2b2b2b)
gpu.fill(1, 2, w, h-2, " ")
gpu.setBackground(0x0069ff)
gpu.fill(1, h, w, h, " ")

gpu.setBackground(0xff0000)
gpu.set(w, 1, "X")

gpu.setBackground(0x2b2b2b)
term.setCursor(1, 2)

desktop.workplace();

while true do

local _,_,x,y = event.pull("touch")

if x == w then
gpu.setBackground(0x000000)
term.clear();
os.exit();
end

end