local r=require
local gpu=r("component").gpu
local io=r("io")
local unicode=r("unicode")
local fs=r("filesystem")
local tools=r("fos/tools")
local w,h=gpu.getResolution();
local fill=gpu.fill
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set
local reg,lang,slang,appname={},{},{},{}
local file,lasttime,maincolor,secondcolor,mainfcolor,secondfcolor,moduleh
local function update()
lasttime=fs.lastModified("/fos/system/registry")
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
file=io.open("/fos/apps/settings.app/appname/"..reg.lang,"r")
for var in file:lines() do table.insert(appname,var) end
file:close()
file=io.open("/fos/apps/settings.app/lang/"..reg.lang,"r")
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
file=io.open(fs.concat("/fos/lang/shared",reg.lang),"r")
for var in file:lines() do
	check=var:find("=")
	if check ~= nil then
		arg=unicode.sub(var,1,check-1)
		var=unicode.sub(var,check+1)
		slang[arg]=var
	else
		table.insert(slang,var)
	end
end
file:close()
if reg.powerSafe == "1" then
	maincolor=0
	secondcolor=0x404040
	mainfcolor=0xffffff
	secondfcolor=0xbbbbbb
elseif reg.darkMode == "1" then
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
end
update()
color(maincolor)
fcolor(secondcolor)
fill(1,1,w,h-1," ")
set(w/2-4,h/2-1,"⠀⡠⠢⠎⠱⠔⢄⠀")
set(w/2-4,h/2,"⡨⠆⢀⠔⠢⡀⠰⢅")
set(w/2-4,h/2+1,"⢑⠆⠈⠢⠔⠁⠰⡊")
set(w/2-4,h/2+2,"⠀⠑⠔⢆⡰⠢⠊⠀")
local event=r("event")
local picture=r("fos/picture")
local term=r("term")
local len=unicode.len
local modules,moduleName={},{}
local open,erroroccured,errorviewed,rightpanel,oldrightpanel,menuY,errlen,errbtnlen=1,0,0,0,0,0,1,1
local module,result,reason,data,modulex,type,time,toApp
local taskbar=picture.screenshot(1,h,w,1)
if package.path:find(";/fos/apps/settings.app/modules/?/main.lua",1,true) == nil then
	package.path=package.path..";/fos/apps/settings.app/modules/?/main.lua"
end
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
errlen=len(lang.moduleErrMsg1)
set(modulex,5,lang.moduleErrMsg1)
fcolor(0xff0000)
errbtnlen=len(lang.moduleErrMsg2)
set(modulex+1+errlen,5,lang.moduleErrMsg2)
end

local function runModule(name,reg,lang)
module=r(name)
module.init(reg,lang)
end

modules=finder.files("/fos/apps/settings.app/modules")
for i=1,#modules do
	result=pcall(runModule,modules[i],reg,lang)
	if result then
		moduleName[i]=module.name
	else
		moduleName[i]=modules[i].." "..lang.moduleCorrupted
	end
end

local function bars()
picture.draw(1,h,taskbar)
color(maincolor)
fcolor(mainfcolor)
fill(1,1,w,1," ")
if w < 65 then
	set(2,1,"≡")
	set(4,1,appname[1].." - Restricted version")
else
	set(2,1,appname[1].." - Restricted version")
end
set(w-1,1,"X")
end

local function mainDraw()
if rightpanel == 1 or w > 64 then
	if w < 65 then
		oldrightpanel=1
		data=picture.screenshot(1,2,27,h-2)
	end
	fill(1,2,26,h-2," ")
	for i=1,#modules do
		if open == i then
			color(secondcolor)
			fill(2,6+i+i+menuY,24,1," ")
			fcolor(mainfcolor)
			set(3,6+i+i+menuY,unicode.sub(moduleName[i],1,22))
			color(maincolor)
			fcolor(secondcolor)
			set(2,5+i+i+menuY,"⣠⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣄")
			set(2,7+i+i+menuY,"⠙⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠋")
			moduleh=7+i+i
		else
			color(maincolor)
			fcolor(mainfcolor)
			set(3,6+i+i+menuY,unicode.sub(moduleName[i],1,22))
			moduleh=6+i+i
		end
	end
	bars()
	fill(1,2,26,5," ")
	local userColor=tonumber(reg.userColor) or tonumber("0x"..reg.userColor) or math.random(16777215)
	fcolor(userColor)
	set(2,3,"⢠⡶⢿⡿⢶⡄")
	set(2,4,"⣿⣇⣸⣇⣸⣿")
	set(2,5,"⠘⠿⣮⣵⠿⠃")
	set(2,6,"⣀⣤⣿⣿⣤⣀")
	fcolor(secondfcolor)
	if reg.passwordProtection == "1" then
		set(10,5,unicode.sub(slang.passwordYes,1,15))
	else
		set(10,5,unicode.sub(slang.passwordNo,1,15))
	end
	fcolor(mainfcolor)
	set(10,4,unicode.sub(reg.username,1,15))
