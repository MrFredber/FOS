--FOS (Fredber Operational System) is a Russian os made to facilitate the use of the OpenComputers computer
--debug function: print(tools.tblprint(table))
local r=require
local c=r("component")
local term=r("term")
local os=r("os")
local io=r("io")
local fs=r("filesystem")
local unicode=r("unicode")
local system=r("fos/system")
local tools=r("fos/tools")
local gpu=c.gpu
local fill=gpu.fill
local len=unicode.len
local lang,slang,reg={},{},{}
local file,sysfcolor,syscolor

local function fosLoad()
lang={}
slang={}
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
file=io.open(fs.concat("/fos/lang/fos",reg.lang),"r")
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
if gpu.maxDepth() == 1 then
	term.clear()
	print(lang.depthErr)
	os.exit()
end
if reg.powerSafe == "1" then
	syscolor=0
	sysfcolor=0xffffff
else
	syscolor=0x2b2b2b
	sysfcolor=0
end
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
w,h=system.update(reg,lang,slang)
end
fosLoad()

local screen=c.screen
local event=r("event")
local thread=r("thread")
local comp=r("computer")
local finder=r("fos/finder")
local icons=r("fos/icons")
local picture=r("fos/picture")
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set
local lnk,filesname,appnamefile,cords={},{},{},{}
local menu,delay,sleep,smax,data,openfile,openfilename,openfiletext,pos,filepos,skipCon,slen,appname=0,0,0,0
local path="/fos/desktop"

--Functions
local function draw()
system.background(syscolor,0xffffff);
set(1,1,lang.ver..reg.ver)
filesname=finder.files(path);
system.workplace(syscolor,0xffffff,filesname,path);
cords=system.createButtons(syscolor,filesname,sett,1,1)
end
----------
if reg.passwordProtection == "1" then
	system.lock(syscolor)
end
draw();

while true do
local _,_,x,y,click=event.pull("touch")

if y ~= h and menu == 0 then
	openfilename,filepos,skipCon=system.pressButton(cords,filesname,x,y,click)
	if skipCon == 0 then
		system.updAfterPress(openfilename,filepos,path)
		openfile=fs.concat(path,openfilename)
		if openfile:find(".lnk") ~= nil then
			lnk={}
			for var in io.open(openfile,"r"):lines() do	table.insert(lnk,var) end
			if fs.exists(lnk[1]) == true then
				openfile=lnk[1]
				openfilename=fs.name(lnk[1])
			else
				tools.error("Path not exists: "..lnk[1],2)
			end
		end
 		if openfile:find(".app") ~= nil then
 			openfilename=unicode.sub(openfile,11)
			openfile=openfile.."/main.lua"
			if fs.exists("/fos/apps/"..openfilename.."/appname/"..reg.lang) == true then
				file=io.open("/fos/apps/"..openfilename.."/appname/"..reg.lang,"r")
				appname={}
				for var in file:lines() do
					table.insert(appname,var)
				end
				file:close()
				openfilename=appname[1]
			end
		end
		if openfile ~= nil and openfilename ~= nil and menu == 0 then
			color(0x1e90ff)
			fcolor(0xffffff)
			slen=len(openfilename)
			fill(3,h,slen+2,1," ")
			set(4,h,openfilename)
			color(0)
			fcolor(0xffffff)
			if openfilename:find(".txt") ~= nil then
				color(0xb40000)
				fcolor(0xffffff)
				set(w-2,1," X ")
				if reg.powerSafe == "1" then
					color(0)
				else
					color(0xffffff)
				end
				fcolor(sysfcolor)
				fill(1,1,w-3,1," ")
				openfilename=unicode.sub(openfilename,1,-5)
				set(1,1,openfilename.." - "..lang.txtName)
				openfiletext={}
				slen=len(openfilename)
				for var in io.open(openfile,"r"):lines() do	table.insert(openfiletext,var) end
				i=1
				fill(1,2,w,h-2," ")
				term.setCursor(1,2)
				if #openfiletext > h-2 then
					set(slen+1,1," - "..lang.txtMany.." - "..lang.txtName)
				end
				while i-1 ~= #openfiletext do
					print(openfiletext[i])
					i=i+1
					if i > h-2 then
						break
					end
				end
				while true do
					local _,_,x,y=event.pull("touch")
					if x >= w-2 and x <= w and y == 1 then
						break
					end
				end
			else
				color(0)
				fcolor(0xffffff)
				if fs.isDirectory(openfile) == true then
					local result,reason=loadfile("/fos/apps/Explorer.app/main.lua")
					if result then
    					result,reason=xpcall(result,debug.traceback,openfile)
					    if not result then
					    	if type(reason) ~= "table" then
					    		system.bsod(reason)
					    	end
					    end
					else
						if type(reason) ~= "table" then
					    	system.bsod(reason)
						end
					end
				else
					local result,reason=loadfile(openfile)
					if result then
    					result,reason=xpcall(result,debug.traceback,...)
					    if not result then
					    	if type(reason) ~= "table" then
					    		system.bsod(reason)
					    	end
					    end
					else
						if type(reason) ~= "table" then
					    	system.bsod(reason)
						end
					end
				end
			end
			fosLoad()
			draw()
		end
	end
