local system={}
local r=require
local fs=r("filesystem")
local gpu=r("component").gpu
local screen=r("component").screen
local term=r("term")
local io=r("io")
local event=r("event")
local unicode=r("unicode")
local comp=r("computer")
local os=r("os")
local icons=r("/fos/icons")
local tools=r("/fos/tools")
local picture=r("fos/picture")
local data={}
local fill=gpu.fill
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set
local len=unicode.len
local comp={}
file=io.open("/fos/system/comp.cfg","r")
for var in file:lines() do table.insert(comp,var) end
file:close()

function system.shell()
lang={}
sett={}
file=io.open("/fos/system/lang.cfg","r")
for var in file:lines() do table.insert(sett,var) end
file:close()
file=io.open(fs.concat("/fos/lang/fos",sett[1]), "r")
for var in file:lines() do
check=var:find("=")
if check ~= nil then
arg=unicode.sub(var,1,check-1)
var=unicode.sub(var,check+1)
lang[arg]=var
else
table.insert(lang,var)
end
end
file:close()
color(0)
fcolor(0xffffff)
term.clear()
color(0x2b2b2b)
fill(1,1,w,1,"-")
slen=unicode.len(lang.shellExit)
set(w/2-slen/2,1,lang.shellExit)
slen=unicode.len(lang.shellMsg)
set(w/2-slen/2,2,lang.shellMsg)
term.setCursor(1,3)
lang=nil
arg=nil
check=nil
os.exit()
end

function system.drawMenu(lang,user)
data={}
fcolor(0xffffff)
i=1
smax=0
local t={"shell","shutdown","reboot","sleep","logoff"}
while i ~= 4 do
	slen=len(lang[t[i]])
	if slen > smax then
		smax=slen
	end
	i=i+1
end
data=picture.screenshot(1,h-5,smax,5)
if user[3] == "1" then
	color(tonumber(user[2]) or tonumber("0x"..user[2]) or math.random(16777215))
	fill(1,h-5,smax,1," ")
	offset=0
	slen=len(lang.logoff)
	if slen <= smax-1 then
		div=slen/2
		offset=smax/2-div
	end
	set(1+offset,h-5,lang.logoff)
end
color(0x009400)
fill(1,h-4,smax,1," ")
offset=0
slen=len(lang.shell)
if slen <= smax-1 then
	div=slen/2
	offset=smax/2-div
end
set(1+offset,h-4,lang.shell)
color(0x0000ff)
fill(1,h-3,smax,1," ")
offset=0
slen=len(lang.sleep)
if slen <= smax-1 then
	div=slen/2
	offset=smax/2-div
end
set(1+offset,h-3,lang.sleep)
color(0xb40000)
fill(1,h-2,smax,1," ")
offset=0
slen=len(lang.shutdown)
if slen <= smax-1 then
	div=slen/2
	offset=smax/2-div
end
set(1+offset,h-2,lang.shutdown)
color(0xffb400)
fill(1,h-1,smax,1," ")
offset=0
slen=len(lang.reboot)
if slen <= smax-1 then
	div=slen/2
	offset=smax/2-div
end
set(1+offset,h-1,lang.reboot)
return smax,data
end

function system.lock(lang)
local user={}
local txt=""
file=io.open("/fos/system/user.cfg","r")
for var in file:lines() do table.insert(user,var) end
file:close()
w,h=gpu.getResolution()
slen=len(user[1])
if slen > 9 then
	xw=slen-9
else
	xw=0
end
if comp[1] == "1" then
	color(0)
else
	color(0x2b2b2b)
