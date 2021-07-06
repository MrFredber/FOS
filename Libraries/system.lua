local system={}
local r=require
local fs=r("filesystem")
local gpu=r("component").gpu
local screen=r("component").screen
local term=r("term")
local io=r("io")
local event=r("event")
local unicode=r("unicode")
local computer=r("computer")
local os=r("os")
local icons=r("/fos/icons")
local tools=r("/fos/tools")
local picture=r("fos/picture")
local data={}
local reg={}
local lang={}
local slang={}
local fill=gpu.fill
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set
local len=unicode.len
local max,ch,cw

function system.update(registry,language,sharedlang)
reg=registry
lang=language
slang=sharedlang
end

function system.drawMenu()
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
if reg.passwordProtection == "1" then
	color(tonumber(reg.userColor) or tonumber("0x"..reg.userColor) or math.random(16777215))
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

function system.lock(syscolor)
local txt=""
w,h=gpu.getResolution()
slen=len(reg.username)
if slen > 9 then
	xw=slen-9
else
	xw=0
end
color(syscolor)
fill(1,1,w,h," ")
slen1=len(lang.shutdown)
slen2=len(lang.reboot)
slen3=len(lang.shell)
slen4=len(lang.sleep)
tlen=slen1+slen2+slen3+slen4+11
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
set(x+10,y+2,reg.username)
fcolor(tonumber(reg.userColor) or tonumber("0x"..reg.userColor) or math.random(16777215))
set(x+2,y+1,"⢠⡶⢿⡿⢶⡄")
set(x+2,y+2,"⣿⣇⣸⣇⣸⣿")
set(x+2,y+3,"⠘⠿⣮⣵⠿⠃")
set(x+2,y+4,"⣀⣤⣿⣿⣤⣀")
fcolor(0)
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
		color(syscolor)
		fill(1,h,w,1," ")
		if txt == reg.password.."\n" then
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
		computer.shutdown()
	elseif tx >= w/2-tlen/2+slen1+3 and tx <= w/2+tlen/2+1-slen4-slen3-8 and ty == h-1 and sleep ~= 1 then
		computer.shutdown(true)
	elseif tx >= w/2+tlen/2+1-slen4-slen3-6 and tx <= w/2+tlen/2+1-slen4-5 and ty == h-1 and sleep ~= 1 then
		color(0)
		fcolor(0xffffff)
		term.clear()
		os.exit()
	elseif tx >= w/2+tlen/2+1-slen4-3 and tx <= w/2+tlen/2-1 and ty == h-1 and sleep ~= 1 then
		sleep=1
		screen.turnOff()
	elseif tx ~= nil and sleep == 1 then
		sleep=0
		screen.turnOn()
	end
end
end

function system.background(syscolor)
comp={}
w,h=gpu.getResolution()
color(0x0069ff)
fcolor(0xffffff)
fill(1,h,w,1," ")
set(1,h,"⡯")
color(syscolor)
fill(1,1,w,h-1," ")
term.setCursor(1,1)
end

function system.workplace(syscolor,sysfcolor,filesname,path)
wf=-11
hf=8
wi=-7
hi=3
i=0
while i ~= #filesname do
	i=i+1
	wf=wf+11
	wi=wi+11
	if wf+11 >= w then
		wf=0
		hf=hf+7
		wi=4
		hi=hi+7
	end
	
	filename=fs.name(filesname[i])
	p=fs.concat(path, filesname[i])

	if filesname[i]:find(".lnk",1,true) ~= nil then
		lnk={}
		appname={}
		local file=io.open(p,"r")
		for var in file:lines() do 
			table.insert(lnk, var) 
		end
		file:close()
		if fs.exists(lnk[1]) == true then
			if fs.exists(lnk[1].."/appname/"..reg.lang) == true then
				local file=io.open(lnk[1].."/appname/"..reg.lang,"r")
				for var in file:lines() do 
					table.insert(appname, var) 
				end
				file:close()
			else
				temp=unicode.sub(lnk[1],11)
				appname={temp}
			end
			slen=len(appname[1])
			if slen > 10 then
				slen=10
			end
			set(wf+8-slen/2,hf,unicode.sub(appname[1],1,slen))
			if fs.exists(lnk[1].."/icon.spic") == true then
				local file=io.open(lnk[1].."/icon.spic","r")
				local data={}
				for var in file:lines() do
					table.insert(data,var)
				end
				file:close()
				picture.spic(wi,hi,data)
			else
				icons.app(wi,hi)
			end
		else
			tools.error("Path not exists: "..lnk[1],2)
		end
	else
		slen=len(filename)
		if slen > 10 then
			slen=10
		end
		set(wf+8-slen/2,hf,unicode.sub(filename,1,slen))
		if fs.isDirectory(p) ~= false then
			icons.folder(wi,hi)
		elseif filesname[i]:find(".lua",1,true) ~= nil then
			icons.lua(wi,hi)
		elseif filesname[i]:find(".lang",1,true) ~= nil then
			icons.lang(wi,hi)
		elseif filesname[i]:find(".cfg",1,true) ~= nil then
			icons.cfg(wi,hi)
		elseif filesname[i]:find(".txt",1,true) ~= nil then
			icons.txt(wi,hi)
		elseif filesname[i]:find(".spic",1,true) ~= nil then
			icons.pic(wi,hi)
		else
			icons.unkFile(wi,hi)
		end
	end
	color(syscolor)
	fcolor(sysfcolor)
	if hf+7 > h and wf+11 > w then
		system.error(lang.manyFiles,syscolor)
	end
