local raw_loadfile=...
_G._OSVERSION="FredberOS (OpenOS 1.7.5)"
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
gpu.setResolution(w, h)
gpu.setBackground(0x000000)
gpu.setForeground(0xFFFFFF)
gpu.fill(1,1,w,h," ")
end
local y=1
local uptime=computer.uptime
local pull=computer.pullSignal
local last_sleep=uptime()
local function status(msg)
if gpu then
gpu.set(1,y,msg)
if y == h then
gpu.copy(1,2,w,h-1,0,-1)
gpu.fill(1,h,w,1," ")
else
y=y+1
end
end
if uptime()-last_sleep > 1 then
local signal=table.pack(pull(0))
if signal.n > 0 then
computer.pushSignal(table.unpack(signal,1,signal.n))
end
last_sleep=uptime()
end
end
gpu.fill(w/2-2,h/2-5,2,9,"⣿")
gpu.fill(w/2,h/2-5,4,2,"⣿")
gpu.fill(w/2,h/2-1,3,2,"⣿")
gpu.set(w/2-6,h/2+5,"Loading OpenOS")
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
local tr=r("term")
local pc=r("computer")
local g=r("component").gpu
local io=r("io")
local os=r("os")
local c={}
local a={}
local s=g.set
local z="/fos/system/"
local function at()
local f=io.open(z.."auto.cfg","r")
for v in f:lines() do table.insert(a,v) end
f:close()
tr.clear()
s(w/2-9,h/2,"Starting Scripts...")
i=1
while i-1 ~= #a do
os.execute(a[i])
i=i+1
end
end
pcall(at)
local fl=g.fill
tr.clear()
fl(w/2-2,h/2-5,2,9,"⣿")
fl(w/2,h/2-5,4,2,"⣿")
fl(w/2,h/2-1,3,2,"⣿")
s(w/2-5,h/2+5,"Starting FOS")
local cl=g.setBackground
local fc=g.setForeground
local fs=r("filesystem")
if fs.exists(z.."auto.cfg") == false then
cl(0xffffff)
fc(0)
fl(w/2-9,h/2,18,3," ")
s(w/2-8,h/2+1,"Repairing FOS...")
local f=io.open(z.."auto.cfg","w")
f:write("")
f:close()
end
local function d(e)
cl(0xb40000)
fc(0xffffff)
fl(1,1,w,h," ")
tr.setCursor(1,4)
print(e)
_,y=tr.getCursor()
local t="If you see this in "
s(w/2-22,y+1,t.."first time, reboot your PC")
s(w/2-22,y+2,t.."second time, use 'bootmgr'")
s(w/2-38,y+3,t.."third time, show this to the administrator, or the author")
fc(0xb40000)
cl(0xffffff)
s(w/2-16,2,"Critical error while running FOS")
s(w/2-13,y+5,"Left click to reboot PC...")
s(w/2-15,y+6,"Right click to exit to Shell...")
_,_,_,_,clk=r("event").pull("touch")
if clk == 1 then
cl(0)
fc(0xffffff)
tr.clear()
else
pc.shutdown(true)
end
end
local rs,e=loadfile("/fos/fos.lua")
if rs then
rs,e=xpcall(rs,debug.traceback,...)
if not rs then
if type(e) ~= "table" then
d(e)
end
end
else
if type(e) ~= "table" then
d(e)
end
end