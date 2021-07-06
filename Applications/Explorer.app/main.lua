local r=require
local gpu=r("component").gpu
local tools=r("fos/tools")
local finder=r("fos/finder")
local system=r("fos/system")
local picture=r("fos/picture")
local event=r("event")
local os=r("os")
local unicode=r("unicode")
local fs=r("filesystem")
local term=r("term")
local len=unicode.len
local fill=gpu.fill
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set
local cords={}
local lang={}
local slang={}
local reg={}
local pos,sysfcolor,syscolor,slen,openfilename,filepos,eSkipCon,file,w,h,click,data
local path="/"
local args={...}
if type(args[1]) == "string" then
path=args[1]
end

function expLoad()
lang={}
slang={}
sett={}
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
	syscolor=0
	sysfcolor=0xffffff
else
	syscolor=0xffffff
	sysfcolor=0
end
w=tonumber(reg.width)
h=tonumber(reg.height)
end

function expDraw()
color(syscolor)
fill(1,1,w,h-1," ")
tools.btn(3,1,"<-")
color(0xb40000)
fcolor(0xffffff)
set(w-2,1," X ")
color(syscolor)
fcolor(sysfcolor)
slen=len(path)
set(w/2-slen/2+1,1,path)
filesname=finder.files(path)
system.workplace(syscolor,sysfcolor,filesname,path)
cords=system.createButtons(syscolor,filesname)
end

expLoad()
expDraw()
data=picture.screenshot(1,h,w,1)
while true do
picture.draw(1,h,data)
eSkipCon=0
local _,_,x,y,click=event.pull("touch")
if y ~= 1 and y ~= h then
	openfilename,filepos,eSkipCon=system.pressButton(cords,filesname,x,y,click)
	if eSkipCon == 0 then
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
		if openfile ~= nil and openfilename ~= nil then
			color(0x1e90ff)
			color(0)
			fcolor(0xffffff)
			if openfilename:find(".txt") ~= nil then
				color(0xb40000)
				fcolor(0xffffff)
				set(w-2,1," X ")
				color(syscolor)
				fcolor(sysfcolor)
				fill(1,1,w-3,1," ")
				fill(1,2,w,h-2," ")
				openfilename=unicode.sub(openfilename,1,-5)
				set(1,1,openfilename.." - "..lang.txtName)
				openfiletext={}
				slen=len(openfilename)
				for var in io.open(openfile,"r"):lines() do	table.insert(openfiletext,var) end
				i=1
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
				if fs.isDirectory(openfile) ~= true then
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
				else
					path=openfile
				end
			end
			expLoad()
			expDraw()
		end
	end
end
if y ~= h and click == 1 and eSkipCon == 1 then
	pos=tools.conMenu(x,y,{slang.conEdit,"|","<gray>"..slang.conCopy,"<gray>"..slang.conPaste,"<gray>"..slang.conCut,"|",slang.conCreate,slang.conCreateDir,slang.conDelete,slang.conRename,"|","<gray>"..slang.conProp})
	if pos == 1 then
		if reg.powerSafe == "1" then
			color(0)
		else
			color(0x2b2b2b)
		end
		fcolor(0xffffff)
		os.execute("edit '"..path.."/"..openfilename.."'")
		expDraw()
	elseif pos == 10 then
		temp=system.createWindow(openfilename,path)
		if temp ~= nil then
			fs.rename(path.."/"..openfilename,path.."/"..temp)
		end
	expDraw()
	elseif pos == 7 then
		temp=system.createWindow(slang.newFile,path)
		if temp ~= nil then
			file=io.open(path.."/"..temp,"w")
			file:close()
		end
	expDraw()
	elseif pos == 8 then
		temp=system.createWindow(slang.newFolder,path,1)
		if temp ~= nil then
			fs.makeDirectory(path.."/"..temp)
		end
	expDraw()
	elseif pos == 9 then
		temp=system.deleteWindow(openfilename,path)
		if temp ~= nil then
			fs.remove(path.."/"..temp)
		end
	expDraw()
	end
elseif y ~= h and click == 1 and eSkipCon == 0 then
	pos=tools.conMenu(x,y,{"<gray>"..slang.conPaste,"|",slang.conCreate,slang.conCreateDir,"|",slang.conRefresh})
	if pos == 6 then
		expDraw()
	elseif pos == 3 then
		temp=system.createWindow(slang.newFile,path)
		if temp ~= nil then
			file=io.open(path.."/"..temp,"w")
			file:close()
		end
		expDraw()
	elseif pos == 4 then
		temp=system.createWindow(slang.newFolder,path,1)
		if temp ~= nil then
			fs.makeDirectory(path.."/"..temp)
		end
		expDraw()
	end
elseif x >= 2 and x <= 5 and y == 1 then
	if len(path) > 1 then
		temp=fs.segments(path)
		temp=len(temp[#temp])
		path=unicode.sub(path,1,-(temp+2))
		expDraw()
	end
elseif x >= w-2 and x <= w and y == 1 then
	os.exit()
end
end