local r=require
local c=r("component")
local term=r("term")
local os=r("os")
local io=r("io")
local fs=r("filesystem")
local unicode=r("unicode")
local tools=r("fos/tools")
local picture=r("fos/picture")
local finder=r("fos/finder")
local icons=r("fos/icons")
local event=r("event")
local thread=r("thread")
local comp=r("computer")
local gpu=c.gpu
local fill=gpu.fill
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set
local len=unicode.len
local dir=fs.makeDirectory
local reg,user,lang,gensett={},{},{},{}
local langview,maincolor,secondcolor,mainfcolor,secondfcolor,contrastColor,file,slen,pass,i,wait,work,file=0
local colors={0xff0000,0xff2400,0xff4900,0xff6d00,0xff9200,0xffb600,0xffdb00,0xffff00,0xdbff00,0xb6ff00,0x92ff00,0x6dff00,0x49ff00,0x24ff00,0x00ff00,0x00ff24,0x00ff49,0x00ff6d,0x00ff92,0x00ffb6,0x00ffdb,0x00ffff,0x00dbff,0x00b6ff,0x0092ff,0x006dff,0x0049ff,0x0024ff,0x0000ff,0x2400ff,0x4900ff,0x6d00ff,0x9200ff,0xb600ff,0xdb00ff,0xff00ff,0xff00db,0xff00b6,0xff0092,0xff006d,0xff0049,0xff0024}
local w,h=gpu.maxResolution()
local xw,yw,xc,yc=1,math.floor(h/3),1,1
local args={...}
color(0)
fill(1,1,w,h," ")

if fs.exists("/fos/system/generalSettings.cfg") then
	file=io.open("/fos/system/generalSettings.cfg","r")
	for var in file:lines() do
		table.insert(reg,var)
	end
	file:close()
	gensett=finder.unserialize(reg)
else
	tools.error({"The general system configuration file doesn't exist. The values have been restored to factory settings."},2)
	gensett.notLogged=true
	gensett.pcName="FOS-"..math.random(100000,999999)
	gensett.timeZone=3
	gensett.width,gensett.height=gpu.maxResolution()
	gensett.lang="english.lang"
	gensett.powerSafe=false
	gensett.darkMode=false
	gensett.ver="22061300"
	gensett.contrastColor=0x0094ff
	file=io.open("/fos/system/generalSettings.cfg","w")
	temp=finder.serialize(gensett)
	for i=1,#temp do
		file:write(temp[i])
		if i ~= #temp then
			file:write("\n")
		end
	end
	file:close()
end
user.passwordProtection=true
secondfcolor=0x808080
if gensett.powerSafe then
	maincolor=0
	secondcolor=0x303030
	thirdcolor=0x404040
	mainfcolor=0xffffff
elseif gensett.darkMode then
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
contrastColor=gensett.contrastColor or 0x0094ff
file=io.open("/fos/lang/oobe/"..gensett.lang,"r")
reg={}
for var in file:lines() do
	table.insert(reg,var)
end
file:close()
lang=finder.unserialize(reg)
local w,h=gpu.maxResolution()
gpu.setResolution(w,h)
local x,y=math.floor(w/2-37),math.floor(h/2-10)
local halfx=math.floor((x+26+x+75)/2)

local function main()
color(maincolor)
fill(1,1,w,h," ")
color(secondcolor)
fill(x,y,76,23," ")
color(maincolor)
fcolor(secondfcolor)
set(x+37,y-1,"WIP")
fcolor(secondcolor)
set(x,y,"⣾")
set(x+75,y,"⣷")
set(x,y+22,"⢿")
set(x+75,y+22,"⡿")
if open ~= 0 then
	fcolor(mainfcolor)
	set(x+2,y-1,"◂")
end
end

local function mainfill()
color(secondcolor)
fill(x,y+1,76,21," ")
color(maincolor)
fcolor(secondfcolor)
set(x+37,y-1,"WIP")
if open ~= 0 then
	fcolor(mainfcolor)
	set(x+2,y-1,"◂")
else
	set(x+2,y-1," ")
end
end

local function first()
color(secondcolor)
fcolor(0xFFC940)
set(x+9,y+10,"⠰⣦⡻⣦⡀ ⣠⡄")
set(x+9,y+11,"⣛⢮⡻⣮⣻⣦⣿⡇")
set(x+9,y+12,"⠙⢷⣽⣾⣿⣿⣿⣿")
set(x+11,y+13,"⠙⠿⣿⣿⠿⠃")
fcolor(mainfcolor)
slen=len(lang.welcome)
set(halfx-slen/2,y+1,lang.welcome)
fcolor(secondfcolor)
temp=tools.wrap(lang.welcomeMsg,48)
slen=len(lang.welcomeBtn)
slen1=len(lang.langChange)
set(x+70-slen-slen1,y+21,lang.langChange)
for i=1,#temp do
	set(x+26,y+2+i,temp[i])