end
end

function system.createButtons(syscolor,filesname,sett,x,y)
cords={x={},y={}}
wb=3
hb=2
i=0
c=1
while i ~= #filesname do
	table.insert(cords.x,c,wb)
	table.insert(cords.x,c+1,wb+9)
	table.insert(cords.y,c,hb)
	table.insert(cords.y,c+1,hb+6)
	if sett == "true" then
		color(0x00ff00)
		fill(cords.x[c],cords.y[c],10,7," ")
		color(syscolor)
	end
	c=c+2
	wb=wb+11
	i=i+1
	if wb >= w-8 then
		wb=3
		hb=hb+7
	end
end
return cords
end

function system.pressButton(cords,filesname,x,y,click)
i=1
c=1
a=0
skip=0
while c-1 ~= #cords.x do
	if x >= cords.x[c] and x <= cords.x[c+1] and y >= cords.y[c] and y <= cords.y[c+1] then
		if click == 1 then
			skip=1
			a=i
		else
			color(0x7a7a7a)
			fill(cords.x[c],cords.y[c],10,7," ")
			a=i
		end
	end
	c=c+2
	i=i+1
end
return filesname[a],a,skip
end

function system.updAfterPress(filename,pos,path)
fi=1
wf=0
wi=4
hf=8
hi=3
if pos ~= 0 then
	while fi < pos do
		wf=wf+11
		wi=wf+4
		if wf+11 >= w then
			wf=0
			hf=hf+7
			hi=hf-5
			wi=4
		end
		fi=fi+1
	end
	color(0x7a7a7a)
	if filename:find(".lnk",1,true) ~= nil then
		lnk={}
		appname={}
		p=fs.concat(path,filename)
		local file=io.open(p,"r")
		for var in file:lines() do 
			table.insert(lnk, var) 
		end
		file:close()
		if fs.exists(lnk[1].."/appname/"..reg.lang) == true then
			local file=io.open(lnk[1].."/appname/"..reg.lang,"r")
			for var in file:lines() do 
				table.insert(appname, var) 
			end
			file:close()
		else
			temp=unicode.sub(lnk[1],11)
			appname={temp}
		end
		slen=len(appname[1])
		if slen > 10 then
			slen=10
		end
		set(wf+8-slen/2,hf,unicode.sub(appname[1],1,slen))
		if fs.exists(lnk[1].."/icon.spic") == true then
			local file=io.open(lnk[1].."/icon.spic","r")
			data={}
			for var in file:lines() do
				table.insert(data,var)
			end
			file:close()
			picture.spic(wi,hi,data)
		else
			icons.app(wi,hi)
		end
	else
		slen=len(filename)
		if slen > 10 then
			slen=10
		end
		set(wf+8-slen/2,hf,unicode.sub(filename,1,slen))
		if fs.isDirectory(path.."/"..filename) ~= false then
			icons.folder(wi,hi)
		elseif filename:find(".lua",1,true) ~= nil then
			icons.lua(wi,hi)
		elseif filename:find(".lang",1,true) ~= nil then
			icons.lang(wi,hi)
		elseif filename:find(".cfg",1,true) ~= nil then
			icons.cfg(wi,hi)
		elseif filename:find(".txt",1,true) ~= nil then
			icons.txt(wi,hi)
		elseif filename:find(".spic",1,true) ~= nil then
			icons.pic(wi,hi)
		else
			icons.unkFile(wi,hi)
		end
	end
end
end

function system.bsod(reason)
if reg.powerSafe == "1" then
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
if reg.powerSafe == "1" then
	fcolor(0)
else
	fcolor(0x0000ff)
end
slen=len(lang.bsod)
set(w/2-slen/2+1,2,lang.bsod)
event.pull("touch")
end

