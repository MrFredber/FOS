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
local data,reg,lang,slang={},{},{},{}
local fill=gpu.fill
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set
local len=unicode.len
local max,ch,cw,w,h,time,timeCorrection

function system.update(registry,language,sharedlang)
w,h=gpu.getResolution()
reg=registry
lang=language
slang=sharedlang
if reg.darkMode == "1" then
	maincolor=0x202020
	secondcolor=0x404040
	mainfcolor=0xffffff
	secondfcolor=0xbbbbbb
else
	maincolor=0xdddddd
	secondcolor=0xffffff
	mainfcolor=0
	secondfcolor=0x707070
end
tools.update(reg)
timeCorrection=reg.timeZone*3600
temp=io.open("/tmp/time","w")
temp:close()
temp=fs.lastModified("/tmp/time")
time=tonumber(string.sub(temp,1,-4))+timeCorrection
return w,h
end

function system.drawMenu()
data={}
color(maincolor)
i=1
smax=26
data=picture.screenshot(1,h-14,smax+1,14)
fill(1,h-14,smax,14," ")
local userColor=tonumber(reg.userColor) or tonumber("0x"..reg.userColor) or math.random(16777215)
fcolor(userColor)
set(2,h-13,"⢠⡶⢿⡿⢶⡄")
set(2,h-12,"⣿⣇⣸⣇⣸⣿")
set(2,h-11,"⠘⠿⣮⣵⠿⠃")
set(2,h-10,"⣀⣤⣿⣿⣤⣀")
fcolor(mainfcolor)
set(10,h-12,unicode.sub(reg.username,1,15))
color(secondcolor)
fill(2,h-8,24,8," ")
set(3,h-8,lang.shell)
set(3,h-6,lang.sleep)
set(3,h-4,lang.shutdown)
set(3,h-2,lang.reboot)
fcolor(secondcolor)
color(maincolor)
set(2,h-9,"⢀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⡀")
set(2,h-1,"⠈⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠁")
set(2,h-7,"⢈⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⡁")
set(2,h-5,"⢈⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⡁")
set(2,h-3,"⢈⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⣉⡁")
fcolor(secondfcolor)
if reg.passwordProtection == "1" then
	set(10,h-11,unicode.sub(slang.passwordYes,1,15))
else
	set(10,h-11,unicode.sub(slang.passwordNo,1,15))
end
if reg.powerSafe == "1" then
	color(0)
else
	color(0x2b2b2b)
end
fcolor(maincolor)
set(26,h-14,"⣷")
fcolor(0x101010)
set(27,h-14,"⣄")
fill(27,h-13,1,13,"⣿")
return smax,data
end

system.taskbarList={}

function system.taskbar(_,_,x,y,click)
clr=gpu.getBackground()
fclr=gpu.getForeground()
color(0x0069ff)
fcolor(0xffffff)
fill(1,h,w,1," ")
set(1,h,"⡯")
--if x == 1 and y == h and sleep ~= 1 and click == 0 then
--	smax,data=system.drawMenu()
--elseif x == 1 and y == h and sleep ~= 1 and click == 1 and system.menu == 0 then
--	pos=tools.conMenu(1,h-1,{lang.about})
--	if pos == 1 then
--		tools.error("Coming soon.")
--	end
--end
color(clr)
fcolor(fclr)
end

function system.taskbarTime()
clr=gpu.getBackground()
fclr=gpu.getForeground()
color(0x0069ff)
fcolor(0xffffff)
time=time+1
if reg.taskbarShowSeconds == "1" then
	set(w-8,h,os.date('%H:%M:%S',time))
else
	set(w-5,h,os.date('%H:%M',time))
end
color(clr)
fcolor(fclr)
end

function system.lock(syscolor)
local txt=""
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

