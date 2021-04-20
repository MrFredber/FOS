local r=require
local term=r("term")
local gpu=r("component").gpu
local io=r("io")
local os=r("os")
local comp={}
local auto={}
local set=gpu.set
function autostart()
file=io.open("/fos/system/auto.cfg","r")
for var in file:lines() do table.insert(auto,var) end
file:close()
term.clear()
set(w/2-9,h/2,"Starting Scripts...")
i=1
while i-1 ~= #auto do
	os.execute(auto[i])
	i=i+1
end
end
function resolution()
file=io.open("/fos/system/comp.cfg","r")
for var in file:lines() do
	pos=var:find(",")
	if pos ~= nil then
		w=tonumber(var:sub(1,pos-1))
		h=tonumber(var:sub(pos+1))
	else
		comp[1]=var
	end
end
file:close()
gpu.setResolution(w,h)
end

result=pcall(resolution)
if not result then
	w,h=gpu.getResolution()
end
pcall(autostart)
local fill=gpu.fill
term.clear()
fill(w/2-3,h/2-4,2,9,"⣿")
fill(w/2-1,h/2-4,4,2,"⣿")
fill(w/2-1,h/2,3,2,"⣿")
local color=gpu.setBackground
local fcolor=gpu.setForeground
local fs=r("filesystem")

function err(parm)
color(0xffffff)
fcolor(0)
fill(w/2-9,h/2,18,3," ")
set(w/2-8,h/2+1,"Repairing FOS...")
os.execute("/fos/bootmgr /"..parm)
end

if fs.exists("/fos/system/lang.cfg") == false then
	err("fixlangcfg")
end
if fs.exists("/fos/system/user.cfg") == false then
	err("fixusercfg")
end
if fs.exists("/fos/system/comp.cfg") == false then
	err("fixcompcfg")
end
if fs.exists("/fos/system/auto.cfg") == false then
	err("fixautocfg")
end

function rsod(reason)
color(0xb40000)
fcolor(0xffffff)
fill(1,1,w,h," ")
term.setCursor(1,4)
print(reason)
_,y=term.getCursor()
set(w/2-22,y+1,"If you see this in first time, reboot your PC")
set(w/2-22,y+2,"If you see this in second time, use 'bootmgr'")
set(w/2-38,y+3,"If you see this in third time, show this to the administrator, or the author")
fcolor(0xb40000)
color(0xffffff)
set(w/2-16,2,"Critical error when starting FOS")
set(w/2-18,y+5,"Touch the screen to exit to Shell...")
r("event").pull("touch")
color(0)
fcolor(0xffffff)
term.clear()
end

local result,reason=loadfile("/fos/fos.lua")
if result then
	result,reason=xpcall(result,debug.traceback,...)
    if not result then
    	if type(reason) ~= "table" then
    		rsod(reason)
    	end
    end
else
	if type(reason) ~= "table" then
    	rsod(reason)
	end
end