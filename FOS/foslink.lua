local r=require
local tr=r("term")
local pc=r("computer")
local g=r("component").gpu
local io=r("io")
local os=r("os")
local c,a,reg={},{},{}
local s=g.set
local z="/fos/system/"
local file,b,f,c,rs,e,time,timer
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
local function rg()
f=io.open(z.."registry","r")
for v in f:lines() do
if v:find("=") ~= nil then
c=v:find("=")
b=unicode.sub(v,1,c-1)
v=unicode.sub(v,c+1)
reg[b]=v
else
table.insert(reg,v)
end
end
f:close()
end
pcall(rg)
if g.setResolution(tonumber(reg.width),tonumber(reg.height)) then w,h=tonumber(reg.width),tonumber(reg.height) else w,h=g.getResolution() end
pcall(at)
local fl=g.fill
tr.clear()
fl(w/2-2,h/2-5,2,9,"⣿")
fl(w/2,h/2-5,4,2,"⣿")
fl(w/2,h/2-1,3,2,"⣿")
s(w/2-5,h/2+5,"Starting FOS")
local cl=g.setBackground
local fc=g.setForeground
function taskbarTime()
clr=gpu.getBackground()
fclr=gpu.getForeground()
cl(0x0069ff)
fc(0xffffff)
time=time+1
if reg.taskbarShowSeconds == "1" then
	s(w-8,h,os.date('%H:%M:%S',time))
else
	s(w-5,h,os.date('%H:%M',time))
end
cl(clr)
fc(fclr)
end
local fs=r("filesystem")
if fs.exists(z.."auto.cfg") == false then
cl(0xffffff)
fc(0)
fl(w/2-9,h/2,18,3," ")
s(w/2-8,h/2+1,"Repairing FOS...")
f=io.open(z.."auto.cfg","w")
f:write("")
f:close()
end
local function d(e)
r("event").cancel(timer)
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
pc.beep("--")
_,_,_,_,clk=r("event").pull("touch")
if clk == 1 then
cl(0)
fc(0xffffff)
tr.clear()
else
pc.shutdown(true)
end
end
local timeCorrection=reg.timeZone*3600
temp=io.open("/tmp/time","w")
temp:close()
temp=fs.lastModified("/tmp/time")
time=tonumber(string.sub(temp,1,-4))+timeCorrection
rs,e=loadfile("/fos/fos.lua")
if rs then
timer=r("event").timer(1,taskbarTime,math.huge)
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