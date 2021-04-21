local r=require
local c=r("component")
local gpu=c.gpu
local os=r("os")
if gpu.maxDepth() == 1 then
print("Your PC is TIER 1. To install FOS you need a minimum of TIER 2 PC.")
os.exit()
end
local fs=r("filesystem")
local internet=c.internet
local term=r("term")
local io=r("io")
local w,h=gpu.getResolution();
local fill=gpu.fill
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set
local event=r("event")
local dir=fs.makeDirectory
os.execute("wget -f https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/tools.lua /lib/fos/tools.lua")
local tools=r("/fos/tools")
term.clear()

function reset()
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
color(0x0000ff)
fill(xw+3,hw+1,4,4," ")
fill(xw+1,hw+2,8,2," ")
color(0x00ff00)
fill(xw+3,hw+2,2,2," ")
fill(xw+5,hw+3,2,1," ")
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
	fs.remove("/lib/fos")
	color(0)
	fcolor(0xffffff)
	term.clear()
	os.exit()
else
	os.execute("wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Install/"..langchoise.." /tmp/lang")
end
lang={}
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
user={"","","0",""}
userclr=math.random(16777215)
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
tools.lvr(xw+max-5,hw+9,user[3])
if user[3] == "1" then
	set(xw+1,hw+11,lang.password)
end
color(0xe0e0e0)
fill(xw+1,hw+7,max,1," ")
set(xw+1,hw+7,user[1])
if user [3] == "1" then
	fill(xw+1,hw+12,max,1," ")
	slen=len(user[4])
	fill(xw+1,hw+12,slen,1,"*")
end
color(userclr)
set(w/2-2,hw+1,"    ")
set(w/2-2,hw+2,"    ")
set(w/2-1,hw+3,"  ")
set(w/2-3,hw+4,"      ")
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
		if user[3] == "1" then
			user[3]="0"
		else
			user[3]="1"
		end
		userdraw()
	elseif x >= xw+1 and x <= xw+max and y == hw+7 then
		user[1]=userInput()
		userdraw()
	elseif x >= xw+1 and x <= xw+max and y == hw+12 then
		user[4]=userInput(true)
		userdraw()
	elseif x >= math.floor(w/2-btnlen/2-1) and x <= math.floor(w/2+btnlen/2) and y == hw+14 then
		break
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

dir("/home/foslang")
dir("/FOS/desktop")
dir("/FOS/apps/Settings.app/appname")
dir("/FOS/apps/Settings.app/lang")
dir("/FOS/lang/fos")
dir("/FOS/system")

reset()
term.setCursor(1,1)
tools.fullbar(1,h,w,1)
local c1={
	"https://raw.githubusercontent.com/MrFredber/FOS/master/FOS/fos.lua /fos/fos.lua",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/FOS/boot.lua /fos/boot.lua",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/FOS/bootmgr.lua /fos/bootmgr.lua"}
local c2={--lib
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/system.lua /lib/fos/system.lua",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/finder.lua /lib/fos/finder.lua",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/icons.lua /lib/fos/icons.lua",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Libraries/picture.lua /lib/fos/picture.lua"}
local c3={--apps
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Applications/Settings.app/icon.spic /fos/apps/settings.app/icon.spic",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Applications/Settings.app/main.lua /fos/apps/settings.app/main.lua"}
local c4={--langs
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Language/fos/english.lang /fos/lang/fos/english.lang",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Language/fos/russian.lang /fos/lang/fos/russian.lang",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Applications/Settings.app/lang/english.lang /fos/apps/settings.app/lang/english.lang",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Applications/Settings.app/lang/russian.lang /fos/apps/settings.app/lang/russian.lang",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Applications/Settings.app/appname/english.lang /fos/apps/settings.app/appname/english.lang",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Applications/Settings.app/appname/russian.lang /fos/apps/settings.app/appname/russian.lang"}
local c5={--other
	"https://raw.githubusercontent.com/MrFredber/FOS/master/FOS/RAM%20test.lua /fos/desktop/'RAM test.lua'",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Applications/Settings.app/icon.pic /fos/apps/settings.app/icon.pic",
	"https://raw.githubusercontent.com/MrFredber/FOS/master/Applications/Settings.app/icon.bmp /fos/apps/settings.app/icon.bmp"}

