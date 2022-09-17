local raw_loadfile=...
_G._OSVERSION="FredberOS (OpenOS 1.7.7)"
local component=component
local computer=computer
local unicode=unicode
_G.runlevel="S"
local shutdown=computer.shutdown
computer.runlevel=function() return _G.runlevel end
computer.shutdown=function(reboot)
_G.runlevel=reboot and 6 or 0
if os.sleep then
computer.pushSignal("shutdown")
os.sleep(0.1)
end
shutdown(reboot)
end
local w,h
local screen=component.list("screen", true)()
local gpu=screen and component.list("gpu", true)()
if gpu then
gpu=component.proxy(gpu)
if not gpu.getScreen() then
gpu.bind(screen)
end
_G.boot_screen=gpu.getScreen()
w,h=gpu.maxResolution()
gpu.setResolution(w,h)
gpu.setBackground(0x000000)
gpu.setForeground(0xFFFFFF)
gpu.fill(1,1,w,h," ")
end
local y=1
local uptime=computer.uptime
local pull=computer.pullSignal
local last_sleep=uptime()
gpu.set(w/2-7,h-1,"Loading core...")
local function dofile(file)
local program,reason=raw_loadfile(file)
if program then
local result=table.pack(pcall(program))
if result[1] then
return table.unpack(result,2,result.n)
else
error(result[2])
end
else
error(reason)
end
end
local package=dofile("/lib/package.lua")
do
_G.component=nil
_G.computer=nil
_G.process=nil
_G.unicode=nil
_G.package=package
package.loaded.component=component
package.loaded.computer=computer
package.loaded.unicode=unicode
package.loaded.buffer=dofile("/lib/buffer.lua")
package.loaded.filesystem=dofile("/lib/filesystem.lua")
_G.io=dofile("/lib/io.lua")
end
require("filesystem").mount(computer.getBootAddress(),"/")
local function rom_invoke(method,...)
return component.invoke(computer.getBootAddress(),method,...)
end
local scripts={}
for _,file in ipairs(rom_invoke("list","boot")) do
local path="boot/"..file
if not rom_invoke("isDirectory",path) then
table.insert(scripts,path)
end
end
table.sort(scripts)
for i=1,#scripts do
dofile(scripts[i])
end
for c,t in component.list() do
computer.pushSignal("component_added",c,t)
end
computer.pushSignal("init")
require("event").pull(1,"init")
_G.runlevel=1

local r=require
local g=r("component").gpu
local set=g.set
local color=g.setBackground
local fcolor=g.setForeground
local fill=g.fill
local fs=r("filesystem")
local io=r("io")
local pc=r("computer")
local term=r("term")
local event=r("event")
local unicode=r("unicode")
local len=unicode.len
local user,autostart,skipLoad,file={},{},false

local function errPrevent(text)
if fs.exists("/tmp/timerid") then
	file=io.open("/tmp/timerid","r")
	event.cancel(tonumber(file:read("*all")))
	file:close()
	fs.remove("/tmp/timerid")
end
w,h=g.maxResolution()
g.setResolution(w,h)
color(0xf9d03f)
fcolor(0)
fill(1,1,w,h," ")
term.setCursor(1,3)
print(text)
color(0)
fcolor(0xffffff)
fill(1,1,w,1," ")
fill(1,h-1,w,2," ")
if user.lang == "russian.lang" then
	set(3,1,"Что-то препятствует загрузке FOS.")
	set(3,h-1,"Левый клик, чтобы перезагрузить ПК...")
	set(3,h,"Правый клик, чтобы запустить оболочку OpenOS...")
else
	set(3,1,"Something is preventing FOS from loading.")
	set(3,h-1,"Left click to reboot PC...")
	set(3,h,"Right click to start OpenOS Shell...")
end
pc.beep("--")
_,_,_,_,clk=event.pull("touch")
if clk == 1 then
	color(0)
	fcolor(0xffffff)
	term.clear()
	skipLoad=true
else
	pc.shutdown(true)
end
end

local function errScript(path,text)
if fs.exists("/tmp/timerid") then
	file=io.open("/tmp/timerid","r")
	event.cancel(tonumber(file:read("*all")))
	file:close()
	fs.remove("/tmp/timerid")
end
w,h=g.maxResolution()
g.setResolution(tw,th)
color(0x0094ff)
fcolor(0)
fill(1,1,w,h," ")
term.setCursor(1,3)
print(text)
color(0)
fcolor(0xffffff)
fill(1,1,w,1," ")
fill(1,h,w,1," ")
if user.lang == "russian.lang" then
	set(3,1,"Произошла ошибка в работе скрипта \""..path.."\".")
	set(3,h,"Нажмите на экран, чтобы продолжить...")
