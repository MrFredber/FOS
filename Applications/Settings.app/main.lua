local r=require
local gpu=r("component").gpu
local io=r("io")
local unicode=r("unicode")
local fs=r("filesystem")
local tools=r("fos/tools")
local system=r("fos/system")
local finder=r("fos/finder")
local w,h=gpu.getResolution();
local fill=gpu.fill
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set
local user,lang,slang,nlang,corrupted={},{},{},{},{}
local file,maincolor,secondcolor,mainfcolor,secondfcolor,moduleh,name,oldname
local function update()
w,h,user,_,slang,nlang=system.init()
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
lang={}
file=io.open("/fos/apps/settings.app/lang/"..user.lang,"r")
for var in file:lines() do
	table.insert(lang,var)
end
file:close()
lang=finder.unserialize(lang)
tools.update(user)
var=nil
end

update()
color(maincolor)
fcolor(secondcolor)
local icons=r("fos/icons")
local event=r("event")
local picture=r("fos/picture")
local term=r("term")
local len=unicode.len
local modules,moduleName={},{}
local open,erroroccured,rightpanel,oldrightpanel,menuY=1,0,0,0,0
local module,result,reason,data,modulex,tip,time,toApp
local taskbar=picture.screenshot(1,h,w,1)
package.path="/lib/?.lua;/usr/lib/?.lua;/home/lib/?.lua;./?.lua;/lib/?/init.lua;/usr/lib/?/init.lua;/home/lib/?/init.lua;./?/init.lua;/fos/apps/settings.app/modules/?/main.lua"
if w < 65 then
	modulex=2
else
	modulex=27
	rightpanel=1
end

local function settingsError()
color(maincolor)
fcolor(mainfcolor)
fill(modulex,2,w-modulex+1,h-2," ")
set(modulex,3,lang.moduleErr)
temp=tools.wrap(reason,w-modulex)
fcolor(secondfcolor)
for i=1,#temp do
	set(modulex,4+i,temp[i])
end
end

local function runModule(name,user,lang)
if oldname then
	package.loaded[oldname]=nil
end
module=r(name)
module.init(user,lang)
oldname=name
end

modules=finder.files("/fos/apps/settings.app/modules")
for i=1,#modules do
	result=pcall(runModule,modules[i],user,lang)
	if result then
		moduleName[i]=module.name
	else
		moduleName[i]=modules[i]
		corrupted[i]=true
	end
end

local function bars()
system.taskbarDraw()
color(maincolor)
fcolor(mainfcolor)
fill(1,1,w,1," ")
set(w-1,1,"x")
if w < 65 then
	set(2,1,"≡")
	set(4,1,nlang["/fos/apps/settings.app/"])
	fcolor(secondfcolor)
	set(5+len(nlang["/fos/apps/settings.app/"]),1,"WIP")
else
	set(2,1,nlang["/fos/apps/settings.app/"])
	fcolor(secondfcolor)
	set(3+len(nlang["/fos/apps/settings.app/"]),1,"WIP")
end
end

local function mainDraw()
if rightpanel == 1 or w > 64 then
	if w < 65 then
		oldrightpanel=1
		data=picture.screenshot(1,2,27,h-2)
	end
	color(maincolor)
	fcolor(mainfcolor)
	fill(1,2,27,h-2," ")
	for i=1,#modules do
		if open == i then
			color(secondcolor)
			fill(2,6+i+i+menuY,24,1," ")
			fcolor(mainfcolor)
			set(3,6+i+i+menuY,unicode.sub(moduleName[i],1,22))
			if corrupted[i] then
				fcolor(secondfcolor)
				slen=len(unicode.sub(moduleName[i],1,22))
				set(4+slen,6+i+i+menuY,unicode.sub(lang.moduleCorrupted,1,22-slen))
			end
			color(maincolor)
			fcolor(secondcolor)
			set(2,5+i+i+menuY,"⣠⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣄")
			set(2,7+i+i+menuY,"⠙⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠋")
			moduleh=7+i+i
		else
			color(maincolor)
			fcolor(mainfcolor)
			set(3,6+i+i+menuY,unicode.sub(moduleName[i],1,22))
			if corrupted[i] then
				fcolor(secondfcolor)
				slen=len(unicode.sub(moduleName[i],1,22))
				set(4+slen,6+i+i+menuY,unicode.sub(lang.moduleCorrupted,1,22-slen))
			end
			moduleh=6+i+i
		end
	end
	fill(1,2,27,5," ")
	local userColor=user.userColor or 0x0094ff
	icons.user(2,3,userColor)
	color(maincolor)
	fcolor(secondfcolor)
	if user.passwordProtection then
		set(11,5,unicode.sub(slang.passwordYes,1,13))
	else
		set(11,5,unicode.sub(slang.passwordNo,1,13))
	end
	fcolor(mainfcolor)
	set(11,4,unicode.sub(user.name,1,13))
else
	moduleh=0
end
if rightpanel == 0 and oldrightpanel == 1 and lastopen == open then
	oldrightpanel=0
	picture.draw(1,2,data)
	data=nil
