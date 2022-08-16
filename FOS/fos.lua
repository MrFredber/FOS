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
	color(0x2b2b2b)
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
			color(user.contrastColor)
			temp=picture.screenshot(current.x[open]+1,current.y[open],8,4)
			fill(1,1,w,h-1," ")
			picture.draw(w/2-4,h/2-2,temp)
			if (current.tmpexts[open] or current.exts[open]) == ".app" then
				if fs.exists(current.paths[open].."main.lua") then
					local result,reason=loadfile(current.paths[open].."main.lua")
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
					fosLoad()
					draw()
				else
					tools.error({"The main script of the \""..current.fullNames[open].."\" application does not exist!"},2)
				end
			elseif fs.isDirectory(current.paths[open]) then
				local result,reason=loadfile("/fos/apps/Explorer.app/main.lua")
					if result then
						result,reason=xpcall(result,debug.traceback,current.paths[open])
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
					fosLoad()
					draw()
			else
				local result,reason=loadfile(current.paths[open])
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
				fosLoad()
				draw()
			end
		elseif y ~= h and sleep ~= 1 and click == 1 and skipCon == 1 then
			ignoreLastChoose=false
			if lastchoose ~= choose and lastchoose ~= 0 then
				system.drawChoose(obl,currPage,lastchoose,_,true)
			end
			pos=tools.conMenu(x,y,{slang.conEdit,"|","<gray>"..slang.conCopy,"<gray>"..slang.conPaste,"<gray>"..slang.conCut,"|",slang.conCreate,slang.conCreateDir,slang.conDelete,slang.conRename,"|","<gray>"..slang.conProp})
			if pos == 1 then
				if fs.exists("/tmp/timerid") then
					file=io.open("/tmp/timerid","r")
					event.cancel(tonumber(file:read("*all")))
					file:close()
					fs.remove("/tmp/timerid")
				end
				os.execute("edit '"..current.paths[choose].."'")
				fosLoad()
				draw()
			elseif pos == 10 then
				temp=system.rename(current.fullNames[choose])
				if temp ~= nil then
					fs.rename(current.paths[choose],path..temp)
					fosLoad()
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
					fosLoad()
				end
				system.drawChooseReset()
				ignoreLastChoose=true
				choose=0
				draw()
			elseif pos == 9 then
				temp=system.deleteConfirm(obl,currPage,choose)
				if temp then
					fs.remove(path..current.fullNames[choose])
					fosLoad()
				end
				system.drawChooseReset()
				ignoreLastChoose=true
				choose=0
				draw()
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