else
	set(3,1,"An error occurred in the script \""..path.."\".")
	set(3,h,"Tap on the screen to continue...")
end
pc.beep("...")
event.pull("touch")
w,h=user.width,user.height
g.setResolution(w,h)
end

local function errFOS(text)
if fs.exists("/tmp/timerid") then
	file=io.open("/tmp/timerid","r")
	event.cancel(tonumber(file:read("*all")))
	file:close()
	fs.remove("/tmp/timerid")
end
w,h=g.maxResolution()
g.setResolution(w,h)
color(0xEC605B)
fcolor(0xffffff)
fill(1,1,w,h," ")
term.setCursor(1,3)
print(text)
color(0)
fcolor(0xffffff)
fill(1,1,w,1," ")
fill(1,h-1,w,2," ")
if user.lang == "russian.lang" then
	set(3,1,"Произошла критическая ошибка во время работы FOS.")
	set(3,h-1,"Левый клик, чтобы перезагрузить ПК...")
	set(3,h,"Правый клик, чтобы запустить оболочку OpenOS...")
else
	set(3,1,"Critical error occurred while running FOS.")
	set(3,h-1,"Left click to reboot PC...")
	set(3,h,"Right click to start OpenOS Shell...")
end
pc.beep("--")
_,_,_,_,clk=event.pull("touch")
if clk == 1 then
	color(0)
	fcolor(0xffffff)
	term.clear()
else
	pc.shutdown(true)
end
end

local function loadIcon()
fcolor(0x404040)
set(w/2-3,h/2-2,"⣾")
set(w/2+4,h/2-2,"⣷")
set(w/2-3,h/2+1,"⢿")
set(w/2+4,h/2+1,"⡿")
color(0x404040)
fcolor(0xffffff)
set(w/2-2,h/2-2,"⠀⢀⣀⣀⡀⠀")
set(w/2-3,h/2-1,"⠀⠀⢸⣏⣉⡁⠀⠀")
set(w/2-3,h/2,"⠀⠀⢸⡏⠉⠁⠀⠀")
set(w/2-2,h/2+1,"⠀⠈⠁⠀⠀⠀")
end

local finder
if fs.exists("/lib/fos/finder.lua") then
	finder=r("fos/finder")
else
	errPrevent("Library \"finder.lua\" was not found in \"/lib/fos/\" directory.")
end

local function conf()
t="/fos/system/generalSettings.cfg"
if fs.exists(t) then
	file=io.open(t,"r")
	for v in file:lines() do table.insert(user,v) end
	user=finder.unserialize(user)
	tw,th=g.maxResolution()
	if user.width > tw or user.height > th or user.width < 27 or user.height < 15 then
		w,h=tw,th
		user.width,user.height=w,h
	else
		w,h=user.width,user.height
	end
	g.setResolution(w,h)
else
	w,h=g.maxResolution()
	user.lang="english.lang"
end
end

local function startScripts()
t="/fos/system/auto.cfg"
if fs.exists(t) then
	file=io.open(t,"r")
	for v in file:lines() do table.insert(autostart,v) end
end

startup=#autostart
if startup > 0 then
	for i=1,startup do
		color(0)
		fcolor(0xffffff)
		fill(1,1,w,h," ")
		if user.lang == "russian.lang" then
			t="Запуск скриптов... ("..i.."/"..startup..")"
			slen=len(t)
			set(w/2-(slen/2),h-1,t)
		else
			t="Starting scripts... ("..i.."/"..startup..")"
			slen=len(t)
			set(w/2-(slen/2),h-1,t)
		end
		loadIcon()
		result,text=loadfile(autostart[i])
		if result then
			result,text=xpcall(result,debug.traceback)
			if not result then
				if type(text) ~= "table" then
					errScript(autostart[i],text)
				end
			end
		else
			if type(text) ~= "table" then
				errScript(autostart[i],text)
			end
		end
	end
end
end

if not skipLoad then
	result,text=xpcall(conf,debug.traceback)
	if not result then
		if type(text) ~= "table" then
			errPrevent(text)
		end
	end

	result,text=xpcall(startScripts,debug.traceback)
	if not result then
		if type(text) ~= "table" then
			errPrevent(text)
		end
	end

	color(0)
	fcolor(0xffffff)
	fill(1,1,w,h," ")
	if user.lang == "russian.lang" then
		set(w/2-6,h-1,"Запуск FOS...")
	else
		set(w/2-7,h-1,"Starting FOS...")
	end
	loadIcon()

	result,text=loadfile("/fos/fos.lua")
	if result then
		result,text=xpcall(result,debug.traceback)
		if not result then
			if type(text) ~= "table" then
				errFOS(text)
			end
		end 
	else
		if type(text) ~= "table" then
			errFOS(text)
		end
	end
end