local r=require
local c=r("component")
local gpu=c.gpu
local os=r("os")
if gpu.maxDepth() == 1 then
print("Screen/GPU does not support touches.")
os.exit()
end
local fs=r("filesystem")
local unicode=r("unicode")
local len=unicode.len
local term=r("term")
local io=r("io")
local w,h=gpu.getResolution();
local fill=gpu.fill
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set
local event=r("event")
local dir=fs.makeDirectory
local langchoise=""
local file
dir("/lib/fos")
os.execute("wget -f https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/tools.lua /lib/fos/tools.lua")
os.execute("wget -f https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/picture.lua /lib/fos/picture.lua")
local tools=r("fos/tools")
term.clear()

local function reset()
color(0x2b2b2b)
fcolor(0x3b3b3b)
fill(1,1,w,h,"⢕")
color(0xffffff)
fcolor(0)
fill(1,1,w,1," ")
set(1,1,"FOS Installer")
color(0)
fcolor(0xffffff)
end

reset()
xw=math.floor(w/2-12)
hw=math.floor(h/2-3)
fill(xw+1,hw+1,26,8," ")
color(0xffffff)
fcolor(0)
fill(xw,hw,26,8," ")
set(xw+10,hw+2,"Choose language")
set(xw+10,hw+3,"Выберите язык")
tools.btn(xw+4,hw+6,"English")
tools.btn(xw+15,hw+6,"Русский")
fcolor(0x0000ff)
set(xw+7,hw+1,"⣶⡄")
set(xw+1,hw+4,"⠘⠿    ⠿⠃")
fcolor(0x00ff00)
set(xw+1,hw+1,"⢠⣶")
color(0x0000ff)
set(xw+3,hw+1,"⣿⣿⡟⣿")
set(xw+1,hw+2,"⣿⣿⣿⠟⠋ ⡀ ")
set(xw+1,hw+3," ⠉⠿⣆⣠⠈  ")
set(xw+3,hw+4," ⠛⠁ ")
color(0xb40000)
fcolor(0xffffff)
set(xw+23,hw," X ")
while true do
	_,_,x,y=event.pull("touch")
	if x >= xw+3 and x <= xw+10 and y == hw+6 then
		langchoise="english.lang"
		break
	elseif x >= xw+14 and x <= xw+22 and y == hw+6 then
		langchoise="russian.lang"
		break
	elseif x >= xw+23 and x <= xw+26 and y == hw then
		langchoise=nil
		break
	end
end

if langchoise == nil then
	color(0)
	fcolor(0xffffff)
	term.clear()
	print("If system isn't installed on this PC, you can delete /lib/fos directory.")
	os.exit()
else
	os.execute("wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Install/"..langchoise.." /tmp/lang")
end
local lang={}
file=io.open("/tmp/lang","r")
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

reset()
xw=math.floor(w/2-37)
hw=math.floor(h/2-10)
fill(xw+1,hw+1,75,23," ")
color(0xffffff)
fcolor(0)
fill(xw,hw,75,23," ")
set(xw,hw,lang.license)
slen=len(lang.licenseMsg)
set(w/2-slen/2,hw+22,lang.licenseMsg)
slen=len(lang.accept)
tools.btn(w/2-slen/2,hw+21,lang.accept)
color(0xe0e0e0)
fill(xw,hw+1,75,19," ")
set(xw,hw+1,"Copyright (C) 2021 Mr.Fredber")
set(xw,hw+3,"Permission is hereby granted, free of charge, to any person obtaining a")
set(xw,hw+4,"copy of this software and associated documentation files (the 'Software'),")
set(xw,hw+5,"to deal in the Software without restriction, including without limitation")
set(xw,hw+6,"the rights to use, copy, modify, merge, publish, distribute, sublicense,")
set(xw,hw+7,"and/or sell copies of the Software, and to permit persons to whom the")
set(xw,hw+8,"Software is furnished to do so, subject to the following conditions:")
set(xw,hw+10,"The above copyright notice and this permission notice shall be")
set(xw,hw+11,"included in all copies or substantial portions of the Software.")
set(xw,hw+13,"THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR")
set(xw,hw+14,"IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,")
set(xw,hw+15,"FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL")
set(xw,hw+16,"THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER")
set(xw,hw+17,"LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING")
set(xw,hw+18,"FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER")
set(xw,hw+19,"DEALINGS IN THE SOFTWARE.")
while true do
	_,_,x,y=event.pull("touch")
	if x >= math.floor(w/2-slen/2-1) and x <= math.floor(w/2+slen/2) and y == hw+21 then
		break
	end
