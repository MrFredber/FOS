--FOS (Fredber Operational System) is a Russian os made to facilitate the use of the OpenComputers computer
--debug function: print(tools.tblprint(table))
local r=require
local c=r("component")
local term=r("term")
local gpu=c.gpu
local fill=gpu.fill
local os=r("os")
local io=r("io")
local fs=r("filesystem")
local unicode=r("unicode")
local lang={}
local sett={}
local user={}
local compcfg={}

function fosLoad()
	lang={}
	sett={}
	user={}
	compcfg={}
	file=io.open("/fos/system/lang.cfg","r")
	for var in file:lines() do table.insert(sett,var) end
	file:close()
	file=io.open(fs.concat("/fos/lang/fos",sett[1]),"r")
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
	file=io.open("/fos/system/user.cfg","r")
	for var in file:lines() do table.insert(user,var) end
	file:close()
	local file=io.open("/fos/system/comp.cfg","r")
	for var in file:lines() do
		pos=var:find(",")
		if pos ~= nil then
			w=tonumber(var:sub(1,pos-1))
			h=tonumber(var:sub(pos+1))
		else
			table.insert(compcfg,var)
		end
	end
	gpu.setResolution(w,h)
end
fosLoad()

local screen=c.screen
local event=r("event")
local comp=r("computer")
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set
local system=r("fos/system")
local finder=r("fos/finder")
local icons=r("fos/icons")
local picture=r("fos/picture")
local a=0
local openfile=0
local openfilename=0
local openfiletext=0
local lnk={}
local slen=0
local appname=0
local appnamefile={}
local delay=0
local smax=0
local ver="a6-1"
local path="/fos/desktop"
local filesname={}

--Functions
local function draw()
system.background();
set(1,1,lang.ver..ver)
local filesname=finder.files(path);
local cords=system.createButtons(filesname,sett,1,1)
system.workplace(filesname,path,lang,sett);
return filesname end
----------
if user[3] == "1" then
	system.lock(lang)
end
draw();

while true do
local _,_,x,y=event.pull("touch")

if y ~= h and menu ~= 1 then
	local filesname=finder.files(path);
	local cords=system.createButtons(filesname,sett,1,1)
	local openfilename,filepos=system.pressButton(cords,filesname,x,y)
	system.updAfterPress(openfilename,filepos,lang,sett,path)
	local openfile=fs.concat(path,openfilename)
	if string.find(openfile,".lnk") ~= nil then
		lnk={}
		for var in io.open(openfile,"r"):lines() do	
			table.insert(lnk, var) 
		end
		openfile=lnk[1]
		openfilename=fs.name(lnk[1]).."/"
	end
 	if string.find(openfile,".app") ~= nil then
		openfile=openfile.."/main.lua"
		appnamefile=io.open("/fos/apps/"..openfilename.."appname/"..sett[1],"r")
		appname={}
		for var in appnamefile:lines() do
			table.insert(appname,var)
		end
		appnamefile:close()
		openfilename=appname[1]
	end
	if openfile ~= nil and openfilename ~= nil then
		color(0xffffff)
		fill(1,1,w,1," ")
		color(0xb40000)
		fcolor(0xffffff)
		set(w-2,1," X ")
		color(0x1e90ff)
		slen=unicode.len(openfilename)
		fill(3,h,slen+2,1," ")
		set(4,h,openfilename)
		fcolor(0)
		color(0xffffff)	
		set(1,1,openfilename)
		fcolor(0xffffff)
		if string.find(openfilename,".txt") ~= nil then
			openfiletext={}
			slen=string.len(openfilename)
			for var in io.open(openfile,"r"):lines() do
				table.insert(openfiletext,var)
			end
			i=1
			fcolor(0)
			fill(1,2,w,h-2," ")
			term.setCursor(1,2)
			if #openfiletext > h-2 then
				set(slen+1,1," - "..lang.txtMany)
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
			local result,reason=loadfile(openfile)
			if result then
    			result,reason=xpcall(result,debug.traceback,...)
			    if not result then
			    	if type(reason) ~= "table" then
			    		system.bsod(reason,lang)
			    	end
			    end
			else
				if type(reason) ~= "table" then
			    	system.bsod(reason,lang)
				end
			end
		end
		fosLoad()
		draw()
	end
end

--Рисование меню
if x == 1 and y == h and sleep ~= 1 then
smax,data=system.drawMenu(lang,user)
menu=1
delay=1
end

if x >= 1 and x <= smax and y == h-5 and menu == 1 and sleep ~= 1 then
	menu=0
	system.lock(lang)
	draw()
elseif x >= 1 and x <= smax and y == h-4 and menu == 1 and sleep ~= 1 then
	lang=nil
	system.shell()
elseif x > 0 and x <= smax and y == h-3 and menu == 1 and sleep ~= 1 then
	sleep=1
	screen.turnOff()
elseif x > 0 and x <= smax and y == h-2 and menu == 1 and sleep ~= 1 then
	comp.shutdown(false)
elseif x > 0 and x <= smax and y == h-1 and menu == 1 and sleep ~= 1 then
	comp.shutdown(true)
elseif sleep == 1 and x ~= 0 then
	sleep=0
	screen.turnOn()
elseif menu == 1 and delay ~= 1 then
	picture.draw(1,h-5,data)
	menu=0
else
	delay=0
end
end