end
tools.btn(x+72-slen,y+21,lang.welcomeBtn)
end

local function language()
color(secondcolor)
fcolor(mainfcolor)
slen=len(lang.langChoose)
set(halfx-slen/2,y+1,lang.langChoose)
langs={[1]="English",[2]="Русский",code={[1]="english.lang",[2]="russian.lang"}}
langy=math.ceil(h/2-(#langs/2))
for i=1,#langs do
	set(x+28,y+2+i+(i-1),langs[i])
	if langs.code[i] == gensett.lang then
		tools.radioBtn(x+73,y+2+i+(i-1),true)
		langview=i
	else
		tools.radioBtn(x+73,y+2+i+(i-1),false)
	end
end
slen=len(lang.next)
tools.btn(x+72-slen,y+21,lang.next)
icons.lang(x+9,y+10)
end

local function second()
color(secondcolor)
set(halfx-len(lang.userAdd)/2,y+1,lang.userAdd)
set(x+26,y+5,lang.passCheck)
color(thirdcolor)
fill(x+26,y+3,23,1," ")
if user.name ~= nil then
	set(x+26,y+3,user.name)
else
	fcolor(secondfcolor)
	set(x+26,y+3,lang.userName)
end
if user.passwordProtection then
	fill(x+26,y+7,23,1," ")
	fill(x+26,y+9,23,1," ")
	if user.password ~= nil then
		fcolor(mainfcolor)
		fill(x+26,y+7,len(user.password),1,"*")
	else
		fcolor(secondfcolor)
		set(x+26,y+7,lang.password)
	end
	if pass ~= nil then
		fcolor(mainfcolor)
		fill(x+26,y+9,len(pass),1,"*")
	else
		fcolor(secondfcolor)
		set(x+26,y+9,lang.passwordRepeat)
	end
end
color(secondcolor)
fcolor(secondfcolor)
slen=nil
if user.name == nil or ((user.password == nil or pass == nil) and user.passwordProtection) then
	set(x+74-len(lang.notAll),y+21,lang.notAll)
elseif user.passwordProtection and user.password ~= pass then
	set(x+74-len(lang.passwordMismatch),y+21,lang.passwordMismatch)
else
	slen=len(lang.next)
	tools.btn(x+72-slen,y+21,lang.next)
end
tools.lvr(x+70,y+5,user.passwordProtection)
icons.user(x+9,y+10,0x0094ff)
end

local function third()
color(secondcolor)
set(halfx-len(lang.pcHead)/2,y+1,lang.pcHead)
fcolor(secondfcolor)
temp=tools.wrap(lang.pcDescription,48)
for i=1,#temp do
	set(x+26,y+2+i,temp[i])
	pos=i
end
slen=len(lang.next)
slen1=len(lang.skip)
set(x+70-slen-slen1,y+21,lang.skip)
tools.btn(x+72-slen,y+21,lang.next)
color(maincolor)
fill(x+26,y+4+pos,23,1," ")
if gensett.pcName == nil then
	set(x+26,y+4+pos,lang.pcName)
else
	fcolor(mainfcolor)
	set(x+26,y+4+pos,gensett.pcName)
end
color(contrastColor)
fcolor(0)
set(x+9,y+10,"⡏⠉⠉⠉⠉⠉⠉⢹")
set(x+9,y+11,"⡇      ⢸")
set(x+9,y+12,"⣇⣀⣀⣀⣀⣀⣀⣸")
local _,gg=picture.HEXtoRGB(contrastColor)
if gg < 160 then
	fcolor(0xffffff)
else
	fcolor(0)
end
set(x+12,y+11,"⢸⠅")
fcolor(0)
color(secondcolor)
set(x+12,y+13,"⣸⣇")
end

local function waiting()
while true do
xw=xw+xc
yw=yw+yc
i=i+1
if i > 42 then i=1 end
color(colors[i])
set(xw,yw," ")
if xw == 1 or xw == w then xc=-xc end
if yw == 1 or yw == h then yc=-yc end
os.sleep(0.1)
end
end

local function working()
dir("/.trashcan/"..user.name.."/")
dir("/FOS/Users/"..user.name.."/Desktop")
file=io.open("/fos/system/generalSettings.cfg","w")
temp=finder.serialize(gensett)
for i=1,#temp do
	file:write(temp[i])
	if i ~= #temp then
		file:write("\n")
	end
end
file:close()
file=io.open("/fos/users/"..user.name.."/desktop/Settings.lnk","w")
file:write("/fos/apps/settings.app/")
file:close()
file=io.open("/fos/users/"..user.name.."/desktop/Explorer.lnk","w")
file:write("/fos/apps/explorer.app/")
file:close()
dir("/FOS/Users/"..user.name.."/AppData")
file=io.open("/fos/users/"..user.name.."/settings.cfg","w")
user.name=nil
user.desktopColor=0x2b2b2b
user.lang=gensett.lang
user.taskbarShowSeconds=false
user.powerSafe=false
user.dataType="%d.%m.%Y %H:%M:%S"
user.userColor=0x0094ff
user.darkMode=gensett.darkMode
user.powerSafe=gensett.powerSafe
user.timeZone=3
user.contrastColorHeaders=false
user.contrastColor=0x0094ff
temp=finder.serialize(user)
for i=1,#temp do
	file:write(temp[i])
	if i ~= #temp then
		file:write("\n")
	end
end
file:close()
file=io.open("/fos/system/auto.cfg","w")
file:write("")
file:close()
end

local function four()
color(0)
fcolor(0xffffff)
fill(1,1,w,h," ")
set(w/2-(len(lang.final)/2),h/2,lang.final)
color(colors[1])
set(xw,yw," ")
i=1
wait=thread.create(waiting)
status,reason=xpcall(working,debug.traceback)
wait:kill()
if not status then
	tools.error({lang.workingError,reason},2)
end
os.exit()
end

open=0
lastopen=0
refresh=false
main()
first()
while true do
if args[1] == "repair" then
	os.exit()
end
_,_,mx,my=event.pull("touch")
if open == 0 then
	if mx >= x+72-slen and mx <= x+73 and my == y+21 then
		open=1
	elseif mx >= x+70-slen-slen1 and mx <= x+70-slen and my == y+21 then
		open=-1
	end
elseif open ~= 0 and mx == x+2 and my == y-1 then
	if open > 0 then
		open=open-1
	else
		open=open+1
	end
elseif open == -1 then
	if mx >= x+72-slen and mx <= x+73 and my == y+21 then
		open=0
	else
		for i=1,#langs do
			if mx >= x+28 and mx <= x+73 and my == y+2+i+(i-1) and langview ~= i then
				langview=i
				gensett.lang=langs.code[i]
				refresh=true
				file=io.open("/fos/lang/oobe/"..gensett.lang,"r")
				reg={}
				for var in file:lines() do
					table.insert(reg,var)
				end
				file:close()
				lang=finder.unserialize(reg)
			end
		end
	end
elseif open == 1 then
	if mx >= x+26 and mx <= x+48 and my == y+3 then
		if user.name ~= nil then
			temp=tools.input(x+26,y+3,23,"0",user.name,"1")
		else
			temp=tools.input(x+26,y+3,23,"0",lang.userName)
		end
		slen=len(temp)
		if slen > 0 and slen <= 23 then
			user.name=temp
		elseif slen > 23 then
			tools.error({lang.userNameLong},1)
		end
		slen=nil
		refresh=true
	elseif mx >= x+70 and mx <= x+73 and my == y+5 then
		if user.passwordProtection then
			user.passwordProtection=false
			user.password=nil
			pass=nil
		else
			user.passwordProtection=true
		end
		color(secondcolor)
		tools.lvr(x+70,y+5,_,"1")
		os.sleep(0.1)
		refresh=true
	elseif mx >= x+26 and mx <= x+48 and my == y+7 and user.passwordProtection then
		if user.password ~= nil then
			temp=tools.input(x+26,y+7,23,"1",user.password,"1")
		else
			temp=tools.input(x+26,y+7,23,"1",lang.password)
		end
		if len(temp) > 0 then
			user.password=temp
		end
		refresh=true
	elseif mx >= x+26 and mx <= x+48 and my == y+9 and user.passwordProtection then
		if pass ~= nil then
			temp=tools.input(x+26,y+9,23,"1",pass,"1")
		else
			temp=tools.input(x+26,y+9,23,"1",lang.passwordRepeat)
		end
		if len(temp) > 0 then
			pass=temp
		end
		refresh=true
	elseif slen ~= nil and mx >= x+72-slen and mx <= x+73 and my == y+21 then
		open=open+1
	end
elseif open == 2 then
	if mx >= x+26 and mx <= x+48 and my == y+4+pos then
		if gensett.pcName ~= nil then
			temp=tools.input(x+26,y+4+pos,23,"0",gensett.pcName,"1")
		else
			temp=tools.input(x+26,y+4+pos,23,"0",lang.pcName)
		end
		if len(temp) > 0 then
			gensett.pcName=temp
		end
		refresh=true
	elseif mx >= x+72-slen and mx <= x+73 and my == y+21 then
		open=open+1
	elseif mx >= x+70-slen-slen1 and mx <= x+70-slen and my == y+21 then
		gensett.pcName="FOS-"..math.random(100000,999999)
		open=open+1
	end
end
if lastopen ~= open or refresh then
		refresh=false
		lastopen=open
		mainfill()
		if open == 0 then
			first()
		elseif open == -1 then
			language()
		elseif open == 1 then
			second()
		elseif open == 2 then
			third()
		elseif open == 3 then
			four()
		end
	end
end