end

reset()
function typeDraw()
hw=math.floor(h/2-7)
xw=math.floor(w/2-37)
fill(xw+1,hw+1,75,17," ")
color(0xffffff)
fcolor(0)
fill(xw,hw,75,17," ")
set(xw,hw,lang.installType)
set(xw+10,hw+2,lang.typeUpgrade)
set(xw+10,hw+7,lang.typeInstall)
set(xw+10,hw+12,lang.typeWipe)
fcolor(0x727272)
set(xw+10,hw+3,lang.typeUpgradeMsg1)
set(xw+10,hw+4,lang.typeUpgradeMsg2)
set(xw+10,hw+8,lang.typeInstallMsg1)
set(xw+10,hw+9,lang.typeInstallMsg2)
set(xw+10,hw+13,lang.typeWipeMsg1)
set(xw+10,hw+14,lang.typeWipeMsg2)
fcolor(0x00bec1)
set(xw+1,hw+2,"⠛⠛⠛⠛⠛⠛⠛⠛")
fcolor(0x0094ff)
set(xw+1,hw+3,"⠀⠀⠀⢸⡇⠀⠀⠀")
set(xw+1,hw+4,"⠀⠀⠙⢿⡿⠋⠀⠀")
fcolor(0xb200ff)
set(xw+1,hw+5,"⣤⣤⣤⣤⣤⣤⣤⣤")
fcolor(0x4cff00)
set(xw+4,hw+2,"⠛⠛")
set(xw+7,hw+2,"⠛")
set(xw+4,hw+5,"⣤⣤")
set(xw+7,hw+5,"⣤")
fcolor(0x0094ff)
set(xw+1,hw+7,"⠀⠀⠀⢸⡇⠀⠀⠀")
set(xw+1,hw+8,"⠀⠀⠀⢸⡇⠀⠀⠀")
set(xw+1,hw+9,"⠀⠀⠙⢿⡿⠋⠀⠀")
fcolor(0xb200ff)
set(xw+1,hw+10,"⣤⣤⣤⣤⣤⣤⣤⣤")
fcolor(0x4cff00)
set(xw+4,hw+10,"⣤⣤")
set(xw+7,hw+10,"⣤")
fcolor(0xff0000)
set(xw+1,hw+12,"⢠⡶⢿⣿⣿⡿⢶⡄")
set(xw+1,hw+13,"⣿⣷⣄⠙⠋⣠⣾⣿")
set(xw+1,hw+14,"⣿⡿⠋⣠⣄⠙⢿⣿")
set(xw+1,hw+15,"⠘⠷⣾⣿⣿⣷⠾⠃")
installtype=0
end
function typeConfirm()
max=len(lang.typeConfirm)+2
cw=math.floor(w/2-max/2)
ch=math.floor(h/2-2)
reset()
fill(cw+1,ch+1,max,6," ")
color(0xffffff)
fcolor(0)
fill(cw,ch,max,6," ")
set(cw+1,ch+1,lang.typeConfirm)
temp={"typeUpgrade","typeInstall","typeWipe"}
slen=len(lang[temp[installtype]] or "Null")
set(w/2-slen/2,ch+2,lang[temp[installtype]] or "Null")
slen1=len(lang.yes)
slen2=len(lang.no)
tlen=w/2-(slen1+slen2+5)/2
tools.btn(tlen+1,ch+4,lang.yes)
tools.btn(tlen+slen1+4,ch+4,lang.no)
while true do
	_,_,x,y=event.pull("touch")
	if x >= tlen and x <= tlen+1+slen1 and y == ch+4 then
		typeconfirmed=1
		break
	elseif x >= tlen+slen1+3 and x <= tlen+slen1+slen2+4 and y == ch+4 then
		typeconfirmed=0
		color(0)
		typeDraw()
		break
	end
