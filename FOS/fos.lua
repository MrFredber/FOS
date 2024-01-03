--FOS (Fredber Operational System) is an OS, based on OpenOS for minecraft mod OpenComputers.
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
local lang,slang,nlang,user,files,obl,current={},{},{},{},{},{},{}
local file,path
local currPage=1

local function fosLoad()
user,lang,slang,nlang={},{},{},{}
w,h,user,lang,slang,nlang=system.init()
path=user.path.."desktop/"
tools.update(user)
currPage=1
files=finder.files(path)
obl=system.createPages(3,2,w-2,h-2,path,files,user.useXOffset,user.useYOffset)
current=obl.pages[currPage]
end

w,h,user,lang,slang,nlang=system.init(true)
if gpu.maxDepth() == 1 then
	term.clear()
	print(lang.depthErr)
	os.exit()
end

local screen=c.screen
local event=r("event")
local comp=r("computer")
local finder=r("fos/finder")
local icons=r("fos/icons")
local picture=r("fos/picture")
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set
local ignoreLastChoose,menu,delay,sleep,smax,choose,lastchoose,open,data,pos,skipCon,slen=false,0,0,0,0,0,0,0

local function draw()
if user.powerSafe then
	color(0)
else
	color(user.desktopColor or 0x1e1e1e)
