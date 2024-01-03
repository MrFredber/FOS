local r=require
local gpu=r("component").gpu
local tools=r("fos/tools")
local finder=r("fos/finder")
local system=r("fos/system")
local picture=r("fos/picture")
local event=r("event")
local unicode=r("unicode")
local fs=r("filesystem")
local len=unicode.len
local fill=gpu.fill
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set
local sub=unicode.sub
local cords,lang,slang,nlang,user={},{},{},{},{}
local ignoreLastChoose,currpage,current,pos,mainfcolor,secondfcolor,maincolor,secondcolor,slen,SkipCon,file,click,data,obl,temp=false,1
local skipCon,open,choose,lastchoose=0,0,0,0
local w,h=gpu.getResolution()
local path="/"
local args={...}
local tabs={slen={},see={},full={},offset=0,last=0}

local function confLoad()
user,lang,slang,nlang={},{},{},{}
w,h,user,lang,slang,nlang=system.init()
for k in pairs(nlang) do
	nlang[k:gsub("#user#",user.path)]=nlang[k]
end
if user.powerSafe then
	maincolor=0
	secondcolor=0x2b2b2b
	thirdcolor=0x424242
	mainfcolor=0xffffff
	secondfcolor=0xd5d5d5
elseif user.darkMode then
	maincolor=0x202020
	secondcolor=0x2b2b2b
	thirdcolor=0x424242
	mainfcolor=0xffffff
	secondfcolor=0xaaaaaa
else
	maincolor=0xdddddd
	secondcolor=0xeeeeee
	thirdcolor=0xffffff
	mainfcolor=0
	secondfcolor=0x808080
end
tools.update(user)
--if (green < 160) textColor = 'FFFFFF'
--else textColor = '000000'
end

local function dirLoad()
currPage=1
files=finder.files(path)
obl=system.createPages(3,3,w-2,h-3,path,files,user.useXOffset,user.useYOffset)
current=obl.pages[currPage]
end

local function tab(tabs)
tmp={}
temp1=-3
temp2=0--на сколько смещать
if #tabs.full ~= tabs.last then
	tabs.see={}
	for i=1,#tabs.full do
		if temp1+tabs.slen[i]+3 >= w-11 then
			table.insert(tmp,tabs.full[i])
			temp2=temp2+1
			temp1=temp1+tabs.slen[i]
			temp1=temp1-tabs.slen[temp2]
		else
			table.insert(tmp,tabs.full[i])
			temp1=temp1+tabs.slen[i]+3
		end
	end
end
while temp1 > w-11 do
	temp2=temp2+1
	temp1=temp1-tabs.slen[temp2]-3
end
for i=1,#tabs.full-temp2 do
	table.insert(tabs.see,tmp[i+temp2])
end
if #tabs.full == temp2 then
	table.insert(tabs.see,sub(tabs.full[temp2],1,w-16).."…")
end
--set(1,2,temp1.." "..(w-11).." "..temp2)
--temp=""
--for i=1,#tabs.slen do
--	temp=temp..tostring(tabs.slen[i]).." "
--end
--set(1,3,temp)
temp=0
for i=1,#tabs.see do
	if #tabs.see < 2 and #tabs.full > 1 then
		fcolor(mainfcolor)
		set(8,1,"…")
		fcolor(secondfcolor)
		set(10,1,"▸")
		fcolor(mainfcolor)
		set(12,1,tabs.see[1])
		break
	end
	fcolor(mainfcolor)
	set(8+temp,1,tabs.see[i])
	temp=temp+len(tabs.see[i])
	if i ~= #tabs.see then
		fcolor(secondfcolor)
		set(8+temp+1,1,"▸")
		temp=temp+3
	end
end
tabs.last=#tabs.full
end