end
end
typeDraw()
while true do
	_,_,x,y=event.pull("touch")
	if x >= xw+1 and x <= xw+73 and y >= hw+2 and y <= hw+5 then
		installtype=1
		typeConfirm()
		if typeconfirmed == 1 then break end
	elseif x >= xw+1 and x <= xw+73 and y >= hw+7 and y <= hw+10 then
		installtype=2
		typeConfirm()
		if typeconfirmed == 1 then break end
	elseif x >= xw+1 and x <= xw+73 and y >= hw+12 and y <= hw+15 then
		installtype=3
		typeConfirm()
		if typeconfirmed == 1 then break end
	end
end

if installtype == 2 or installtype == 3 then
	reg={["username"]="User",["passwordProtection"]="0"}
	i=1
	temp={"user","username","password","passwordLvr"}
	max=0
	while i-1 ~= 4 do
		slen=len(lang[temp[i]])
		if i == 4 then
			slen=slen+7
		end
		if slen > max then
			max=slen
		end
		i=i+1
	end
	userclr=0x0094ff
	reset()
	xw=math.floor(w/2-max/2-1)
	hw=math.floor(h/2-7)
	
	function userdraw()
	color(0)
	fcolor(0xffffff)
	fill(xw+1,hw+1,max+2,16," ")
	color(0xffffff)
	fcolor(0)
	fill(xw,hw,max+2,16," ")
	set(xw,hw,lang.user)
	set(xw+1,hw+6,lang.username)
	set(xw+1,hw+9,lang.passwordLvr)
	btnlen=len(lang.next)
	tools.btn(w/2-btnlen/2,hw+14,lang.next)
	tools.lvr(xw+max-5,hw+9,reg.passwordProtection)
	if reg.passwordProtection == "1" then
		set(xw+1,hw+11,lang.password)
	end
	fcolor(userclr)
	set(w/2-3,hw+1,"⢠⡶⢿⡿⢶⡄")
	set(w/2-3,hw+2,"⣿⣇⣸⣇⣸⣿")
	set(w/2-3,hw+3,"⠘⠿⣮⣵⠿⠃")
	set(w/2-3,hw+4,"⣀⣤⣿⣿⣤⣀")
	color(0xe0e0e0)
	fcolor(0)
	fill(xw+1,hw+7,max,1," ")
	set(xw+1,hw+7,reg.username)
	if reg.passwordProtection == "1" then
		fill(xw+1,hw+12,max,1," ")
		slen=len(reg.password)
		fill(xw+1,hw+12,slen,1,"*")
	end
	end
	userdraw()
	
	function userInput(s)
	color(0xffffff)
	fcolor(0)
	term.setCursor(1,h)
	fill(1,h,w,1," ")
	if s == true then
		text=term.read({},false,"","*")
	else
		text=term.read({},false)
	end
	text=unicode.sub(text,1,-2)
	color(0x2b2b2b)
	fcolor(0x3b3b3b)
	fill(1,h,w,1,"⢕")
	return text
	end
	
	while true do
		_,_,x,y=event.pull("touch")
		if x >= xw+max-5 and x <= xw+max and y == hw+9 then
			if reg.passwordProtection == "1" then
				reg.passwordProtection="0"
			else
				reg.passwordProtection="1"
			end
			userdraw()
		elseif x >= xw+1 and x <= xw+max and y == hw+7 then
			reg.username=userInput()
			userdraw()
		elseif x >= xw+1 and x <= xw+max and y == hw+12 then
			reg.password=userInput(true)
			userdraw()
		elseif x >= math.floor(w/2-btnlen/2-1) and x <= math.floor(w/2+btnlen/2) and y == hw+14 then
			break
		end
	end