end

--System Menu
if x == 1 and y == h and sleep ~= 1 and click == 0 and menu == 0 then
	smax,data=system.drawMenu()
	menu=1
	delay=1
elseif x == 1 and y == h and sleep ~= 1 and click == 1 and menu == 0 then
	pos=tools.conMenu(1,h-1,{lang.about})
	if pos == 1 then
		tools.error("Coming soon.")
	end
elseif y ~= h and sleep ~= 1 and click == 1 and skipCon == 1 then
	pos=tools.conMenu(x,y,{slang.conEdit,"|","<gray>"..slang.conCopy,"<gray>"..slang.conPaste,"<gray>"..slang.conCut,"|",slang.conCreate,slang.conCreateDir,slang.conDelete,slang.conRename,"|","<gray>"..slang.conProp})
	if pos == 1 then
		os.execute("edit '"..path.."/"..openfilename.."'")
		draw()
	elseif pos == 10 then
		temp=system.createWindow(openfilename,path)
		if temp ~= nil then
			fs.rename(path.."/"..openfilename,path.."/"..temp)
		end
		draw()
	elseif pos == 7 then
		temp=system.createWindow(slang.newFile,path)
		if temp ~= nil then
			file=io.open(path.."/"..temp,"w")
			file:close()
		end
		draw()
	elseif pos == 8 then
		temp=system.createWindow(slang.newFolder,path,1)
		if temp ~= nil then
			fs.makeDirectory(path.."/"..temp)
		end
		draw()
	elseif pos == 9 then
		temp=system.deleteWindow(openfilename,path)
		if temp ~= nil then
			fs.remove(path.."/"..temp)
		end
		draw()
	end
elseif y ~= h and sleep ~= 1 and click == 1 and skipCon == 0 then
	pos=tools.conMenu(x,y,{"<gray>"..slang.conPaste,"|",slang.conCreate,slang.conCreateDir,"|",slang.conRefresh})
	if pos == 6 then
		draw()
	elseif pos == 3 then
		temp=system.createWindow(slang.newFile,path)
		if temp ~= nil then
			file=io.open(path.."/"..temp,"w")
			file:close()
		end
		draw()
	elseif pos == 4 then
		temp=system.createWindow(slang.newFolder,path,1)
		if temp ~= nil then
			fs.makeDirectory(path.."/"..temp)
		end
		draw()
	end
end

if x >= 1 and x <= smax and y >= h-13 and y <= h-10 and menu == 1 and sleep ~= 1 and click == 0 then
	pos=tools.conMenu(x,y,{lang.logoff})
	if pos == 1 and reg.passwordProtection == "1" then
		menu=0
		system.lock(syscolor)
		draw()
	end
elseif x >= 1 and x <= smax and y == h-8 and menu == 1 and sleep ~= 1 and click == 0 then
	lang=nil
	color(0)
	fcolor(0xffffff)
	term.clear()
	os.exit()
elseif x > 0 and x <= smax and y == h-6 and menu == 1 and sleep ~= 1 and click == 0 then
	sleep=1
	screen.turnOff()
elseif x > 0 and x <= smax and y == h-4 and menu == 1 and sleep ~= 1 and click == 0 then
	comp.shutdown(false)
elseif x > 0 and x <= smax and y == h-2 and menu == 1 and sleep ~= 1 and click == 0 then
	comp.shutdown(true)
elseif sleep == 1 then
	sleep=0
	screen.turnOn()
elseif menu == 1 and delay ~= 1 then
	picture.draw(1,h-14,data)
	menu=0
else
	delay=0
end
end