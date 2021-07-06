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