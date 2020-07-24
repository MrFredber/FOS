local com = require("component")
local fs = require("filesystem")
local internet = com.internet
local gpu = com.gpu
local os = require("os")
local event = require("event")
local term = require("term")
local kb = require("keyboard")
local color = gpu.setForeground
a = 0

fs.makeDirectory("/lib/fos")
os.execute("wget -f https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/pgbar.lua /lib/fos/pgbar.lua")
local pgbar = require("/fos/pgbar")

term.clear();
color(0xffff00)
print("Making Directories...")
color(0xffffff)

fs.makeDirectory("/FOS")
fs.makeDirectory("/FOS/Desktop")
fs.makeDirectory("/FOS/lang")
fs.makeDirectory("/FOS/lang/fos")
fs.makeDirectory("/FOS/system")
fs.makeDirectory("/FOS/system/tmp")
fs.makeDirectory("/FOS/system/tmp/fos")
pgbar.bar(2, 3, 25, 1)

term.setCursor(1, 6)

color(0xffff00)
print("Installing Main File...")
color(0xffffff)
os.execute("wget -f https://raw.githubusercontent.com/MrFredber/FOS/master/FOS/fos.lua /fos/fos.lua")
pgbar.bar(2, 3, 25, 20)
color(0xffff00)
print("Installing Languages...")
color(0xffffff)
os.execute("wget -f https://raw.githubusercontent.com/MrFredber/FOS/master/Language/fos/russian.lang /fos/lang/fos/russian.lang")
os.execute("wget -f https://raw.githubusercontent.com/MrFredber/FOS/master/Language/fos/english.lang /fos/lang/fos/english.lang")
os.execute("wget -f https://raw.githubusercontent.com/MrFredber/FOS/master/Language/fos/help.lang /fos/lang/fos/help.lang")
pgbar.bar(2, 3, 25, 40)
color(0xffff00)
print("Installing System files...")
color(0xffffff)
os.execute("wget -f https://raw.githubusercontent.com/MrFredber/FOS/master/System/lang /fos/system/lang")
os.execute("wget -f https://raw.githubusercontent.com/MrFredber/FOS/master/System/ver /fos/system/ver")
pgbar.bar(2, 3, 25, 60)
color(0xffff00)
print("Installing Libraries...")
color(0xffffff)
os.execute("wget -f https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/desktop.lua /lib/fos/desktop.lua")
os.execute("wget -f https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/icons.lua /lib/fos/icons.lua")
os.execute("wget -f https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/debug.lua /lib/fos/debug.lua")
pgbar.bar(2, 3, 25, 80)
color(0xffff00)
print("Installing  Other files...")
color(0xffffff)
os.execute("wget -f https://raw.githubusercontent.com/MrFredber/FOS/master/FOS/bsod.lua /fos/bsod.lua")
os.execute("wget -f https://raw.githubusercontent.com/MrFredber/FOS/master/Home/fos /home/fos")
pgbar.bar(2, 3, 25, 100)

color(0xffff00)
print("restarting computer...")
os.sleep(1)
require("computer").shutdown(true)