else
	moduleh=0
end
if rightpanel == 0 and oldrightpanel == 1 and lastopen == open then
	oldrightpanel=0
	picture.draw(1,2,data)
end
screenh=h-4
hlimit=-(moduleh-screenh-2)
end

fill(1,2,w,h-2," ")
mainDraw()
result,reason=xpcall(runModule,debug.traceback,modules[open],reg,lang)
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
	type,_,x,y,click=event.pull()
	if rightpanel == 1 and w < 65 then
		if type == "scroll" and x < 27 then
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
		elseif type == "touch" then
			for i=1,#modules do
				if x >= 2 and x <= 26 and y == 6+i+i+menuY then
					open=i
					rightpanel=0
				end
			end
			if lastopen ~= open then
				erroroccured=0
				module.save()
				time=fs.lastModified("/fos/system/registry")
				if time ~= lasttime then
					update()
				end
				fill(1,2,w,h-2," ")
				mainDraw()
				result,reason=xpcall(runModule,debug.traceback,modules[open],reg,lang)
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
				module.save()
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
			elseif x >= modulex+1+errlen and x <= modulex+errlen+errbtnlen and y == 5 and erroroccured == 1 then
				fill(1,2,w,h-2," ")
				term.setCursor(1,2)
				print(reason)
				event.pull("touch")
				open=0
				lastopen=0
				rightpanel=1
				mainDraw()
			end
		end
	elseif w < 65 and type == "touch" and rightpanel == 0 and y ~= 1 and erroroccured == 0 then
		toApp,wtr=module.press(type,x,y,click)
		if toApp ~= "noupdateui" then
			module.draw(modulex,3)
			bars()
		end
	elseif w < 65 and type == "scroll" and rightpanel == 0 then
		toApp,wtr=module.press(type,x,y,click)
		if toApp ~= "noupdateui" then
			module.draw(modulex,3)
			bars()
		end
	else
		if type == "scroll" and x < 27 then
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
		elseif type == "scroll" then
			toApp,wtr=module.press(type,x,y,click)
			if toApp ~= "noupdateui" then
				module.draw(modulex,3)
				bars()
			end
		elseif type == "touch" then
			if rightpanel == 1 then
				for i=1,#modules do
					if x >= 2 and x <= 26 and y == 6+i+i+menuY then
						open=i
					end
				end
			end
			if lastopen ~= open then
				erroroccured=0
				module.save()
				update()
				fill(1,2,w,h-2," ")
				mainDraw()
				result,reason=xpcall(runModule,debug.traceback,modules[open],reg,lang)
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
				module.save()
				os.exit()
			elseif x >= 1 and x <= 3 and y == 1 and w < 65 then
				if rightpanel == 1 then
					rightpanel=0
				else
					rightpanel=1
				end
				mainDraw()
			elseif x >= modulex+1+errlen and x <= modulex+errlen+errbtnlen and y == 5 and erroroccured == 1 then
				open=0
				lastopen=0
				rightpanel=0
				fill(1,2,w,h-2," ")
				term.setCursor(1,2)
				print(reason)
				event.pull("touch")
				rightpanel=1
				mainDraw()
			elseif erroroccured == 0 then
				toApp,wtr=module.press(type,x,y,click)
				if toApp ~= "noupdateui" then
					module.draw(modulex,3)
					bars()
				end
			end
		end
	end
	if toApp == "reboot" then
		module.save()
		update()
		mainDraw()
		module.init(reg,lang,wtr)
		module.draw(modulex,3)
	end
end