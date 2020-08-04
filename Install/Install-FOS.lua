local com = require("component")
local fs = require("filesystem")
local internet = com.internet
local gpu = com.gpu
local os = require("os")
local event = require("event")
local term = require("term")
local kb = require("keyboard")
local color = gpu.setForeground
local w, h = gpu.getResolution();

fs.makeDirectory("/lib/fos")
os.execute("wget -f https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/pgbar.lua /lib/fos/pgbar.lua")
local pgbar = require("/fos/pgbar")

term.clear();
fs.makeDirectory("/FOS")
fs.makeDirectory("/FOS/Desktop")
fs.makeDirectory("/FOS/lang")
fs.makeDirectory("/FOS/lang/fos")
fs.makeDirectory("/FOS/system")
--fs.makeDirectory("/FOS/system/tmp")
--fs.makeDirectory("/FOS/system/tmp/fos")

term.setCursor(1, 1)
pgbar.fullbar(1, h, w, 1)
gpu.setBackground(0x000000)

local commands = {
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/FOS/fos.lua /fos/fos.lua",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Language/fos/russian.lang /fos/lang/fos/russian.lang",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Language/fos/english.lang /fos/lang/fos/english.lang",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Language/fos/testlang.help /fos/lang/fos/testlang.help",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/System/settings.cfg /fos/system/settings.cfg",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/System/settings.help /fos/system/settings.help",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/desktop.lua /lib/fos/desktop.lua",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/icons.lua /lib/fos/icons.lua",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/debug.lua /lib/fos/debug.lua",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/FOS/bsod.lua /fos/bsod.lua",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Home/fos /home/fos.lnk",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/FOS/Desktop/Settings.lua /fos/desktop/Settings.lua"
}

local names = {"fos.lua","russian.lang","english.lang","testlang.help","settings.cfg","settings.help","desktop.lua","icons.lua","debug.lua","bsod.lua","fos.lnk","Settings.lua"}
i = 1

while i ~= #commands do
	a = 100/#commands
	b = i+1
	procent = a*b
	term.clear();
	pgbar.fullbar(1, h, w, procent)
	gpu.setBackground(0x000000)
	gpu.set(1, h-1, "Installing: ")
	gpu.set(13, h-1, names[i])
	os.execute(commands[i])
	i = i+1
end

print("restarting computer...")
os.sleep(1)
require("computer").shutdown(true)