end
fill(1,1,w,h," ")
slen1=len(lang.shutdown)
slen2=len(lang.reboot)
slen3=len(lang.shell)
slen4=len(lang.sleep)
tlen=slen1+slen2+slen3+len(lang.sleep)+11
tools.btn(w/2-tlen/2+1,h-1,lang.shutdown)
tools.btn(w/2-tlen/2+1+slen1+3,h-1,lang.reboot)
tools.btn(w/2+tlen/2+1-slen4-slen3-5,h-1,lang.shell)
tools.btn(w/2+tlen/2+1-slen4-2,h-1,lang.sleep)
x=w/2-9-xw/2
y=h/2-3
color(0)
fill(x+1,y+1,20+xw,6," ")
color(0xe0e0e0)
fill(x,y,20+xw,6," ")
fcolor(0)
set(x+10,y+2,user[1])
color(tonumber(user[2]) or tonumber("0x"..user[2]) or math.random(16777215))
set(x+3,y+1,"    ")
set(x+3,y+2,"    ")
set(x+4,y+3,"  ")
set(x+2,y+4,"      ")
color(0xffffff)
fill(x+10,y+3,9+xw,1," ")
sleep=0
while true do
local _,_,tx,ty=event.pull("touch")
if tx >= x+10 and tx <= x+18+xw and ty == math.floor(y+3) then
	color(0xffffff)
	term.setCursor(1,h)
	fill(x+10,y+3,9+xw,1," ")
	fill(1,h,w,1," ")
	txt=term.read({},true,"","*")
	slen=len(txt)
	if slen > 9+xw then
		slen=9+xw
	else
		slen=slen-1
	end
	fill(x+10,y+3,slen,1,"*")
	if comp[1] == "1" then
		color(0)
	else
		color(0x2b2b2b)
	end
	fill(1,h,w,1," ")
	if txt == user[4].."\n" then
		break
	else
		slen=len(lang.incorrect)
		color(0xe0e0e0)
		fcolor(0)
		x1=x+10
		x2=x+10+9+xw
		xi=(x1+x2)/2
		set(xi-slen/2,y+4,lang.incorrect)
	end
elseif tx >= w/2-tlen/2 and tx <= w/2-tlen/2+1+slen1 and ty == h-1 and sleep ~= 1 then
	comp.shutdown()
elseif tx >= w/2-tlen/2+slen1+3 and tx <= w/2+tlen/2+1-slen4-slen3-8 and ty == h-1 and sleep ~= 1 then
	comp.shutdown(true)
elseif tx >= w/2+tlen/2+1-slen4-slen3-6 and tx <= w/2+tlen/2+1-slen4-5 and ty == h-1 and sleep ~= 1 then
	system.shell(lang)
elseif tx >= w/2+tlen/2+1-slen4-3 and tx <= w/2+tlen/2-1 and ty == h-1 and sleep ~= 1 then
	sleep=1
	screen.turnOff()
elseif tx ~= nil and sleep == 1 then
	sleep=0
	screen.turnOn()
end
end
end

function system.background()
comp={}
file=io.open("/fos/system/comp.cfg","r")
for var in file:lines() do table.insert(comp,var) end
file:close()
w,h=gpu.getResolution()
color(0x0069ff)
fcolor(0xffffff)
fill(1,h,w,1," ")
set(1,h,"⡯")
if comp[1] == "1" then
	color(0)
else
	color(0x2b2b2b)
end
fill(1,1,w,h-1," ")
term.setCursor(1,1)
end

function system.workplace(filesname,path,lang,langsett)
wf=0--начало имени файла
hf=8--начало имени файла
wi=4--координаты иконок
hi=3--координаты иконок
i=0
while i ~= #filesname do
  i=i+1
  if wf+12 >= w then
    wf=0
    hf=hf+7
    wi=4
    hi=hi+7
  end
  
  filename=fs.name(filesname[i])
  p=fs.concat(path, filesname[i])
  dir=fs.isDirectory(p)

  if filesname[i]:find(".lnk",1,true) ~= nil then
  	lnk={}
  	appname={}
  	lnkfile=io.open(p,"r")
	for var in lnkfile:lines() do 
		table.insert(lnk, var) 
	end
	lnkfile:close()
	appnamefile=io.open(lnk[1].."/appname/"..langsett[1],"r")
	for var in appnamefile:lines() do 
		table.insert(appname, var) 
	end
	appnamefile:close()
	slen=len(appname[1])
	if slen > 10 then
		slen=10
	end
    set(wf+8-slen/2,hf,unicode.sub(appname[1],1,slen))
    iconfile=io.open(lnk[1].."/icon.spic","r")
    icondata={}
    for var in iconfile:lines() do
      table.insert(icondata,var)
    end
    iconfile:close()
    picture.spic(wi,hi,icondata)
  else
    slen=len(filename)
  if slen > 10 then
    slen=10
  end
  set(wf+8-slen/2,hf,unicode.sub(filename,1,slen))
  if dir ~= false then
    icons.folder(wi,hi)
  elseif filesname[i]:find(".lua",1,true) ~= nil then
    icons.lua(wi,hi)
  elseif filesname[i]:find(".lang",1,true) ~= nil then
    icons.lang(wi,hi)
  elseif filesname[i]:find(".cfg",1,true) ~= nil then
    icons.cfg(wi,hi)
  elseif filesname[i]:find(".txt",1,true) ~= nil then
    icons.txt(wi,hi)
  else
    icons.unkFile(wi,hi)
  end
  end
  if comp[1] == "1" then
	color(0)
  else
	color(0x2b2b2b)
  end
  fcolor(0xffffff)
  wf=wf+11
  wi=wi+11
  if hf+7 > h and wf+11 > w then
    system.error(lang)
  end