end

reset()
temp="1"
slen=len(lang.other)
max=slen+7
xw=math.floor(w/2-max/2-1)
hw=math.floor(h/2-2)

function download()
color(0)
fcolor(0xffffff)
fill(xw+1,hw+1,max+2,5," ")
color(0xffffff)
fcolor(0)
fill(xw,hw,max+2,5," ")
set(xw+1,hw+1,lang.other)
tools.lvr(xw+max-5,hw+1,temp)
slen=len(lang.install)
tools.btn(w/2-slen/2,hw+3,lang.install)
end
download()

while true do
	_,_,x,y=event.pull("touch")
	if x >= xw+max-5 and x <= xw+max and y == hw+1 then
		if temp == "1" then
			temp="0"
		else
			temp="1"
		end
		download()
	elseif x >= math.floor(w/2-slen/2-1) and x <= math.floor(w/2+slen/2) and y == hw+3 then
		break
	end
end

if installtype == 3 then
	fs.remove("/fos")
	fs.remove("/lib/fos")
end

dir("/FOS/desktop")
dir("/FOS/apps/Settings.app/appname")
dir("/FOS/apps/Settings.app/lang")
dir("/FOS/apps/Explorer.app/appname")
dir("/FOS/lang/fos")
dir("/FOS/lang/shared")
dir("/FOS/system")

