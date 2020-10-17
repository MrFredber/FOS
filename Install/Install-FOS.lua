local com = require("component")
local fs = require("filesystem")
local internet = com.internet
local gpu = com.gpu
local os = require("os")
local term = require("term")
local io = require("io")
local w, h = gpu.getResolution();
local depth = gpu.maxDepth()
term.clear()

print("Choise Language:\n1 - English\n2 - Русский")
term.setCursor(1, 5)
term.write(">")
local langchoise = io.read()


if depth == 1 then  --if comp is TIER 1
	if langchoise == "2" then
		print("Фатальная ошибка: FOS не поддерживается на вашем компьютере. Требуется как минимум TIER 2 компьютер и GPU")
		else
		print("Fatal Error: FOS is not supported on your computer. Requires at least a TIER 2 computer and GPU.")
	end
	os.exit()
end

if langchoise == "2" then --before installing
	print("Установка необохдимых файлов...")
	else
	print("Installing required files...")
end

fs.makeDirectory("/lib/fos")
os.execute("wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/pgbar.lua /lib/fos/pgbar.lua")
local pgbar = require("/fos/pgbar")

term.clear();
fs.makeDirectory("/FOS")
fs.makeDirectory("/FOS/Desktop")
fs.makeDirectory("/FOS/lang")
fs.makeDirectory("/FOS/lang/fos")
fs.makeDirectory("/FOS/lang/settings")
fs.makeDirectory("/FOS/system")

term.setCursor(1, 1)
pgbar.fullbar(1, h, w, 1)
gpu.setBackground(0x000000)

local commands = {
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/FOS/fos.lua /fos/fos.lua",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Language/lang.man /fos/lang/lang.man",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Language/fos/english.lang /fos/lang/fos/english.lang",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Language/fos/russian.lang /fos/lang/fos/russian.lang",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Language/settings/english.lang /fos/lang/settings/english.lang",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Language/settings/russian.lang /fos/lang/settings/russian.lang",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/System/settings.cfg /fos/system/settings.cfg",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/System/settings.help /fos/system/settings.help",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/desktop.lua /lib/fos/desktop.lua",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/icons.lua /lib/fos/icons.lua",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/debug.lua /lib/fos/debug.lua",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/FOS/RAM%20test.lua /fos/desktop/'RAM test.lua'",
	"wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/FOS/Desktop/Settings.lua /fos/desktop/Settings.lua"
}

local names = {
	"/FOS/fos.lua","/FOS/lang/lang.man","/FOS/lang/fos/english.lang","/FOS/lang/fos/russian.lang","/fos/lang/settings/english.lang",
	"/fos/lang/settings/russian.lang","/FOS/system/settings.cfg","/FOS/system/settings.help","/lib/fos/desktop.lua","/lib/fos/icons.lua",
	"/lib/fos/debug.lua","/FOS/Desktop/RAM test.lua","/FOS/Desktop/Settings.lua"
}

if langchoise == "2" then
	print("Установка системы...")
	else
	print("Installing system...")
end

i = 1
while i-1 ~= #commands do
	a = 100/#commands
	procent = a*i
	gpu.fill(1, h-1, w, 2, " ")
	pgbar.fullbar(1, h, w, procent)
	gpu.setBackground(0x000000)
	if langchoise == "2" then 
		gpu.set(1, h-1, "Установка: ")	
		gpu.set(12, h-1, names[i])
		else 
		gpu.set(1, h-1, "Installing: ")	
		gpu.set(13, h-1, names[i])
	end
	os.execute(commands[i])
	i = i+1
end

local file = io.open("/fos/system/settings.cfg", "w") --writing settings
if langchoise == "2" then
	file:write("russian.lang\nfalse")
	else
	file:write("english.lang\nfalse")
end
file:close()
local file = io.open("/home/.shrc", "w") --writing startup settings
file:write("/fos/fos\ncd /fos")
file:close()

if langchoise == "2" then
	print("Перезагрузка компьютера...")
	else
	print("Restarting computer...")
end
os.sleep(1)
require("computer").shutdown(true)