function system.error(msg,syscolor)
color(0xFF0000)
fcolor(0xffffff)
slen=len(msg)
set(w-slen+1,h-1,msg)
color(syscolor)
end

function system.createWindow(filename,path,folder)
max=12
slen1=len(slang.cancel)
tlen=slen1+7
slen=len(filename)
if slen+2 > max then
	max=slen+2
end
if tlen+2 > max then
	max=tlen+2
end
cw=math.floor(w/2-max/2)
ch=math.floor(h/2-6)
bw=math.floor(w/2-tlen/2-1)
wi=w/2-4
color(0)
fill(cw+1,ch+1,max,13," ")
color(0xffffff)
fill(cw,ch,max,13," ")
fcolor(0)
color(0xffffff)
set(w/2-slen/2,ch+6,filename)
set(cw+1,ch+8,slang.name)
tools.btn(bw+2,ch+11,"OK")
tools.btn(bw+7,ch+11,slang.cancel)
if folder == true or folder == 1 then
	icons.folder(wi,ch+1)
elseif fs.isDirectory(path.."/"..filename) ~= false then
	icons.folder(wi,ch+1)
elseif filename:find(".lua",1,true) ~= nil then
	icons.lua(wi,ch+1)
elseif filename:find(".lang",1,true) ~= nil then
	icons.lang(wi,ch+1)
elseif filename:find(".cfg",1,true) ~= nil then
	icons.cfg(wi,ch+1)
elseif filename:find(".txt",1,true) ~= nil then
	icons.txt(wi,ch+1)
elseif filename:find(".spic",1,true) ~= nil then
	icons.pic(wi,ch+1)
else
	icons.unkFile(wi,ch+1)
end
temp=""
while true do
	color(0xe0e0e0)
	fcolor(0)
	fill(cw+1,ch+9,max-2,1," ")
	set(cw+1,ch+9,temp)
	_,_,x,y=event.pull("touch")
	if x >= bw+6 and x <= bw+slen1+7 and y == ch+11 then
		temp=nil
		break
	elseif x >= bw+1 and x <= bw+4 and y == ch+11 then
		break
	elseif x >= cw+1 and x <= cw+max-2 and y == ch+9 then
		temp=tools.input()
	end
end
if temp == "" then
	temp=filename
end
return temp
end

function system.deleteWindow(filename,path)
max=12
slen1=len(slang.conDelete)
slen2=len(slang.cancel)
tlen=slen1+slen2+5
flen=len(filename)
if flen+2 > max then
	max=flen+2
end
if tlen+2 > max then
	max=tlen+2
end
if fs.isDirectory(path.."/"..filename) ~= false then
	slen=len(slang.deleteConfirmFolder)
else
	slen=len(slang.deleteConfirm)
end
if slen+2 > max then
	max=slen+2
end
cw=math.floor(w/2-max/2)
ch=math.floor(h/2-6)
bw=math.floor(w/2-tlen/2-1)
wi=w/2-4
color(0)
fill(cw+1,ch+1,max,12," ")
color(0xffffff)
fill(cw,ch,max,12," ")
fcolor(0)
color(0xffffff)
set(w/2-flen/2,ch+6,filename)
if fs.isDirectory(path.."/"..filename) ~= false then
	set(cw+1,ch+8,slang.deleteConfirmFolder)
else
	set(cw+1,ch+8,slang.deleteConfirm)
end
tools.btn(bw+2,ch+10,slang.conDelete)
tools.btn(bw+slen1+5,ch+10,slang.cancel)
if folder == true or folder == 1 then
	icons.folder(wi,ch+1)
elseif fs.isDirectory(path.."/"..filename) ~= false then
	icons.folder(wi,ch+1)
elseif filename:find(".lua",1,true) ~= nil then
	icons.lua(wi,ch+1)
elseif filename:find(".lang",1,true) ~= nil then
	icons.lang(wi,ch+1)
elseif filename:find(".cfg",1,true) ~= nil then
	icons.cfg(wi,ch+1)
elseif filename:find(".txt",1,true) ~= nil then
	icons.txt(wi,ch+1)
elseif filename:find(".spic",1,true) ~= nil then
	icons.pic(wi,ch+1)
else
	icons.unkFile(wi,ch+1)
end
while true do
	_,_,x,y=event.pull("touch")
	if x >= bw+1 and x <= bw+slen1+2 and y == ch+10 then
		break
	elseif x >= bw+slen1+4 and x <= bw+slen1+slen2+5 and y == ch+10 then
		filename=nil
		break
	end
end
return filename
end
return system