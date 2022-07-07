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
local finder=r("fos/finder")
local fill=gpu.fill
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set
local len=unicode.len
local sub=unicode.sub
local users,lang,slang,user,nlang,choosebfr={},{},{},{},{},{}
local time,w,h,file,data,open,timerid,path,slen,ext,tmpext,tmppath
local reasonY,hlimit=0,0
local incorrect,enter,first=false,false,true
local full=computer.totalMemory()

function system.getUserSettings()
return user
end

function system.init(notLogged)
data={}
if notLogged == true then
	file=io.open("/fos/system/generalSettings.cfg","r")
	for var in file:lines() do
		table.insert(data,var)
	end
	file:close()
else
	file=io.open("/fos/users/"..users[open].name.."/settings.cfg")
	for var in file:lines() do
		table.insert(data,var)
	end
	file:close()
end
user={}
user=finder.unserialize(data)
if notLogged ~= true then
	user.name=users[open].name
	user.path="/fos/users/"..users[open].name.."/"
end
w,h=gpu.getResolution()
secondfcolor=0x808080
if user.powerSafe then
	maincolor=0
	secondcolor=0x303030
	thirdcolor=0x404040
	mainfcolor=0xffffff
elseif user.darkMode then
	maincolor=0x202020
	secondcolor=0x303030
	thirdcolor=0x404040
	mainfcolor=0xffffff
else
	maincolor=0xdddddd
	secondcolor=0xeeeeee
	thirdcolor=0xffffff
	mainfcolor=0
end
timeCorrection=user.timeZone*3600
temp=io.open("/tmp/time","w")
temp:close()
temp=fs.lastModified("/tmp/time")
time=tonumber(sub(temp,1,-4))+timeCorrection
file=io.open("/fos/lang/fos/"..user.lang,"r")
data={}
for var in file:lines() do
	table.insert(data,var)
end
file:close()
lang=finder.unserialize(data)
file=io.open("/fos/lang/shared/"..user.lang,"r")
data={}
for var in file:lines() do
	table.insert(data,var)
end
file:close()
slang=finder.unserialize(data)
file=io.open("/fos/lang/names/"..user.lang,"r")
data={}
for var in file:lines() do
	table.insert(data,var)
end
file:close()
nlang=finder.unserialize(data)
tools.update(user)
return w,h,user,lang,slang,nlang
end

local function logintime()
time=time+1
clr=gpu.getBackground()
fclr=gpu.getForeground()
color(0x2b2b2b)
fcolor(0xffffff)
set(w/2-2,h/2-5,os.date('%H:%M',time))
color(clr)
fcolor(fclr)
end

function system.taskbarDraw()
color(maincolor)
fill(1,h,w,1," ")
fcolor(0x0094ff)
set(1,h," ⡯ ")
fcolor(mainfcolor)
if user.taskbarShowSeconds then
	set(w-8,h,os.date('%H:%M:%S',time))
else
	set(w-5,h,os.date('%H:%M',time))
end
end

local function logindraw()
if open == 0 then
	color(0x2b2b2b)
	fcolor(0xffffff)
	fill(1,1,w,h," ")
	set(w/2-2,h/2-5,os.date('%H:%M',time))
	for i=1,#users do
		color(0x2b2b2b)
		fcolor(0xffffff)
		set(users[i].x+8-(len(users[i].name)/2),users[i].y+6,users[i].name)
		icons.user(users[i].x+4,users[i].y+1,users[i].data.userColor)
	end
else
	color(0x2b2b2b)
	fcolor(0xffffff)
	fill(1,1,w,h," ")
	set(w/2-2,h/2-5,os.date('%H:%M',time))
	set(w/2-(len(users[open].name)/2)+1,h/2+2,users[open].name)
	if incorrect == true then
		set(w/2-(len(lang.passwordIncor)/2)+1,h/2+6,lang.passwordIncor)
	end
	fcolor(secondfcolor)
	set(w/2-4,h/2+4,lang.password)
	icons.user(w/2-3,h/2-3,users[open].data.userColor)
	color(0x0094ff)
	fcolor(0xffffff)
	set(w/2-7,h/2+4," < ")
end
end

local function loginEnter()
user=users[open].data
user.name=users[open].name
user.path="/fos/users/"..users[open].name.."/"
incorrect=false
event.cancel(timerid)
fs.remove("/tmp/timerid")
color(0x2b2b2b)
fcolor(0xffffff)
fill(1,1,w,h," ")
temp=lang.welcome:format(users[open].name)
set(w/2-(len(temp)/2),h/2,temp)
end