end
end

function system.createButtons(filesname,sett,x,y)
color(0x00ff00)
cords={x={},y={}}
wb=3
hb=2
i=0 --i местоположения
c=1 --i таблицы
while i ~= #filesname do
  table.insert(cords.x,c,wb)
  table.insert(cords.x,c+1,wb+9)
  table.insert(cords.y,c,hb)
  table.insert(cords.y,c+1,hb+6)
  if sett == "true" then
    fill(cords.x[c],cords.y[c],10,7," ")
  end
  c=c+2
  wb=wb+11
  i=i+1
  if wb >= w-8 then
    wb=3
    hb=hb+7
  end
end
if comp[1] == "1" then
	color(0)
else
	color(0x2b2b2b)
end
return cords
end

function system.pressButton(cords,filesname,x,y)
i=1
c=1
a=0--i файла
while c-1 ~= #cords.x do
  if x >= cords.x[c] and x <= cords.x[c+1] and y >= cords.y[c] and y <= cords.y[c+1] then
    color(0x7a7a7a)
    fill(cords.x[c],cords.y[c],10,7," ")
    a=i
  end
  c=c+2
  i=i+1
end
return filesname[a],a
end

function system.updAfterPress(filename,pos,lang,langsett,path)
fi=1
wf=0
wi=4
hf=8
hi=3
if pos ~= 0 then
  while fi < pos do
    if wf+12 >= w then
      wf=0
      hf=hf+7
      hi=hf-5
    end
    wf=wf+11
    wi=wf+4
    fi=fi+1
  end
  dir=fs.isDirectory(path..filename)
  color(0x7a7a7a)
if filename:find(".lnk",1,true) ~= nil then
  	lnk={}
  	appname={}
  	p=fs.concat(path,filename)
	lnkfile=io.open(p,"r")
	for var in lnkfile:lines() do 
		table.insert(lnk, var) 
	end
	lnkfile:close()
	appnamefile=io.open(lnk[1].."/appname/"..langsett[1],"r")
	for var in appnamefile:lines() do 
		table.insert(appname, var) 
	end
	appnamefile:close()
	slen=len(appname[1])
	if slen > 10 then
		slen=10
	end
    set(wf+8-slen/2,hf,unicode.sub(appname[1],1,slen))
    iconfile=io.open(lnk[1].."/icon.spic","r")
    icondata={}
    for var in iconfile:lines() do
      table.insert(icondata,var)
    end
    iconfile:close()
    picture.spic(wi,hi,icondata)
else
	slen=len(filename)
	if slen > 10 then
		slen=10
	end
	set(wf+8-slen/2,hf,unicode.sub(filename,1,slen))
	if dir ~= false then
		icons.folder(wi,hi)
	elseif filename:find(".lua",1,true) ~= nil then
		icons.lua(wi,hi)
	elseif filename:find(".lang",1,true) ~= nil then
		icons.lang(wi,hi)
	elseif filename:find(".cfg",1,true) ~= nil then
		icons.cfg(wi,hi)
	elseif filename:find(".txt",1,true) ~= nil then
		icons.txt(wi,hi)
	else
		icons.unkFile(wi,hi)
	end
	end
end
end

function system.bsod(reason,lang)
if comp[1] == "1" then
	color(0)
else
	color(0x0000ff)
end
fcolor(0xffffff)
fill(1,1,w,h," ")
term.setCursor(1,4)
print(reason)
_,y=term.getCursor()
slen=len(lang.bsodExit)
set(w/2-slen/2+1,y+1,lang.bsodExit)
color(0xffffff)
if comp[1] == "1" then
	fcolor(0)
else
	fcolor(0x0000ff)
end
slen=len(lang.bsod)
set(w/2-slen/2+1,2,lang.bsod)
event.pull("touch")
end

function system.error(lang)
color(0xFF0000)
slen=len(lang.manyFiles)
set(w-slen,h-1,lang.manyFiles)
if comp[1] == "1" then
	color(0)
else
	color(0x2b2b2b)
end
end
return system