local r=require
local c=r("component")
local os=r("os")
local gpu=c.gpu
local file,reason,result,response
if gpu.maxDepth() == 1 then
	print("FOS cannot run on this PC: Screen/GPU does not support touches.")
	os.exit()
end
if not c.isAvailable("internet") then
	print("FOS Installer requires an internet card to run.")
	os.exit()
end
local internet=r("internet")
local fs=r("filesystem")
local dir=fs.makeDirectory
local lang={}
local branch="https://raw.githubusercontent.com/MrFredber/FOS/Dev/"
dir("/lib/fos")
print("Downloading necessary libraries... (1/4)")
os.execute("wget -f -q "..branch.."Libraries/picture.lua /lib/fos/picture.lua")
print("Downloading necessary libraries... (2/4)")
os.execute("wget -f -q "..branch.."Libraries/tools.lua /lib/fos/tools.lua")
--print("FOS Installer cannot continue.")
--os.exit()
local tools=r("fos/tools")

local function download(url,filename)
	result,response=pcall(internet.request,url)
	if result then
		file,reason=io.open(filename,"w")
		if file then
			for chunk in response do
				file:write(chunk)
			end
			file:close()
		else
			tools.error({(lang.downloadError or "An error occurred while downloading the file \"%s\":"):format(filename),"",(lang.fsError or "Failed opening file for writing: %s"):format(tostring(reason))},2)
		end
	else
		tools.error({(lang.downloadError or "An error occurred while downloading the file \"%s\":"):format(filename),"",(lang.requestError or "HTTP request failed: %s"):format(response)},2)
	end
end

print("Downloading necessary libraries... (3/4)")
download(branch.."Libraries/finder.lua","/lib/fos/finder.lua")
print("Downloading necessary libraries... (4/4)")
download(branch.."Libraries/icons.lua","/lib/fos/icons.lua")
print("Launching FOS Installer...")

local io=r("io")
local unicode=r("unicode")
local finder=r("fos/finder")
local icons=r("fos/icons")
local event=r("event")
local thread=r("thread")
local comp=r("computer")
local fill=gpu.fill
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set
local len=unicode.len
local lang,gensett,files,total,totalnames={},{},{},{},{}
local mitview,langview,maincolor,secondcolor,mainfcolor,secondfcolor,contrastColor,file,slen,pass,i,wait,work,file=0,1
local colors={0xff0000,0xff2400,0xff4900,0xff6d00,0xff9200,0xffb600,0xffdb00,0xffff00,0xdbff00,0xb6ff00,0x92ff00,0x6dff00,0x49ff00,0x24ff00,0x00ff00,0x00ff24,0x00ff49,0x00ff6d,0x00ff92,0x00ffb6,0x00ffdb,0x00ffff,0x00dbff,0x00b6ff,0x0092ff,0x006dff,0x0049ff,0x0024ff,0x0000ff,0x2400ff,0x4900ff,0x6d00ff,0x9200ff,0xb600ff,0xdb00ff,0xff00ff,0xff00db,0xff00b6,0xff0092,0xff006d,0xff0049,0xff0024}
local xw,yw,xc,yc=1,math.floor(h/3),1,1
local w,h=gpu.maxResolution()
local mit=tools.wrap("MIT License\n \nCopyright (c) 2021 Mr.Fredber\n \nPermission is hereby granted,free of charge,to any person obtaining a copy of this software and associated documentation files (the \"Software\"),to deal in the Software without restriction,including without limitation the rights to use,copy,modify,merge,publish,distribute,sublicense,and/or sell copies of the Software,and to permit persons to whom the Software is furnished to do so,subject to the following conditions:\n \nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n \nTHE SOFTWARE IS PROVIDED \"AS IS\",WITHOUT WARRANTY OF ANY KIND,EXPRESS OR IMPLIED,INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,DAMAGES OR OTHER LIABILITY,WHETHER IN AN ACTION OF CONTRACT,TORT OR OTHERWISE,ARISING FROM,OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.",42)
local mitlimit=#mit-15
local adsett,allLangs=false,true

if fs.exists("/fos/system/generalSettings.cfg") then
	file=io.open("/fos/system/generalSettings.cfg","r")
	data={}
	for var in file:lines() do
		table.insert(data,var)
	end
	file:close()
	gensett=finder.unserialize(data)
else
	gensett={lang="",pcName="",timeZone=3,powerSafe=false,contrastColor=0x0094ff,width=w,height=h,ver="",notLogged=true,darkMode=false}
end