end
fill(1,1,w,h," ")
temp=math.floor(h/2-(#obl.pages/2-1))
if #obl.pages > 1 then
	for i=1,#obl.pages do
		if i == currPage then
			tools.radioBtn(w-1,temp,true)
		else
			tools.radioBtn(w-1,temp,false)
		end
		temp=temp+1
	end
end
system.taskbarDraw()
system.drawPage(user,obl,currPage)
end

system.login()
fosLoad()
draw()

local function editItem(a) 
	if fs.exists("/tmp/timerid") then
		file=io.open("/tmp/timerid","r")
		event.cancel(tonumber(file:read("*all")))
		file:close()
		fs.remove("/tmp/timerid")
	end
	fcolor(mainfcolor)
	color(maincolor)
	os.execute("edit '"..(a or current.paths[choose]).."'")
	open,lastopen,choose,lastchoose=0,0,0,0
	fosLoad()
	draw()
end

local function createItem()
	temp=system.newFile()
	if temp ~= nil then
		if fs.exists(path..temp) then
			while true do
				tools.error({slang.itemExistsErr},1)
				temp=system.rename(temp)
				if temp ~= nil then
					if not fs.exists(path..temp) then
						break
					end
				else
					break
				end
			end
		end
	end
	if temp ~= nil then --Создание
		file=io.open(path..temp,"w")
		file:close()
	end
	system.drawChooseReset()
	ignoreLastChoose=true
	choose=0
	draw()
end

local function createFolder()
	temp=system.newFolder()
	if fs.exists(path..temp) then
		while true do
			tools.error({slang.itemExistsErr},1)
			if sub(temp,-1,-1) == "/" then
				temp=sub(temp,1,-2)
			end
			temp=system.rename(temp)
			if temp ~= nil then
				if not fs.exists(path..temp) then
					break
				end
			else
				break
			end
		end
	end
	if temp ~= nil then
		fs.makeDirectory(path..temp)
		fosLoad()
	end
	system.drawChooseReset()
	ignoreLastChoose=true
	choose=0
	draw()
end

local function renameItem()
	temp=system.rename(current.fullNames[choose])
	if fs.exists(path..temp) then
		while true do
			tools.error({slang.itemExistsErr},1)
			if sub(temp,-1,-1) == "/" then
				temp=sub(temp,1,-2)
			end
			temp=system.rename(temp)
			if temp ~= nil then
				if not fs.exists(path..temp) then
					break
				end
			else
				break
			end
		end
	end
	if temp ~= nil then
		fs.rename(current.paths[choose],path..temp)
		fosLoad()
	end
	system.drawChooseReset()
	ignoreLastChoose=true
	choose=0
	draw()
end

local function deleteItem(a,b)
	temp=system.deleteConfirm(obl,currPage,choose,a)
	if temp then
		if a then
			fs.remove(current.paths[choose])
		else
			if b then --lnk
				fs.remove(current.tmppaths[choose])
			else
				fs.remove(current.paths[choose])
			end
		end
		fosLoad()
	end
	system.drawChooseReset({path..current.fullNames[choose]})
	ignoreLastChoose=true
	choose=0
	draw()
end

local function enterDir(b)
	local result,reason=loadfile("/fos/apps/Explorer.app/main.lua")
	if result then
		result,reason=xpcall(result,debug.traceback,b or current.tmppaths[open] or current.paths[open])
	    if not result then
	    	if type(reason) ~= "table" then
	    		system.bsod(current.tmpfullNames[open] or current.fullNames[open],reason)
	    	end
	    end
	else
		if type(reason) ~= "table" then
	    	system.bsod(current.tmpfullNames[open] or current.fullNames[open],reason)
		end
	end
	system.drawChooseReset()
	ignoreLastChoose=true
	choose=0
	fosLoad()
	draw()
end

while true do
local tip,_,x,y,click=event.pull()
skipCon=0
open=0
lastchoose=choose
found=false
if tip == "scroll" then
	if #obl.pages > 1 then
		if click == 1 and currPage > 1 then
			currPage=currPage-click
			system.drawChooseReset()
			lastchoose,choose,open=0,0,0
			current=obl.pages[currPage]
			draw()
		elseif click == -1 and currPage < #obl.pages then
			currPage=currPage-click
			system.drawChooseReset()
			lastchoose,choose,open=0,0,0
			current=obl.pages[currPage]
			draw()
		end
	end
elseif tip == "touch" then
	if obl.totalfiles > 0 then
		for i=1,#current.x do
			if x >= current.x[i] and x <= current.x[i]+9 and y >= current.y[i] and y <= current.y[i]+5 then
				found=true
				skipCon=1
				if choose == i and click == 0 then
					choose=0
					lastchoose=0
					open=i
				elseif lastchoose ~= i then
					choose=i
					if lastchoose ~= choose and lastchoose ~= 0 and not ignoreLastChoose then
						system.drawChoose(obl,currPage,lastchoose,_,true)
					elseif ignoreLastChoose then
						ignoreLastChoose=false
					end
					system.drawChoose(obl,currPage,i)
				end
			end
		end
		if not found then
			lastchoose=choose
			choose=0
			if lastchoose ~= choose and lastchoose ~= 0 and not ignoreLastChoose then
				system.drawChoose(obl,currPage,lastchoose,_,true)
			elseif ignoreLastChoose then
				ignoreLastChoose=false
			end
		end

		if y ~= h and menu == 0 and open ~= 0 then
			--color(user.contrastColor)
			--temp=picture.screenshot(current.x[open]+1,current.y[open],8,4)
			--fill(1,1,w,h-1," ")
			--picture.draw(w/2-4,h/2-2,temp)
			color(maincolor)
			fcolor(mainfcolor)
			local isCorrupted=fs.exists(current.tmppaths[choose] or "/ /")
			if current.tmppaths[choose]=="" then isCorrupted=true end
			if (current.tmpexts[open] or current.exts[open]) == ".app" then
				if fs.exists(current.tmppaths[open].."main.lua" or current.paths[open].."main.lua") then
					local result,reason=loadfile(current.tmppaths[open].."main.lua" or current.paths[open].."main.lua")
					if result then
						result,reason=xpcall(result,debug.traceback,...)
					    if not result then
					    	if type(reason) ~= "table" then
					    		system.bsod(current.tmpfullNames[open] or current.fullNames[open],reason)
					    	end
					    end
					else
						if type(reason) ~= "table" then
					    	system.bsod(current.tmpfullNames[open] or current.fullNames[open],reason)
						end
					end
					system.drawChooseReset()
					fosLoad()
					draw()
				else
					tools.error({"The main script of the \""..current.tmpfullNames[open] or current.fullNames[open].."\" application does not exist!"},2)
				end
			elseif fs.isDirectory(current.tmppaths[open] or current.paths[open]) then
				enterDir()
			else
				local result,reason=loadfile(current.tmppaths[open] or current.paths[open])
				if result then
					result,reason=xpcall(result,debug.traceback,...)
				    if not result then
				    	if type(reason) ~= "table" then
				    		system.bsod(current.tmpfullNames[open] or current.fullNames[open],reason)
				    	end
				    end
				else
					if type(reason) ~= "table" then
				    	system.bsod(current.tmpfullNames[open] or current.fullNames[open],reason)
					end
				end
				system.drawChooseReset()
				fosLoad()
				draw()
			end
		elseif y ~= h and sleep ~= 1 and click == 1 and skipCon == 1 then
			ignoreLastChoose=false
			if lastchoose ~= choose and lastchoose ~= 0 then
				system.drawChoose(obl,currPage,lastchoose,_,true)
			end
			if current.exts[choose] == ".lnk" then
				if current.tmpexts[choose] == ".app" then --Link to App
					local isCorrupted=false
					isCorrupted=not fs.exists(current.tmppaths[choose] or "/ /")
					if current.tmppaths[choose]=="" then isCorrupted=true end
					local isMainCorrupted=false
					isMainCorrupted=not fs.exists(current.tmppaths[choose].."main.lua" or "/ /")

					if isCorrupted then
						pos=tools.conMenu(x,y,{"<gray>"..slang.conEditApp,"<gray>"..slang.conEnterApp,slang.conEditLnk,"|","<gray>"..slang.conCopy,"<gray>"..slang.conPaste,"<gray>"..slang.conCut,"|",slang.conCreate,slang.conCreateDir,"<gray>"..slang.conCreateLnk,"|",slang.conDelete,"<gray>"..slang.conDeleteLnk,slang.conRename,"|","<gray>"..slang.conProp})
					elseif isMainCorrupted then
						pos=tools.conMenu(x,y,{"<gray>"..slang.conEditApp,slang.conEnterApp,slang.conEditLnk,"|","<gray>"..slang.conCopy,"<gray>"..slang.conPaste,"<gray>"..slang.conCut,"|",slang.conCreate,slang.conCreateDir,"<gray>"..slang.conCreateLnk,"|",slang.conDelete,"<gray>"..slang.conDeleteLnk,slang.conRename,"|","<gray>"..slang.conProp})
					else
						pos=tools.conMenu(x,y,{slang.conEditApp,slang.conEnterApp,slang.conEditLnk,"|","<gray>"..slang.conCopy,"<gray>"..slang.conPaste,"<gray>"..slang.conCut,"|",slang.conCreate,slang.conCreateDir,"<gray>"..slang.conCreateLnk,"|",slang.conDelete,"<gray>"..slang.conDeleteLnk,slang.conRename,"|","<gray>"..slang.conProp})
					end
					if pos == 1 then
						if isMainCorrupted then
							if current.tmppaths[choose].."main.lua" ~= nil then
								temp="\""..current.tmppaths[choose].."main.lua".."\""
							else
								temp="Null"
							end
							tools.error({slang.corruptedLnk:format(temp)},2)
						else
							editItem(current.tmppaths[choose].."main.lua")
						end
					elseif pos == 2 then
						if isCorrupted then
							if current.tmppaths[choose] ~= nil then
								temp="\""..current.tmppaths[choose].."\""
							else
								temp="Null"
							end
							tools.error({slang.corruptedLnk:format(temp)},2)
						else
							enterDir(current.tmppaths[choose])
						end
					elseif pos == 3 then
						editItem() --editLnk
					elseif pos == 9 then
						createItem()
					elseif pos == 10 then
						createFolder()
					elseif pos == 11 then
						--createLnk
					elseif pos == 13 then
						deleteItem(_,true)
					elseif pos == 14 then
						deleteItem(true)
					elseif pos == 15 then
						renameItem()
					elseif pos == 17 then
						--properties
					end
				elseif current.tmpexts[choose] == "$dir" then --Link to Folder
					pos=tools.conMenu(x,y,{slang.conEditLnk,"|","<gray>"..slang.conCopy,"<gray>"..slang.conPaste,"<gray>"..slang.conCut,"|",slang.conCreate,slang.conCreateDir,"<gray>"..slang.conCreateLnk,"|",slang.conDelete,"<gray>"..slang.conDeleteLnk,slang.conRename,"|","<gray>"..slang.conProp})
					if pos == 1 then
						editItem() --editLnk
					elseif pos == 7 then
						createItem()
					elseif pos == 8 then
						createFolder()
					elseif pos == 9 then
						--createLnk
					elseif pos == 11 then
						deleteItem(_,true)
					elseif pos == 12 then
						deleteItem(true)
					elseif pos == 13 then
						renameItem()
					elseif pos == 15 then
						--properties
					end
				else --Link to File
					local isCorrupted=not fs.exists(current.tmppaths[choose] or "/ /")
					if current.tmppaths[choose]=="" then isCorrupted=true end
					if isCorrupted then
						pos=tools.conMenu(x,y,{"<gray>"..slang.conEditFile,slang.conEditLnk,"|","<gray>"..slang.conCopy,"<gray>"..slang.conPaste,"<gray>"..slang.conCut,"|",slang.conCreate,slang.conCreateDir,"<gray>"..slang.conCreateLnk,"|",slang.conDelete,"<gray>"..slang.conDeleteLnk,slang.conRename,"|","<gray>"..slang.conProp})
					else
						pos=tools.conMenu(x,y,{slang.conEditFile,slang.conEditLnk,"|","<gray>"..slang.conCopy,"<gray>"..slang.conPaste,"<gray>"..slang.conCut,"|",slang.conCreate,slang.conCreateDir,"<gray>"..slang.conCreateLnk,"|",slang.conDelete,"<gray>"..slang.conDeleteLnk,slang.conRename,"|","<gray>"..slang.conProp})
					end
					if pos == 1 then
						if isCorrupted then
							if current.tmppaths[choose] ~= nil then
								temp="\""..current.tmppaths[choose].."\""
							else
								temp="Null"
							end
							tools.error({slang.corruptedLnk:format(temp)},2)
						else
							editItem(current.tmppaths[choose])
						end
					elseif pos == 2 then
						editItem() --editLnk
					elseif pos == 8 then
						createItem()
					elseif pos == 9 then
						createFolder()
					elseif pos == 10 then
						--createLnk
					elseif pos == 12 then
						deleteItem(_,true)
					elseif pos == 13 then
						deleteItem(true)
					elseif pos == 14 then
						renameItem()
					elseif pos == 16 then
						--properties
					end
				end
			elseif current.exts[choose] == ".app" then --App
				pos=tools.conMenu(x,y,{slang.conEditApp,slang.conEnterApp,"|","<gray>"..slang.conCopy,"<gray>"..slang.conPaste,"<gray>"..slang.conCut,"|",slang.conCreate,slang.conCreateDir,"<gray>"..slang.conCreateLnk,"|",slang.conDelete,slang.conRename,"|","<gray>"..slang.conProp})
				if pos == 1 then
					editItem(current.paths[choose].."main.lua")
				elseif pos == 2 then
					enterDir(current.paths[choose])
				elseif pos == 8 then
					createItem()
				elseif pos == 9 then
					createFolder()
				elseif pos == 10 then
					--createLnk
				elseif pos == 12 then
					deleteItem()
				elseif pos == 13 then
					renameItem()
				elseif pos == 15 then
					--properties
				end
			elseif current.exts[choose] == "$dir" then --Folder
				pos=tools.conMenu(x,y,{"<gray>"..slang.conCopy,"<gray>"..slang.conPaste,"<gray>"..slang.conCut,"|",slang.conCreate,slang.conCreateDir,"<gray>"..slang.conCreateLnk,"|",slang.conDelete,slang.conRename,"|","<gray>"..slang.conProp})
				if pos == 5 then
					createItem()
				elseif pos == 6 then
					createFolder()
				elseif pos == 7 then
					--createLnk
				elseif pos == 9 then
					deleteItem()
				elseif pos == 10 then
					renameItem()
				elseif pos == 12 then
					--properties
				end
			else --File
				pos=tools.conMenu(x,y,{slang.conEdit,"|","<gray>"..slang.conCopy,"<gray>"..slang.conPaste,"<gray>"..slang.conCut,"|",slang.conCreate,slang.conCreateDir,"<gray>"..slang.conCreateLnk,"|",slang.conDelete,slang.conRename,"|","<gray>"..slang.conProp})
				if pos == 1 then
					editItem()
				elseif pos == 7 then
					createItem()
				elseif pos == 8 then
					createFolder()
				elseif pos == 9 then
					--createLnk
				elseif pos == 11 then
					deleteItem()
				elseif pos == 12 then
					renameItem()
				elseif pos == 14 then
					--properties
				end
			end
		end
	end
	if y ~= h and sleep ~= 1 and click == 1 and skipCon == 0 then
		choose=0
		ignoreLastChoose=false
		if lastchoose ~= choose and lastchoose ~= 0 then
			system.drawChoose(obl,currPage,lastchoose,_,true)
		end
		pos=tools.conMenu(x,y,{"<gray>"..slang.conPaste,"|",slang.conCreate,slang.conCreateDir,"|",slang.conRefresh})
		if pos == 6 then
			system.drawChooseReset()
			fosLoad()
			ignoreLastChoose=true
			draw()
		elseif pos == 3 then
			temp=system.newFile()
			if temp ~= nil then
				file=io.open(path..temp,"w")
				file:close()
				fosLoad()
			end
			draw()
		elseif pos == 4 then
			temp=system.newFolder()
			if temp ~= nil then
				fs.makeDirectory(path..temp)
				fosLoad()
			end
			draw()
		end
	elseif x >= 1 and x <= 3 and y == h and sleep ~= 1 and click == 0 and menu == 0 then
		smax,data=system.drawMenu(user)
		color(thirdcolor)
		fcolor(0x0094ff)
		set(1,h," ⡯ ")
		menu=1
		delay=1
	elseif x == 1 and y == h and sleep ~= 1 and click == 1 and menu == 0 then
		pos=tools.conMenu(1,h-1,{lang.about})
		if pos == 1 then
			tools.error({"Coming soon."})
		end
	end

	if x >= 1 and x <= smax and y >= h-13 and y <= h-10 and menu == 1 and sleep ~= 1 and click == 0 then
		pos=tools.conMenu(x,y,{lang.logoff})
		if pos == 1 then
			temp={}
			for var in fs.list("/fos/Users") do
				table.insert(temp,var)
			end
			if #temp > 1 or user.passwordProtection then
				if fs.exists("/tmp/timerid") then
					file=io.open("/tmp/timerid","r")
					event.cancel(tonumber(file:read("*all")))
					file:close()
					fs.remove("/tmp/timerid")
				end
				menu=0
				w,h,user,lang,slang,nlang=system.init(true)
				system.login()
				fosLoad()
				draw()
			end
		end
	elseif x >= 1 and x <= smax and y == h-8 and menu == 1 and sleep ~= 1 and click == 0 then
		if fs.exists("/tmp/timerid") then
			file=io.open("/tmp/timerid","r")
			event.cancel(tonumber(file:read("*all")))
			file:close()
			fs.remove("/tmp/timerid")
		end
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
		data=nil
		color(maincolor)
		fcolor(0x0094ff)
		set(1,h," ⡯ ")
		menu=0
	else
		delay=0
	end
end
end