end
screenh=h-4
hlimit=-(moduleh-screenh-2)
end

fill(1,2,w,h-2," ")
mainDraw()
result,reason=xpcall(runModule,debug.traceback,modules[open],user,lang)
if not result then
	settingsError()
	erroroccured=1
	open=0
	lastopen=0
else
	module.draw(modulex,3)
	bars()
end

while true do
	lastopen=open
	tip,_,x,y,click=event.pull()
	if rightpanel == 1 and w < 65 then
		if tip == "scroll" and x < 27 then
			if click == 1 then
				if menuY < 0 then
					menuY=menuY+click
					mainDraw()
				end
			else
				if menuY > hlimit then
					menuY=menuY+click
					mainDraw()
				end
			end
		elseif tip == "touch" then
			for i=1,#modules do
				if x >= 2 and x <= 26 and y == 6+i+i+menuY then
					open=i
					rightpanel=0
				end
			end
			if lastopen ~= open then
				if erroroccured == 1 then
					erroroccured=0
				else
					module.save()
				end
				fill(1,2,w,h-2," ")
				mainDraw()
				result,reason=xpcall(runModule,debug.traceback,modules[open],user,lang)
				if not result then
					settingsError()
					erroroccured=1
					open=0
					lastopen=0
				else
					module.draw(modulex,3)
					bars()
				end
			elseif x >= w-2 and x <= w and y == 1 then
				if erroroccured == 0 then
					module.save()
				end
				package.loaded[oldname]=nil
				os.exit()
			elseif (x >= 1 and x <= 3 and y == 1) or (x > 26) and w < 65 then
				if rightpanel == 1 then
					rightpanel=0
				else
					rightpanel=1
				end
				mainDraw()
			elseif lastopen == open and oldrightpanel == 1 then
				mainDraw()
			--elseif x >= modulex+1+errlen and x <= modulex+errlen+errbtnlen and y == 5 and erroroccured == 1 then
				--fill(1,2,w,h-2," ")
				--term.setCursor(1,2)
				--print(reason)
				--event.pull("touch")
				--open=0
				--lastopen=0
				--rightpanel=1
				--mainDraw()
			end
		end
	elseif w < 65 and tip == "touch" and rightpanel == 0 and y ~= 1 and erroroccured == 0 then
		toApp,wtr=module.press(tip,x,y,click)
		if toApp ~= "noupdateui" or toApp ~= "reboot" then
			module.draw(modulex,3)
			bars()
		end
	elseif w < 65 and tip == "scroll" and rightpanel == 0 then
		toApp,wtr=module.press(tip,x,y,click)
		if toApp ~= "noupdateui" or toApp ~= "reboot" then
			module.draw(modulex,3)
			bars()
		end
	else
		if tip == "scroll" and x < 27 then
			if click == 1 then
				if menuY < 0 then
					menuY=menuY+click
					mainDraw()
				end
			else
				if menuY > hlimit then
					menuY=menuY+click
					mainDraw()
				end
			end
		elseif tip == "scroll" then
			toApp,wtr=module.press(tip,x,y,click)
			if toApp ~= "noupdateui" or toApp ~= "reboot" then
				module.draw(modulex,3)
				bars()
			end
		elseif tip == "touch" then
			if rightpanel == 1 then
				for i=1,#modules do
					if x >= 2 and x <= 26 and y == 6+i+i+menuY then
						open=i
					end
				end
			end
			if lastopen ~= open then
				if erroroccured == 1 then
					erroroccured=0
				else
					module.save()
				end
				update()
				fill(1,2,w,h-2," ")
				mainDraw()
				result,reason=xpcall(runModule,debug.traceback,modules[open],user,lang)
				if not result then
					settingsError()
					erroroccured=1
					open=0
					lastopen=0
				else
					module.draw(modulex,3)
					bars()
				end
			elseif x >= w-2 and x <= w and y == 1 then
				if erroroccured == 0 then
					module.save()
				end
				package.loaded[oldname]=nil
				os.exit()
			elseif x >= 1 and x <= 3 and y == 1 and w < 65 then
				if rightpanel == 1 then
					rightpanel=0
				else
					rightpanel=1
				end
				mainDraw()
			--elseif x >= modulex+1+errlen and x <= modulex+errlen+errbtnlen and y == 5 and erroroccured == 1 then
			--	open=0
			--	lastopen=0
			--	rightpanel=0
			--	fill(1,2,w,h-2," ")
			--	term.setCursor(1,2)
			--	print(reason)
			--	event.pull("touch")
			--	rightpanel=1
			--	mainDraw()
			elseif erroroccured == 0 then
				toApp,wtr=module.press(tip,x,y,click)
				if toApp ~= "noupdateui" or toApp ~= "reboot" then
					module.draw(modulex,3)
					bars()
				end
			end
		end
	end
	if toApp == "reboot" then
		toApp=nil
		module.save()
		update()
		mainDraw()
		module.init(user,lang,wtr)
		module.draw(modulex,3)
		bars()
	end
end