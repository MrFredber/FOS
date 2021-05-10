local r=require
local tr=r("term")
local g=r("component").gpu
local io=r("io")
local os=r("os")
local c={}
local a={}
local s=g.set
local z="/fos/system/"
function at()
f=io.open(z.."auto.cfg","r")
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
function rl()
f=io.open(z.."comp.cfg","r")
for v in f:lines() do
p=v:find(",")
if p ~= nil then
w=tonumber(v:sub(1,p-1))
h=tonumber(v:sub(p+1))
else
c[1]=v
end
end
f:close()
g.setResolution(w,h)
end
rs=pcall(rl)
if not rs then w,h=g.getResolution() end
pcall(at)
local fl=g.fill
tr.clear()
fl(w/2-3,h/2-4,2,9,"⣿")
fl(w/2-1,h/2-4,4,2,"⣿")
fl(w/2-1,h/2,3,2,"⣿")
local cl=g.setBackground
local fc=g.setForeground
local fs=r("filesystem")
function o(parm)
cl(0xffffff)
fc(0)
fl(w/2-9,h/2,18,3," ")
s(w/2-8,h/2+1,"Repairing FOS...")
end
if fs.exists(z.."lang.cfg") == false then
o()
f=io.open(z.."lang.cfg","w")
f:write("english.lang")
f:close()
end
if fs.exists(z.."user.cfg") == false then
o()
f=io.open(z.."user.cfg","w")
f:write("User\n\n0")
f:close()
end
if fs.exists(z.."comp.cfg") == false then
o()
w,h=g.maxResolution()
f=io.open(z.."comp.cfg","w")
f:write("0\n"..w..","..h)
f:close()
end
if fs.exists(z.."auto.cfg") == false then
o()
f=io.open(z.."auto.cfg","w")
f:write("")
f:close()
end
function d(e)
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
s(w/2-18,y+5,"Touch the screen to exit to Shell...")
r("event").pull("touch")
cl(0)
fc(0xffffff)
tr.clear()
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