local function draw()
color(secondcolor)
fcolor(mainfcolor)
fill(1,1,w,1," ")
fill(1,h-1,w,1," ")
set(2,1,"≡  ◂")
set(w-1,1,"x")
set(2,h-1,slang.items..": "..obl.totalfiles)
tab(tabs)
system.taskbarDraw()
color(maincolor)
fcolor(mainfcolor)
fill(1,2,w,h-3," ")
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
system.drawPage(user,obl,currPage,maincolor,mainfcolor)
end

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
confLoad()
dirLoad()
draw()
end

local function enterDir(b)
tabs={full={[1]=nlang["/"]},slen={[1]=len(nlang["/"])},see={[1]=nlang["/"]},offset=0,last=1}
path=b
temp=fs.segments(path)
tmp="/"
for i=1,#temp do
	tmp=tmp..temp[i].."/"
	table.insert(tabs.full,nlang[tmp:lower()] or temp[i])
	table.insert(tabs.slen,len(nlang[tmp:lower()] or temp[i]))
end
open,lastopen,choose,lastchoose=0,0,0,0
system.drawChooseReset()
dirLoad()
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
	dirLoad()
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
	dirLoad()
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
	dirLoad()
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
	dirLoad()
end
system.drawChooseReset({path..current.fullNames[choose]})
ignoreLastChoose=true
choose=0
draw()
end

confLoad()
tabs={full={[1]=nlang["/"]},slen={[1]=len(nlang["/"])},see={[1]=nlang["/"]},offset=0,last=1}
if type(args[1]) == "string" then
path=args[1]
temp=fs.segments(path)
tmp="/"
for i=1,#temp do
	tmp=tmp..temp[i].."/"
	table.insert(tabs.full,nlang[tmp] or temp[i])
	table.insert(tabs.slen,len(nlang[tmp] or temp[i]))