function system.login()
color(0x2b2b2b)
fill(1,1,w,h," ")
set(w/2-(len(lang.prepare)/2),h/2,lang.prepare)
open=0
users={}
tmp=finder.files("/fos/users")
spos=w/2-(8*#tmp)
for i=1,#tmp do
	users[i]={x=spos-15+(16*i),y=h/2-3,name=sub(tmp[i],1,len(tmp[i])-1)}
	if fs.exists("/fos/users/"..tmp[i].."settings.cfg") then
		file=io.open("/fos/users/"..tmp[i].."settings.cfg","r")
		data={}
		for var in file:lines() do
			table.insert(data,var)
		end
		file:close()
		data=finder.unserialize(data)
		users[i].data=data
	else
		users[i].data={userColor=0x0094ff}
	end
end
if #users > 1 or users[1].data.passwordProtection then
	timerid=event.timer(1,logintime,math.huge)
	file=io.open("/tmp/timerid","w")
	file:write(timerid)
	file:close()
	tmp=""
	logindraw()
	while true do
		if (open ~= 0 and users[open].data.passwordProtection ~= true) or enter then
		enter=false
			loginEnter()
			break
		end
		if first and open ~= 0 then
			tmp=tools.input(w/2-4,h/2+4,13,true,lang.password)
			if tmp == users[open].data.password then
				enter=true
			else
				incorrect=true
			end
			first=false
		else
			tip,_,x,y,click=event.pull()
		end
		if tip == "touch" then
			if open == 0 then
				for i=1,#users do
					if x >= users[i].x and x <= users[i].x+16 and y >= users[i].y and y <= users[i].y+6 then
						open=i
						first=true
					end
				end
			else
				if x >= w/2-7 and x <= w/2-5 and y == math.floor(h/2+4) then
					open=0
				elseif x >= w/2-4 and x <= w/2+5 and y == math.floor(h/2+4) then
					tmp=tools.input(w/2-4,h/2+4,13,true,lang.password)
					if tmp == users[open].data.password then
						loginEnter()
						break
					else
						incorrect=true
					end
				end
			end
			logindraw()
		end
	end
else
	open=1
	user=users[1].data
	user.name=users[1].name
	user.path="/fos/users/"..users[1].name.."/"
	color(0x2b2b2b)
	fcolor(0xffffff)
	fill(1,1,w,h," ")
	temp=lang.welcome:format(user.name)
	set(w/2-(len(temp)/2),h/2,temp)
end
end

function system.drawMenu()
data={}
color(maincolor)
i=1
smax=26
data=picture.screenshot(1,h-14,smax+1,14)
_,_,clr=gpu.get(26,h-14)
fill(1,h-14,smax,14," ")
local userColor=user.userColor or 0x0094ff
fcolor(mainfcolor)
set(11,h-12,sub(user.name,1,15))
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
if user.passwordProtection == true then
	set(11,h-11,sub(slang.passwordYes,1,15))
else
	set(11,h-11,sub(slang.passwordNo,1,15))
end
color(clr)
fcolor(maincolor)
set(26,h-14,"⣷")
fcolor(0x101010)
set(27,h-14,"⣄")
fill(27,h-13,1,13,"⣿")
color(maincolor)
icons.user(2,h-13,userColor)
return smax,data
end

local function clock()
clr=gpu.getBackground()
fclr=gpu.getForeground()
free=computer.freeMemory()
color(maincolor)
fcolor(mainfcolor)
set(5,h,finder.verbalSize(full-free).."/"..finder.verbalSize(full).." (free "..finder.verbalSize(free)..")")
time=time+1
if user.taskbarShowSeconds then
	set(w-8,h,os.date('%H:%M:%S',time))
else
	set(w-5,h,os.date('%H:%M',time))
end
color(clr)
fcolor(fclr)
end

local function inputField(temp,tmp)
_,_,temp1=gpu.get(w/2-12,h-5)
_,_,temp2=gpu.get(w/2+14,h-5)
_,_,temp3=gpu.get(w/2-12,h-3)
_,_,temp4=gpu.get(w/2+14,h-3)
color(thirdcolor)
fcolor(mainfcolor)
fill(w/2-12,h-5,27,3," ")
fcolor(thirdcolor)
color(temp1)
set(w/2-12,h-5,"⣾")
color(temp2)
set(w/2+14,h-5,"⣷")
color(temp3)
set(w/2-12,h-3,"⢿")
color(temp4)
set(w/2+14,h-3,"⡿")
temp=tools.input(w/2-10,h-4,23,_,temp,tmp)
return temp
end

function system.newFile()
temp=inputField(slang.nameFile)
if temp == "" then temp=nil end
return temp
end

function system.newFolder()
temp=inputField(slang.nameFolder)
if temp == "" then temp=nil end
return temp
end

function system.rename(temp)
temp=inputField(temp,true)
if temp == "" then temp=nil end
return temp
end

function system.deleteConfirm(obl,a)
if w/3 > 27 then
	width=math.floor(w/3)
else
	width=27
end
local x=math.floor(w/2-(width/2)+1)
_,_,temp1=gpu.get(x,h/2-5)
_,_,temp2=gpu.get(x+width-1,h/2-5)
_,_,temp3=gpu.get(x,h/2+6)
_,_,temp4=gpu.get(x+width-1,h/2+6)
text=tools.wrap(slang.deleteConfirm,width-16)
color(thirdcolor)
fcolor(mainfcolor)
fill(x,h/2-5,width,12," ")
set(x+2,h/2-5,slang.deleteHeader)
set(x+width-5,h/2-5,"  x  ")
set((x+x+14)/2-(len(obl.names[a])/2),h/2+2,obl.names[a])
for i=1,#text do
	set(x+14,h/2-4+i,text[i])
end
slen=len(slang.no)
slen1=len(slang.yes)
fcolor(0x808080)
set(x+width-6-slen-slen1,h/2+5,slang.yes)
wi,hi=x+3,h/2-3
tools.btn(x+width-4-slen,h/2+5,slang.no)
if fs.isDirectory(obl.paths[a]) ~= false then
	icons.folder(wi,hi)
elseif obl.exts[a] == ".lua" then
	icons.lua(wi,hi)
elseif obl.exts[a] == ".lang" then
	icons.lang(wi,hi)
elseif obl.exts[a] == ".cfg" then
	icons.cfg(wi,hi)
elseif obl.exts[a] == ".txt" then
	icons.txt(wi,hi)
elseif obl.exts[a] == ".spic" or obl.exts[a] == ".pic" then
	icons.pic(wi,hi)
else
	icons.unkFile(wi,hi)
end
fcolor(thirdcolor)
color(temp1)
set(x,h/2-5,"⣾")
color(temp2)
set(x+width-1,h/2-5,"⣷")
color(temp3)
set(x,h/2+6,"⢿")
color(temp4)
set(x+width-1,h/2+6,"⡿")
local delchoose
fcolor(0xffffff)
while true do
	_,_,mx,my=event.pull("touch")
	if mx >= x+width-6-slen-slen1 and mx <= x+width-7-slen and my == math.floor(h/2+5) then
		delchoose=true
		break
	elseif (mx >= x+width-4-slen and mx <= x+width-3 and my == math.floor(h/2+5)) or (mx >= x+width-4 and mx <= x+width-2 and my == math.floor(h/2-5)) then
		delchoose=false
		break
	end
end
return delchoose
end

function system.objects(x,y,path,files)
path=path:lower()
local wi,hi,wf,hf=x+1,y,x,y+5
local data={x={},y={},paths={},exts={},tmpexts={},names={},notExists={},fullNames={}}
for i=1,#files do
	notExists=false
	if wf+9 >= w then
		wi,wf,hi,hf=x+1,x,hi+7,hf+7
	end
	table.insert(data.x,wf)
	table.insert(data.y,hi)
	tmp=fs.name(files[i])
	ext=finder.ext(tmp)
	tmppath=nil
	tmpext=nil
	if ext == ".lnk" then
		file=io.open(path..files[i],"r")
		temp={}
		for var in file:lines() do
		table.insert(temp,var)
		end
		file:close()
		if fs.exists(temp[1] or "null") then
			tmppath=temp[1]:lower()
			tmp=fs.name(temp[1])
			tmpext=finder.ext(tmp)
		else
			notExists=true
		end
	end
	if tmppath ~= nil then
		table.insert(data.paths,tmppath)
	else
		table.insert(data.paths,path..files[i])
	end
	if tmpext ~= nil then
		data.tmpexts[i]=tmpext
	end
	if ext ~= nil then
		data.exts[i]=ext
	end
	if nlang[tmppath] ~= nil then
		tmp=nlang[tmppath]
	elseif nlang[path..files[i]:lower()] ~= nil then
		tmp=nlang[path..files[i]:lower()]
	end
	slen=len(tmp)
	table.insert(data.fullNames,tmp)
	if slen > 10 then
		slen=10
		tmp=sub(tmp,1,9).."…"
	end
	if notExists then
		fcolor(0xff0000)
	end
	picture.adaptiveText(wf+((10-slen)/2),hf,tmp)
	if notExists then
		icons.error(wi,hi)
	elseif tmppath ~= nil then
		if tmpext == ".app" then
			if fs.exists(tmppath.."icon.pic") then
				icn={}
				file=io.open(tmppath.."icon.pic")
				for var in file:lines() do
					table.insert(icn,var)
				end
				file:close()
				icn=finder.unserialize(icn)
				icn=picture.decompress(icn)
				picture.draw(wi,hi,icn)
			else
				icons.app(wi,hi)
			end
		elseif fs.isDirectory(tmppath) ~= false then
			icons.folder(wi,hi)
		elseif tmpext == ".lua" then
			icons.lua(wi,hi)
		elseif tmpext == ".lang" then
			icons.lang(wi,hi)
		elseif tmpext == ".cfg" then
			icons.cfg(wi,hi)
		elseif tmpext == ".txt" then
			icons.txt(wi,hi)
		elseif tmpext == ".spic" or tmpext == ".pic" then
			icons.pic(wi,hi)
		else
			icons.unkFile(wi,hi)
		end
	else
		if ext == ".app" then
			if fs.exists(path..files[i].."icon.pic") then
				icn={}
				file=io.open(path..files[i].."icon.pic")
				for var in file:lines() do
					table.insert(icn,var)
				end
				file:close()
				icn=finder.unserialize(icn)
				icn=picture.decompress(icn)
				picture.draw(wi,hi,icn)
			else
				icons.app(wi,hi)
			end
		elseif fs.isDirectory(path..files[i]) ~= false then
			icons.folder(wi,hi)
		elseif ext == ".lua" then
			icons.lua(wi,hi)
		elseif ext == ".lang" then
			icons.lang(wi,hi)
		elseif ext == ".cfg" then
			icons.cfg(wi,hi)
		elseif ext == ".txt" then
			icons.txt(wi,hi)
		elseif ext == ".spic" or ext == ".pic" then
			icons.pic(wi,hi)
		else
			icons.unkFile(wi,hi)
		end
	end
	if ext == ".lnk" then
		color(0xffffff)
		fcolor(0)
		set(wi+7,hi+3,"<")
	end
	table.insert(data.names,tmp)
	table.insert(data.notExists,notExists)
	wi,wf=wi+11,wf+11
end
return data
end

function system.drawChooseReset()
	choosebfr={}
end

function system.drawChoose(obl,a,restore)
if restore then
	picture.draw(obl.x[a],obl.y[a]-1,choosebfr[a])
else
	choosebfr[a]=picture.screenshot(obl.x[a],obl.y[a]-1,10,8)
	color(user.contrastColor)
	fill(obl.x[a],obl.y[a],10,6," ")
	if obl.notExists[a] then
		icons.error(obl.x[a]+1,obl.y[a])
	elseif (obl.tmpexts[a] or obl.exts[a]) == ".app" then
		if fs.exists(obl.paths[a].."icon.pic") then
			icn={}
			file=io.open(obl.paths[a].."icon.pic")
			for var in file:lines() do
				table.insert(icn,var)
			end
			file:close()
			icn=finder.unserialize(icn)
			icn=picture.decompress(icn)
			picture.draw(obl.x[a]+1,obl.y[a],icn)
		else
			icons.app(obl.x[a]+1,obl.y[a])
		end
	elseif fs.isDirectory(obl.paths[a]) ~= false then
		icons.folder(obl.x[a]+1,obl.y[a])
	elseif (obl.tmpexts[a] or obl.exts[a]) == ".lua" then
		icons.lua(obl.x[a]+1,obl.y[a])
	elseif (obl.tmpexts[a] or obl.exts[a]) == ".lang" then
		icons.lang(obl.x[a]+1,obl.y[a])
	elseif (obl.tmpexts[a] or obl.exts[a]) == ".cfg" then
		icons.cfg(obl.x[a]+1,obl.y[a])
	elseif (obl.tmpexts[a] or obl.exts[a]) == ".txt" then
		icons.txt(obl.x[a]+1,obl.y[a])
	elseif ((obl.tmpexts[a] or obl.exts[a]) == ".spic") or (obl.tmpexts[a] or obl.exts[a]) == ".pic" then
		icons.pic(obl.x[a]+1,obl.y[a])
	else
		icons.unkFile(obl.x[a]+1,obl.y[a])
	end
	if obl.exts[a] == ".lnk" then
		color(0xffffff)
		fcolor(0)
		set(obl.x[a]+8,obl.y[a]+3,"<")
	end
	color(user.contrastColor)
	local _,gg=picture.HEXtoRGB(user.contrastColor)
	if gg < 160 then
		fcolor(0xffffff)
	else
		fcolor(0)
	end
	slen=len(obl.names[a])
	if slen > 10 then
		slen=10
		tmp=sub(obl.names[a],1,9).."…"
	else
		tmp=obl.names[a]
	end
	if obl.notExists[a] then
		fcolor(0xff0000)
	end
	set(obl.x[a]+((10-slen)/2),obl.y[a]+5,tmp)
	picture.adaptiveText(obl.x[a],obl.y[a]-1,"⣠⣤⣤⣤⣤⣤⣤⣤⣤⣄",user.contrastColor)
	picture.adaptiveText(obl.x[a],obl.y[a]+6,"⠙⠛⠛⠛⠛⠛⠛⠛⠛⠋",user.contrastColor)
end
end

function system.drawDesktop(path)
temp=2
while true do
	if temp+9 >= w then
		temp=temp-2
		break
	else
		temp=temp+11
	end
end
offset=math.floor((w-1-temp)/2)
temp=io.open("/tmp/time","w")
temp:close()
temp=fs.lastModified("/tmp/time")
time=tonumber(sub(temp,1,-4))+timeCorrection
if fs.exists("/tmp/timerid") ~= true then
	timerid=event.timer(1,clock,math.huge)
	file=io.open("/tmp/timerid","w")
	file:write(timerid)
	file:close()
end
local data=finder.files(path)
color(0x2b2b2b)
fcolor(0xffffff)
fill(1,1,w,h," ")
system.taskbarDraw()
local obl=system.objects(2+offset,2,path,data)
return obl
end

local function reasonDraw(reason)
if user.powerSafe then
	color(0)
else
	color(0x0094ff)
end
fcolor(0xffffff)
fill(2,2,w-2,h-2," ")
for i=1,#reason+reasonY do
	if i+3 == h then
		break
	end
	set(2,2+i,reason[i-reasonY])
end
end

function system.bsod(name,reason)
tmp=lang.bsod:format(name)
slen=len(tmp)
slen1=len(lang.bsodExit)
reason=tools.wrap(reason,w-2)
if fs.exists("/tmp/timerid") then
	file=io.open("/tmp/timerid","r")
	event.cancel(tonumber(file:read("*all")))
	file:close()
	fs.remove("/tmp/timerid")
end
if #reason > h-4 then
	can=#reason-h+4
	hlimit=-can
end
if user.powerSafe then
	color(0)
else
	color(0x0094ff)
end
fcolor(0xffffff)
fill(1,1,w,h," ")
reasonDraw(reason)
set(w/2-slen/2,1,"⢿")
set(w/2+slen/2+1,1,"⡿")
set(w/2-slen1/2,h,"⣾")
set(w/2+slen1/2+1,h,"⣷")
color(0xffffff)
if user.powerSafe then
	fcolor(0)
else
	fcolor(0x0094ff)
end
set(w/2-slen/2+1,1,tmp)
set(w/2-slen1/2+1,h,lang.bsodExit)
computer.beep("...")
while true do
	tip,_,x,y,click=event.pull()
	if tip == "scroll" then
		if click == 1 then
			if reasonY < 0 then
				reasonY=reasonY+click
				reasonDraw(reason)
			end
		else
			if reasonY > hlimit then
				reasonY=reasonY+click
				reasonDraw(reason)
			end
		end
	elseif tip == "touch" then
		break
	end
end
end

return system