function system.background(syscolor,sysfcolor)
--event.listen("touch",system.taskbar)
system.taskbar()
color(syscolor)
fcolor(sysfcolor)
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
	p=fs.concat(path,filesname[i])

	if filesname[i]:find(".lnk",1,true) ~= nil then
		lnk={}
		appname={}
		local file=io.open(p,"r")
		for var in file:lines() do 
			table.insert(lnk, var) 
		end
		file:close()
		if fs.exists(lnk[1] or "Null") == true then
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
				temp=unicode.sub(appname[1],1,9).."…"
			else
				temp=appname[1]
			end
			set(wf+8-slen/2,hf,temp)
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
			lnk[1]="Null"
			tools.error({"Path not exists: "..lnk[1]},2)
			color(syscolor)
			icons.error(wi,hi)
			slen=len(filename)
			if slen > 10 then
				slen=9
				temp=unicode.sub(filename,1,slen).."…"
			else
				temp=filename
			end
			set(wf+8-slen/2,hf,temp)
		end
	else
		slen=len(filename)
		if slen > 10 then
			slen=10
			temp=unicode.sub(filename,1,9).."…"
		else
			temp=filename
		end
		set(wf+8-slen/2,hf,temp)
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
	if hf+7 > h then
		system.error(lang.manyFiles,syscolor,sysfcolor)
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
			temp=unicode.sub(appname[1],1,9).."…"
		else
			temp=appname[1]
		end
		set(wf+8-slen/2,hf,temp)
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
			temp=unicode.sub(filename,1,9).."…"
		else
			temp=filename
		end
		set(wf+8-slen/2,hf,temp)
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
term.setCursor(1,3)
print(reason)
color(0xffffff)
if reg.powerSafe == "1" then
	fcolor(0)
else
	fcolor(0x0000ff)
end
slen=len(" "..lang.bsod.." ")
set(w/2-slen/2+1,1," "..lang.bsod.." ")
slen=len(" "..lang.bsodExit.." ")
set(w/2-slen/2+1,h," "..lang.bsodExit.." ")
computer.beep("...")
event.pull("touch")
end

function system.error(msg,syscolor,sysfcolor)
color(0xFF0000)
fcolor(0xffffff)
slen=len(msg)
set(w-slen+1,h-1,msg)
color(syscolor)
fcolor(sysfcolor)
end

function system.createWindow(filename,path,folder)
max=12
maxh=10
slen1=len(slang.cancel)
tlen=slen1+7
fslen=len(filename)
if tlen+2 > max then
	max=tlen+2
end
cw=math.floor(w/2-max/2)
ch=math.floor(h/2-5)
bw=math.floor(w/2-tlen/2-1)
_,_,temp1=gpu.get(cw,ch)
_,_,temp2=gpu.get(cw+max,ch)
_,_,temp3=gpu.get(cw,ch+maxh-1)
data=picture.screenshot(cw,ch,max+1,maxh+1)
color(secondcolor)
fcolor(mainfcolor)
fill(cw,ch,max,10," ")
wi=w/2-4
if fslen > 10 then
	set(w/2-5,ch+6,unicode.sub(filename,1,9).."…")
else
	set(w/2-fslen/2,ch+6,filename)
end
tools.btn(bw+1,ch+8,"OK")
tools.btn(bw+6,ch+8,slang.cancel)
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
fcolor(secondcolor)
color(temp1)
set(cw,ch,"⣾")
color(temp2)
set(cw+max-1,ch,"⣷")
color(temp3)
set(cw,ch+maxh-1,"⢿")
color(0x101010)
set(cw+max-1,ch+maxh-1,"⡿")
fcolor(0x101010)
_,_,temp=gpu.get(cw+max-1,ch)
color(temp)
set(cw+max,ch,"⣄")
fill(cw+max,ch+1,1,maxh-1,"⣿")
text=""
for i=1,max-2 do
	text=text.."⠛"
end
picture.adaptiveText(cw+1,ch+maxh,"⠙"..text.."⠋",0x101010)
temp=filename
while true do
	_,_,x,y=event.pull("touch")
	if x >= bw+6 and x <= bw+slen1+7 and y == ch+8 then
		temp=nil
		break
	elseif x >= bw+1 and x <= bw+4 and y == ch+8 then
		break
	elseif x >= math.floor(w/2-fslen/2) and x <= math.floor(w/2+fslen/2) and y == ch+6 then
		temp=tools.input(w/2-5,ch+6,10,"0",filename,"1")
		if temp ~= "" then
			filename=temp
			fslen=len(temp)
		end
		color(secondcolor)
		fcolor(mainfcolor)
		fill(w/2-5,ch+6,10,1," ")
		if fslen > 10 then
			set(w/2-5,ch+6,unicode.sub(filename,1,9).."…")
		else
			set(w/2-fslen/2,ch+6,filename)
		end
	end
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