local names={
	"/fos/fos.lua","/fos/boot.lua","/fos/bootmgr.lua","/lib/fos/system.lua","/lib/fos/finder.lua","/lib/fos/icons.lua",
	"/lib/fos/picture.lua","/fos/apps/settings.app/icon.spic","/fos/apps/settings.app/main.lua","/fos/lang/fos/english.lang",
	"/fos/lang/fos/russian.lang","/fos/apps/settings.app/lang/english.lang","/fos/apps/settings.app/lang/russian.lang",
	"/fos/apps/settings.app/appname/english.lang","/fos/apps/settings.app/appname/russian.lang","/fos/desktop/'RAM test.lua'",
	"/fos/apps/settings.app/icon.pic","/fos/apps/settings.app/icon.bmp"}
cat=1
ibar=0
if temp == "1" then
	total=#c1+#c2+#c3+#c4+#c5
else
	total=#c1+#c2+#c3+#c4
end
percent=100/total
color(0x2b2b2b)
while cat-1 ~= #c2 do
	fcolor(0xffffff)
	set(1,h-1,names[ibar+1])
	tools.fullbar(1,h,w,percent*ibar)
	ibar=ibar+1
	color(0x2b2b2b)
	fcolor(0x3b3b3b)
	os.execute("wget -fq "..c1[cat])
	fill(1,h-1,w,2,"⢕")
end
cat=1
while cat-1 ~= #c2 do
	fcolor(0xffffff)
	set(1,h-1,names[ibar+1])
	tools.fullbar(1,h,w,percent*ibar)
	ibar=ibar+1
	color(0x2b2b2b)
	fcolor(0x3b3b3b)
	os.execute("wget -fq "..c2[cat])
	fill(1,h-1,w,2,"⢕")
end
cat=1
while cat-1 ~= #c3 do
	fcolor(0xffffff)
	set(1,h-1,names[ibar+1])
	tools.fullbar(1,h,w,percent*ibar)
	ibar=ibar+1
	color(0x2b2b2b)
	fcolor(0x3b3b3b)
	os.execute("wget -fq "..c3[cat])
	fill(1,h-1,w,2,"⢕")
end
cat=1
while cat-1 ~= #c4 do
	fcolor(0xffffff)
	set(1,h-1,names[ibar+1])
	tools.fullbar(1,h,w,percent*ibar)
	ibar=ibar+1
	color(0x2b2b2b)
	fcolor(0x3b3b3b)
	os.execute("wget -fq "..c4[cat])
	fill(1,h-1,w,2,"⢕")
end
cat=1
if temp == "1" then
	while cat-1 ~= #c5 do
		fcolor(0xffffff)
		set(1,h-1,names[ibar+1])
		tools.fullbar(1,h,w,percent*ibar)
		ibar=ibar+1
		color(0x2b2b2b)
		fcolor(0x3b3b3b)
		os.execute("wget -fq "..c5[cat])
		fill(1,h-1,w,2,"⢕")
	end
end
fcolor(0xffffff)
set(1,h-1,lang.ending)

file=io.open("/home/.shrc","w")
file:write("/fos/boot\ncd /fos")
file:close()
file=io.open("/fos/desktop/Settings.lnk","w")
file:write("/fos/apps/settings.app")
file:close()
file=io.open("/fos/system/lang.cfg","w")
file:write(langchoise)
file:close()
file=io.open("/fos/system/user.cfg","w")
if user[1] == "" then
	user[1]="User"
end
file:write(user[1].."\n\n")
if user[3] ~= "0" and user[4] ~= nil then
	file:write("1\n"..user[4])
else
	file:write("0")
end
file:close()
w,h=gpu.maxResolution()
file=io.open("/fos/system/comp.cfg","w")
file:write("0\n"..w..","..h)
file:close()
file=io.open("/fos/system/auto.cfg","w")
file:write("")
file:close()
r("computer").shutdown(true)