local c = require("component")
local gpu = c.gpu
local os = require("os")
if gpu.maxDepth() == 1 then
	print("Your PC is TIER 1. To install FOS you need a minimum of TIER 2 PC.")
	os.exit()
end

print("Preparing to start the FOS installer...")
local fs = require("filesystem")
local internet = c.internet
local term = require("term")
local io = require("io")
local w, h = gpu.getResolution();
local fill = gpu.fill
local color = gpu.setBackground
local event = require("event")
local dir = fs.makeDirectory
term.clear()

print("FOS Installer")
color(0x2b2b2b)
fill(w/2-9, h/2-2, 20, 7, " ")
color(0xffffff)
gpu.setForeground(0x000000)
fill(w/2-10, h/2-3, 20,7," ")
gpu.set(w/2-10, h/2-3, "Choise Language")
color(0xb40000)
gpu.setForeground(0xffffff)
gpu.set(w/2+7, h/2-3, " X ")
color(0x929292)
gpu.set(w/2+1, h/2-1, "English")
gpu.set(w/2+1, h/2+1, "Русский")
color(0x0000ff)
fill(w/2-7, h/2-1, 4, 4, " ")
fill(w/2-9, h/2, 8, 2, " ")
color(0x00ff00)
fill(w/2-7, h/2,2,2," ")
fill(w/2-5,h/2+1,2,1," ")

langchoise = ""
color(0x000000)
while true do
local _,_,x,y = event.pull("touch")
	if x >= w/2+7 and x <= w/2+9 and y == math.floor(h/2-3) then
		term.clear()
		print("You are exited from the installer")
		os.exit()
	elseif x >= w/2+1 and x <= w/2+7 and y == math.floor(h/2-1) then
		langchoise = "en"
		break
	elseif x >= w/2+1 and x <= w/2+7 and y == math.floor(h/2+1) then
		langchoise = "ru"
		break
	end
end

term.clear()
if langchoise == "ru" then --before installing
	print("Подготовка к установке...")
elseif langchoise == "en" then
	print("Preparing to install...")
else
	print("Unexpected error. Tehnical Information:")
	print(langchoise)
	os.exit()
end

dir("/lib/fos")
dir("/home/foslang")
os.execute("wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/pgbar.lua /lib/fos/pgbar.lua")
if langchoise == "ru" then 
	lang = "russian.lang"
else 
	lang = "english.lang"
end
os.execute("wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Install/"..lang.." /home/foslang/lang")
local pgbar = require("/fos/pgbar")
lang = {}
langfile = io.open("/home/foslang/lang", "r")
for var in langfile:lines() do
table.insert(lang, var)
end

term.clear();
dir("/FOS")
dir("/FOS/Desktop")
dir("/fos/desktop/Settings.app")
dir("/FOS/lang")
dir("/FOS/lang/fos")
dir("/FOS/lang/settings")
dir("/FOS/system")

term.setCursor(1, 1)
pgbar.fullbar(1, h, w, 1)
local c1 = {"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/FOS/fos.lua /fos/fos.lua"}
local c2 = { --lib
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/system.lua /lib/fos/system.lua",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/finder.lua /lib/fos/finder.lua",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/icons.lua /lib/fos/icons.lua",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/debug.lua /lib/fos/debug.lua"}
local c3 = { --apps
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Applications/Settings.app/icon.spic /fos/desktop/settings.app/icon.spic",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Applications/Settings.app/main.lua /fos/desktop/settings.app/main.lua",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/FOS/Desktop/Settings.lua /fos/desktop/Settings.lua"}
local c4 = { --langs
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Language/lang.man /fos/lang/lang.man",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Language/fos/english.lang /fos/lang/fos/english.lang",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Language/fos/russian.lang /fos/lang/fos/russian.lang",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Language/settings/english.lang /fos/lang/settings/english.lang",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Language/settings/russian.lang /fos/lang/settings/russian.lang"}
local c5 = { --other
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/System/settings.cfg /fos/system/settings.cfg",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/System/settings.help /fos/system/settings.help",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/FOS/RAM%20test.lua /fos/desktop/'RAM test.lua'"}

i = 1
cat = 1
gpu.set(1, h-1, lang[i])
pgbar.fullbar(1, h, w, 20)
color(0x000000)
while cat-1 ~= #c1 do
	os.execute(c1[cat])
	cat = cat+1
end
fill(1, h-1, w, 2, " ")
i = i+1
cat = 1
gpu.set(1, h-1, lang[i])
pgbar.fullbar(1, h, w, 40)
color(0x000000)
while cat-1 ~= #c2 do
	os.execute(c2[cat])
	cat = cat+1
end
fill(1, h-1, w, 2, " ")
i = i+1
cat = 1
gpu.set(1, h-1, lang[i])
pgbar.fullbar(1, h, w, 60)
color(0x000000)
while cat-1 ~= #c3 do
	os.execute(c3[cat])
	cat = cat+1
end
fill(1, h-1, w, 2, " ")
i = i+1
cat = 1
gpu.set(1, h-1, lang[i])
pgbar.fullbar(1, h, w, 80)
color(0x000000)
while cat-1 ~= #c4 do
	os.execute(c4[cat])
	cat = cat+1
end
fill(1, h-1, w, 2, " ")
i = i+1
cat = 1
gpu.set(1, h-1, lang[i])
pgbar.fullbar(1, h, w, 100)
color(0x000000)
while cat-1 ~= #c5 do
	os.execute(c5[cat])
	cat = cat+1
end


local file = io.open("/fos/system/settings.cfg", "w") --writing settings
if langchoise == "ru" then
	file:write("russian.lang\nfalse")
elseif langchoise == "en" then
	file:write("english.lang\nfalse")
end
file:close()
local file = io.open("/home/.shrc", "w") --writing startup settings
file:write("/fos/fos\ncd /fos")
file:close()
require("computer").shutdown(true)