end
end
dirLoad()
draw()

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
						system.drawChoose(obl,currPage,lastchoose,maincolor,true)
					elseif ignoreLastChoose then
						ignoreLastChoose=false
					end
					system.drawChoose(obl,currPage,i,maincolor)
				end
			end
		end
		if not found then
			lastchoose=choose
			choose=0
			if lastchoose ~= choose and lastchoose ~= 0 and not ignoreLastChoose then
				system.drawChoose(obl,currPage,lastchoose,maincolor,true)
			elseif ignoreLastChoose then
				ignoreLastChoose=false
			end
		end

		if y ~= h and open ~= 0 then
			if (current.tmpexts[open] or current.exts[open]) == ".app" then
				local isCorrupted=false
				if current.tmppaths[open] ~= nil then
					temp=current.tmppaths[open].."main.lua"
					isCorrupted=not fs.exists(current.tmppaths[open] or "/ /")
					if current.tmppaths[open]=="" then isCorrupted=true end
				else
					temp=current.paths[open].."main.lua"
					isCorrupted=not fs.exists(current.paths[open] or "/ /")
					if current.paths[open]=="" then isCorrupted=true end
				end
				if isCorrupted then
					tools.error({slang.corruptedLnk:format(current.tmppaths[open] or current.paths[open])},2)
				else
					if fs.exists(temp) then
						local result,reason=loadfile(temp)
						if result then
							result,reason=xpcall(result,debug.traceback,...)
							if not result then
								if type(reason) ~= "table" then
									system.bsod(current.fullNames[open],reason)
								end
							end
						else
							if type(reason) ~= "table" then
								system.bsod(current.fullNames[open],reason)
							end
						end
						system.drawChooseReset()
						confLoad()
						dirLoad()
						draw()
						system.taskbarDraw()
					else
						tools.error({"The main script of the \""..current.tmpfullNames[open].."\" application does not exist!"},2)
					end
				end
			elseif fs.isDirectory(current.tmppaths[open] or current.paths[open]) then
				if current.tmppaths[open] ~= nil then
					enterDir(current.tmppaths[open])
				else
					path=current.paths[open]
					table.insert(tabs.full,nlang[unicode.lower(current.paths[open])] or current.fullNames[open])
					table.insert(tabs.slen,len(nlang[unicode.lower(current.paths[open])] or current.fullNames[open]))
					system.drawChooseReset()
					dirLoad()
					draw()
				end
			else
				local result,reason=loadfile(current.tmppaths[open] or current.paths[open])
				if result then
					result,reason=xpcall(result,debug.traceback,...)
					if not result then
						if type(reason) ~= "table" then
							system.bsod(current.fullNames[open],reason)
						end
					end
				else
					if type(reason) ~= "table" then
						system.bsod(current.fullNames[open],reason)
					end
				end
				system.drawChooseReset()
				confLoad()
				draw(path)
				system.taskbarDraw()
			end
		elseif y ~= h and click == 1 and skipCon == 1 then
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


			--pos=tools.conMenu(x,y,{slang.conEdit,"|","<gray>"..slang.conCopy,"<gray>"..slang.conPaste,"<gray>"..slang.conCut,"|",slang.conCreate,slang.conCreateDir,slang.conDelete,slang.--conRename,"|","<gray>"..slang.conProp})
			--if pos == 1 then
			--	if fs.exists("/tmp/timerid") then
			--		file=io.open("/tmp/timerid","r")
			--		event.cancel(tonumber(file:read("*all")))
			--		file:close()
			--		fs.remove("/tmp/timerid")
			--	end
			--	os.execute("edit '"..current.paths[choose].."'")
			--	confLoad()
			--	dirLoad()
			--	draw()
			--elseif pos == 10 then
			--	temp=system.rename(current.fullNames[choose])
			--	if temp ~= nil then
			--		fs.rename(current.paths[choose],path..temp)
			--		dirLoad()
			--	end
			--	system.drawChooseReset()
			--	ignoreLastChoose=true
			--	choose=0
			--	draw()
			--elseif pos == 7 then
			--	temp=system.newFile()
			--	if temp ~= nil then
			--		file=io.open(path..temp,"w")
			--		file:close()
			--		dirLoad()
			--	end
			--	system.drawChooseReset()
			--	ignoreLastChoose=true
			--	choose=0
			--	draw()
			--elseif pos == 8 then
			--	temp=system.newFolder()
			--	if temp ~= nil then
			--		fs.makeDirectory(path..temp)
			--		dirLoad()
			--	end
			--	system.drawChooseReset()
			--	ignoreLastChoose=true
			--	choose=0
			--	draw()
			--elseif pos == 9 then
			--	temp=system.deleteConfirm(obl,currPage,choose)
			--	if temp then
			--		fs.remove(path..current.fullNames[choose])
			--		dirLoad()
			--	end
			--	system.drawChooseReset()
			--	ignoreLastChoose=true
			--	choose=0
			--	draw()
			--end
		end
	end
	if y ~= h and sleep ~= 1 and click == 1 and skipCon == 0 then
		pos=tools.conMenu(x,y,{"<gray>"..slang.conPaste,"|",slang.conCreate,slang.conCreateDir,"<gray>"..slang.conCreateLnk,"|",slang.conRefresh})
		if pos == 3 then
			createItem()
		elseif pos == 4 then
			createFolder()
		elseif pos == 6 then
			system.drawChooseReset()
			ignoreLastChoose=true
			confLoad()
			dirLoad()
			draw()
		end
	elseif x >= 4 and x <= 6 and y == 1 then
		if #tabs.full > 1 then
			table.remove(tabs.full)
			table.remove(tabs.slen)
		end
		lastpath=path
		temp=fs.segments(path)
		if #temp > 1 then
			temp=len(temp[#temp])
			path=sub(path,1,-(temp+2))
		else
			path="/"
		end
		if lastpath ~= path then
			dirLoad()
			draw()
		end
	elseif x >= w-2 and x <= w and y == 1 then
		os.exit()
	elseif x >= 7 and x <= w-3 and y == 1 then

	end
end
end