secondfcolor=0x808080
local function adrefresh()
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
end
adrefresh()
contrastColor=gensett.contrastColor or 0x0094ff

local x,y=math.floor(w/2-37),math.floor(h/2-10)
local halfx=math.floor((x+26+x+75)/2)
gpu.setResolution(w,h)

local function main()
color(maincolor)
fill(1,1,w,h," ")
fcolor(mainfcolor)
set(x+71,y-1,"•••")
color(secondcolor)
fill(x,y,76,23," ")
color(maincolor)
fcolor(0xff0000)
set(x+28,y-1,"DEV BRANCH INSTALLER")
fcolor(secondcolor)
set(x,y,"⣾")
set(x+75,y,"⣷")
set(x,y+22,"⢿")
set(x+75,y+22,"⡿")
end

local function mainfill()
color(maincolor)
if adsett then
	fcolor(secondcolor)
	set(x+70,y-1,"⣾	  ⣷")
	color(secondcolor)
	fcolor(mainfcolor)
	set(x+71,y-1,"•••")
else
	fcolor(mainfcolor)
	set(x+70,y-1," ••• ")
end
color(maincolor)
if open ~= 0 then
	fcolor(mainfcolor)
	set(x+2,y-1,"◂")
else
	set(x+2,y-1," ")
end
color(secondcolor)
fill(x,y+1,76,21," ")
end

local function additional()
fcolor(mainfcolor)
color(secondcolor)
slen=len(lang.additional or "Additional settings")
set(halfx-slen/2,y+1,lang.additional or "Additional settings")
set(x+28,y+3,lang.powerSafe or "Power Saving Mode")
if gensett.powerSafe then
	fcolor(secondfcolor)
end
set(x+28,y+5,lang.darkMode or "Dark Theme")
tools.lvr(x+69,y+3,gensett.powerSafe)
tools.lvr(x+69,y+5,gensett.darkMode)
icons.cfg(x+9,y+10)
end