reset()
term.setCursor(1,1)
tools.fullbar(1,h,w,1)
local files={
	"https://raw.githubusercontent.com/MrFredber/FOS/master/FOS/fos.lua /fos/fos.lua",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/FOS/boot.lua /lib/core/boot.lua",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/FOS/foslink.lua /home/fos",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/FOS/bootmgr.lua /fos/bootmgr.lua",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/system.lua /lib/fos/system.lua",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/finder.lua /lib/fos/finder.lua",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/icons.lua /lib/fos/icons.lua",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/picture.lua /lib/fos/picture.lua",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Applications/Settings.app/icon.spic /fos/apps/settings.app/icon.spic",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Applications/Settings.app/main.lua /fos/apps/settings.app/main.lua",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Applications/Explorer.app/icon.spic /fos/apps/explorer.app/icon.spic",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Applications/Explorer.app/main.lua /fos/apps/explorer.app/main.lua",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Language/fos/english.lang /fos/lang/fos/english.lang",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Language/fos/russian.lang /fos/lang/fos/russian.lang",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Language/shared/english.lang /fos/lang/shared/english.lang",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Language/shared/russian.lang /fos/lang/shared/russian.lang",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Applications/Settings.app/lang/english.lang /fos/apps/settings.app/lang/english.lang",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Applications/Settings.app/lang/russian.lang /fos/apps/settings.app/lang/russian.lang",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Applications/Settings.app/appname/english.lang /fos/apps/settings.app/appname/english.lang",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Applications/Settings.app/appname/russian.lang /fos/apps/settings.app/appname/russian.lang",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Applications/Explorer.app/appname/english.lang /fos/apps/explorer.app/appname/english.lang",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Applications/Explorer.app/appname/russian.lang /fos/apps/explorer.app/appname/russian.lang"}
local other={
	"https://raw.githubusercontent.com/MrFredber/FOS/master/FOS/RAM%20test.lua /fos/desktop/'RAM test.lua'",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Applications/Settings.app/icon.pic /fos/apps/settings.app/icon.pic",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Applications/Settings.app/icon.bmp /fos/apps/settings.app/icon.bmp"}

i=1
ibar=0
percent=100/#files
color(0x2b2b2b)
while i-1 ~= #files do
	fcolor(0xffffff)
	temp=files[i]:find(" ")
	set(1,h-1,files[i]:sub(temp+1))
	tools.fullbar(1,h,w,percent*ibar)
	color(0x2b2b2b)
	fcolor(0x3b3b3b)
	os.execute("wget -fq "..files[i])
	fill(1,h-1,w,2,"⢕")
	ibar=ibar+1
	i=i+1
end
if temp == "1" then
	i=1
	ibar=0
	percent=100/#other
	color(0x2b2b2b)
	while i-1 ~= #other do
		fcolor(0xffffff)
		temp=other[i]:find(" ")
		set(1,h-1,other[i]:sub(temp+1))
		tools.fullbar(1,h,w,percent*ibar)
		color(0x2b2b2b)
		fcolor(0x3b3b3b)
		os.execute("wget -fq "..other[i])
		fill(1,h-1,w,2,"⢕")
		ibar=ibar+1
		i=i+1
	end
end
fcolor(0xffffff)
color(0x0094ff)
slen=len(lang.last)
fill(1,1,w,h," ")
set(w/2-slen/2,h/2,lang.last)

file=io.open("/fos/desktop/Settings.lnk","w")
file:write("/fos/apps/settings.app")
file:close()
file=io.open("/fos/desktop/Explorer.lnk","w")
file:write("/fos/apps/explorer.app")
file:close()
function standart()
if reg.passwordProtection == "1" and reg.password == nil then
	reg.passwordProtection="0"
	reg.password="0"
end
w,h=gpu.maxResolution()
reg.width=tostring(w)
reg.height=tostring(h)
reg.userColor="0x0094ff"
reg.powerSafe="0"
reg.ver="a7"
reg.lang=langchoise
reg.gpu=tostring(gpu.maxDepth())
file=io.open("/fos/system/auto.cfg","w")
file:write("")
file:close()
end
function userError()
tools.error("File 'user.cfg' not exists or corrupted",2)
reg.username="User"
reg.userColor="0x0094ff"
reg.passwordProtection="0"
reg.password="0"
end
function usertransform()
reg.username=usr[1]
reg.userColor=usr[2]
reg.passwordProtection=usr[3]
if usr[3] == "1" then
	reg.password=usr[4]
end
end
function compError()
tools.error("File 'comp.cfg' not exists or corrupted",2)
reg.w,h=gpu.maxResolution()
reg.width=tostring(w)
reg.height=tostring(h)
reg.powerSafe="0"
end
function comptransform()
reg.powerSafe=cmp[1]
temp=cmp[2]:find(",")
reg.width=tonumber(cmp[2]:sub(1,temp-1))
reg.height=tonumber(cmp[2]:sub(temp+1))
end
if installtype == 2 or installtype == 3 then
	standart()
else
	temp=fs.exists("/fos/system/registry")
	if not temp then
		reg={}
		user=fs.exists("/fos/system/user.cfg")
		if not user then
			userError()
		else
			file=io.open("/fos/system/user.cfg","r")
			usr={}
			for var in file:lines() do table.insert(usr,var) end
			status=pcall(usertransform)
			if not status then
				userError()
			end
		end
		comp=fs.exists("/fos/system/comp.cfg")
		if not comp then
			compError()
		else
			file=io.open("/fos/system/comp.cfg","r")
			cmp={}
			for var in file:lines() do table.insert(cmp,var) end
			status=pcall(comptransform)
			if not status then
				compError()
			end
		end
		reg.ver="a7"
		reg.gpu=tostring(gpu.maxDepth())
		reg.lang=langchoise
	else
		reg={}
		file=io.open("/fos/system/registry","r")
		for var in file:lines() do
		if var:find("=") ~= nil then
			check=var:find("=")
			arg=unicode.sub(var,1,check-1)
			var=unicode.sub(var,check+1)
			reg[arg]=var
		else
			table.insert(reg,var)
		end
		end
		file:close()
	end
end
file=io.open("/fos/system/registry","w")
for k in pairs(reg) do
	file:write(k.."="..reg[k].."\n")
end
file:close()
r("computer").shutdown(true)