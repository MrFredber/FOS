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
local ignoreLastChoose,pos,mainfcolor,secondfcolor,maincolor,secondcolor,slen,SkipCon,file,click,data,obl=false
local skipCon,open,choose,lastchoose=0,0,0,0
local w,h=gpu.getResolution()
local path="/"
local args={...}
local tabs={slen={},see={},full={},offset=0,last=0}

local function expLoad()
lang={}
slang={}
nlang={}
user=system.getUserSettings()
file=io.open("/fos/lang/fos/"..user.lang,"r")
for var in file:lines() do
	table.insert(lang,var)
end
file:close()
lang=finder.unserialize(lang)
file=io.open("/fos/lang/shared/"..user.lang,"r")
for var in file:lines() do
	table.insert(slang,var)
end
file:close()
slang=finder.unserialize(slang)
file=io.open("/fos/lang/names/"..user.lang,"r")
data={}
for var in file:lines() do
	table.insert(data,var)
end
file:close()
nlang=finder.unserialize(data)
for k in pairs(nlang) do
	nlang[k:gsub("#user#",user.path)]=nlang[k]
end
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
tabs={full={[1]=nlang["/"]},slen={[1]=len(nlang["/"])},see={[1]=nlang["/"]},offset=0,last=1}
--if (green < 160) textColor = 'FFFFFF';
--else textColor = '000000';
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
data=finder.files(path)
temp=2
while true do
	if temp+9 >= w then
		temp=temp-2
		break
	else
		temp=temp+11
	end
end
offset=math.floor((w-1-temp)/2)
color(maincolor)
fcolor(mainfcolor)
fill(1,1,w,h-1," ")
obl=system.objects(2+offset,3,path,data)
color(secondcolor)
fcolor(mainfcolor)
fill(1,1,w,1," ")
fill(1,h-1,w,1," ")
set(2,1,"≡  ◂")
set(w-1,1,"x")
set(2,h-1,slang.items..": "..#obl.names)
--fill(8,1,w-11,1," ")
tab(tabs)
system.taskbarDraw()
end

expLoad()
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
draw()

while true do
local _,_,x,y,click=event.pull("touch")
skipCon=0
open=0
lastchoose=choose
found=false
for i=1,#obl.x do
	if x >= obl.x[i] and x <= obl.x[i]+9 and y >= obl.y[i] and y <= obl.y[i]+5 then
		found=true
		skipCon=1
		if choose == i and click == 0 then
			choose=0
			lastchoose=0
			open=i
		else
			choose=i
			if lastchoose ~= choose and lastchoose ~= 0 and not ignoreLastChoose then
				system.drawChoose(obl,lastchoose,true)
			elseif ignoreLastChoose then
				ignoreLastChoose=false
			end
			system.drawChoose(obl,i)
		end
	end
end
if not found then
	lastchoose=choose
	choose=0
	if lastchoose ~= choose and lastchoose ~= 0 and not ignoreLastChoose then
		system.drawChoose(obl,lastchoose,true)
	elseif ignoreLastChoose then
		ignoreLastChoose=false
	end
end

if y ~= h and open ~= 0 then
	if (obl.tmpexts[open] or obl.exts[open]) == ".app" then
		if fs.exists(obl.paths[open].."main.lua") then
			local result,reason=loadfile(obl.paths[open].."main.lua")
			if result then
				result,reason=xpcall(result,debug.traceback,...)
			    if not result then
			    	if type(reason) ~= "table" then
			    		system.bsod(obl.fullNames[open],reason)
			    	end
			    end
			else
				if type(reason) ~= "table" then
			    	system.bsod(obl.fullNames[open],reason)
				end
			end
			draw(path)
		else
			tools.error({"The main script of the \""..obl.names[open].."\" application does not exist!"},2)
		end
	elseif fs.isDirectory(obl.paths[open]) then
		path=obl.paths[open]
		table.insert(tabs.full,obl.fullNames[open])
		table.insert(tabs.slen,len(obl.fullNames[open]))
		draw()
	else
		local result,reason=loadfile(obl.paths[open])
		if result then
			result,reason=xpcall(result,debug.traceback,...)
		    if not result then
		    	if type(reason) ~= "table" then
		    		system.bsod(obl.fullNames[open],reason)
		    	end
		    end
		else
			if type(reason) ~= "table" then
		    	system.bsod(obl.fullNames[open],reason)
			end
		end
		draw(path)
	end
elseif y ~= h and click == 1 and skipCon == 1 then
	pos=tools.conMenu(x,y,{slang.conEdit,"|","<gray>"..slang.conCopy,"<gray>"..slang.conPaste,"<gray>"..slang.conCut,"|",slang.conCreate,slang.conCreateDir,slang.conDelete,slang.conRename,"|","<gray>"..slang.conProp})
	if pos == 1 then
		os.execute("edit '"..obl.paths[choose].."'")
		draw()
	elseif pos == 10 then
		temp=system.rename(obl.fullNames[choose])
		if temp ~= nil then
			fs.rename(obl.paths[choose],path..temp)
		end
		system.drawChooseReset()
		ignoreLastChoose=true
		choose=0
		draw()
	elseif pos == 7 then
		temp=system.newFile()
		if temp ~= nil then
			file=io.open(path..temp,"w")
			file:close()
		end
		system.drawChooseReset()
		ignoreLastChoose=true
		choose=0
		draw()
	elseif pos == 8 then
		temp=system.newFolder()
		if temp ~= nil then
			fs.makeDirectory(path..temp)
		end
		system.drawChooseReset()
		ignoreLastChoose=true
		choose=0
		draw()
	elseif pos == 9 then
		temp=system.deleteConfirm(obl,choose)
		if temp then
			fs.remove(path..obl.fullNames[choose])
		end
		system.drawChooseReset()
		ignoreLastChoose=true
		choose=0
		draw()
	end
elseif y ~= h and sleep ~= 1 and click == 1 and skipCon == 0 then
	pos=tools.conMenu(x,y,{"<gray>"..slang.conPaste,"|",slang.conCreate,slang.conCreateDir,"|",slang.conRefresh})
	if pos == 6 then
		system.drawChooseReset()
		ignoreLastChoose=true
		draw()
	elseif pos == 3 then
		temp=system.newFile()
		if temp ~= nil then
			file=io.open(path..temp,"w")
			file:close()
		end
		draw()
	elseif pos == 4 then
		temp=system.newFolder()
		if temp ~= nil then
			fs.makeDirectory(path..temp)
		end
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
		path=unicode.sub(path,1,-(temp+2))
	else
		path="/"
	end
	if lastpath ~= path then
		draw()
	end
elseif x >= w-2 and x <= w and y == 1 then
	os.exit()
elseif x >= 7 and x <= w-3 and y == 1 then

end
end