local function first()
color(secondcolor)
fcolor(mainfcolor)
slen=len(lang.langChoose or "Choose language")
set(halfx-slen/2,y+1,lang.langChoose or "Choose language")
langs={[1]="English",[2]="Русский",code={[1]="english.lang",[2]="russian.lang"}}
langy=math.ceil(h/2-(#langs/2))
for i=1,#langs do
	set(x+28,y+2+i+(i-1),langs[i])
	if i == langview then
		tools.radioBtn(x+73,y+2+i+(i-1),true)
	else
		tools.radioBtn(x+73,y+2+i+(i-1),false)
	end
end
slen=len(lang.next or "Next")
tools.btn(x+72-slen,y+21,lang.next or "Next")
icons.lang(x+9,y+10)
end

local function second()
color(thirdcolor)
fcolor(mainfcolor)
fill(x+28,y+3,46,17," ")
for i=1,15 do
	set(x+30,y+3+i,mit[i+mitview])
end
color(secondcolor)
slen=len(lang.licence)
set(halfx-slen/2,y+1,lang.licence)
slen=len(lang.accept)
tools.btn(x+72-slen,y+21,lang.accept)
icons.txt(x+10,y+10)
color(secondcolor)
fcolor(thirdcolor)
set(x+28,y+3,"⣾")
set(x+73,y+3,"⣷")
set(x+28,y+19,"⢿")
set(x+73,y+19,"⡿")
end

local function third()
fcolor(mainfcolor)
slen=len(lang.components)
set(halfx-slen/2,y+1,lang.components)
set(x+28,y+3,lang.allLangs)
tools.lvr(x+69,y+3,allLangs)
icons.cfg(x+9,y+10)
slen=len(lang.next)
tools.btn(x+72-slen,y+21,lang.next)
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
dir("/FOS/Apps/Settings.app/modules/1_System/")
dir("/FOS/Apps/Settings.app/modules/3_Personalization/")
dir("/FOS/Apps/Settings.app/modules/4_Apps/")
dir("/FOS/Apps/Settings.app/modules/6_DateAndLang/")
dir("/FOS/Apps/Settings.app/lang")
dir("/FOS/Apps/Explorer.app/")
dir("/FOS/Lang/fos/")
dir("/FOS/Lang/names/")
dir("/FOS/Lang/oobe/")
dir("/FOS/Lang/shared/")
dir("/FOS/System")
dir("/FOS/Users")
download(branch.."Install/files.cfg","/fos/install/files")
file=io.open("/fos/install/files","r")
data={}
for var in file:lines() do
	table.insert(data,var)
end
file:close()
files=finder.unserialize(data)
for i=1,#files.paths.main do
	total[i]=files.paths.main[i]
	totalnames[i]=files.names.main[i]
end
if allLangs then
	for i=1,#files.paths.langs.russian do
		total[#total+i]=files.paths.langs.russian[#total+i]
		totalnames[#total+i]=files.names.langs.russian[#total+i]
	end
	for i=1,#files.paths.langs.english do
		total[#total+i]=files.paths.langs.english[#total+i]
		totalnames[#total+i]=files.names.langs.english[#total+i]
	end
else
	for i=1,#files.paths.langs[sub(gensett.lang,1,-6)] do
		total[#total+i]=files.paths.langs[sub(gensett.lang,1,-6)][#total+i]
		totalnames[#total+i]=files.names.langs[sub(gensett.lang,1,-6)][#total+i]
	end
end
owo=100/#total
color(secondcolor)
fcolor(mainfcolor)
fill(3,h-4,w-4,4," ")
tools.bar(5,h-2,w-8,0)
for i=1,#total do
	set(5,h-3,totalnames[i])
	download(branch..total[i],totalnames[i])
	color(secondcolor)
	fcolor(mainfcolor)
	fill(3,h-4,w-4,4," ")
	tools.bar(5,h-2,w-8,i*owo)
end
file=io.open("/fos/System/generalSettings.cfg","w")
gensett.ver=files.version
data=finder.serialize(gensett)
file=io.open("/fos/system/generalSettings.cfg","w")
for i=1,#data do
	file:write(data[i])
	if i ~= #data then
		file:write("\n")
	end
end
file:close()
file=io.open("/fos/system/auto.cfg","w")
file:write("/fos/oobe.lua")
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
work=thread.create(working)
thread.waitForAny({wait,work})
wait:kill()
comp.shutdown(true)
end

open=0
lastopen=0
refresh=false
main()
first()
while true do
tip,_,mx,my,click=event.pull()
if tip == "touch" or tip == "scroll" then
	if mx >= x+71 and mx <= x+74 and my == y-1 then
		if adsett then
			adsett=false
		else
			adsett=true
		end
		refresh=true
	elseif adsett then
		if mx >= x+26 and mx <= x+73 and my == y+3 then
			if gensett.powerSafe then
				gensett.powerSafe=false
			else
				gensett.powerSafe=true
			end
			adrefresh()
			main()
			additional()
		elseif mx >= x+26 and mx <= x+73 and my == y+5 then
			if gensett.darkMode then
				gensett.darkMode=false
			else
				gensett.darkMode=true
			end
			adrefresh()
			main()
			additional()
		end
	elseif open == 0 then
		if mx >= x+72-slen and mx <= x+73 and my == y+21 and tip == "touch" then
			download(branch.."Install/"..gensett.lang,"/FOS/install/lang")
			file=io.open("/fos/install/lang","r")
			data={}
			for var in file:lines() do
				table.insert(data,var)
			end
			file:close()
			lang=finder.unserialize(data)
			open=1
		else
			for i=1,#langs do
				if mx >= x+28 and mx <= x+73 and my == y+2+i+(i-1) and langview ~= i then
					langview=i
					gensett.lang=langs.code[i]
					refresh=true
				end
			end
		end
	elseif open ~= 0 and mx == x+2 and my == y-1 and tip == "touch" then
		if open > 0 then
			open=open-1
		else
			open=open+1
		end
	elseif open == 1 then
		if mx >= x+72-slen and mx <= x+73 and my == y+21 and tip == "touch" then
			open=2
		elseif mx >= x+28 and mx <= x+73 and my >= y+3 and my <= y+19 and tip == "scroll" then
			if click == 1 then
				if mitview > 0 then
					mitview=mitview-click
				end
			else
				if mitview < mitlimit then
					mitview=mitview-click
				end
			end
			refresh=true		
		end
	elseif open == 2 then
		if mx >= x+26 and mx <= x+73 and my == y+3 then
			if allLangs then
				allLangs=false
			else
				allLangs=true
			end
			color(secondcolor)
			tools.lvr(x+69,y+3,_,"1")
			os.sleep(0.1)
			refresh=true
		elseif mx >= x+72-slen and mx <= x+73 and my == y+21 and tip == "touch" then
			open=3
		end
	end
	if lastopen ~= open or refresh then
		refresh=false
		lastopen=open
		mainfill()
		if adsett then
			additional()
		elseif open == 0 then
			first()
		elseif open == 1 then
			second()
		elseif open == 2 then
			third()
		elseif open == 3 then
			four()
		end
	end
end
end