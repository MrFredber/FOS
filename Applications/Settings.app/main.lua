local r=require
local io=r("io")
local gpu=r("component").gpu
local unicode=r("unicode")
local event=r("event")
local comp=r("computer")
local tools=r("/fos/tools")
local picture=r("/fos/picture")
local w,h=gpu.getResolution();
local fill=gpu.fill
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set
local len=unicode.len
local reg={}
local lang={}
local appname={}
local tbl,data1,max,no,file,open
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
file=io.open("/fos/apps/Settings.app/appname/"..reg.lang,"r")
for var in file:lines() do table.insert(appname,var) end
file:close()
color(0xffffff)
fcolor(0)
fill(1,1,w,1," ")
set(1,1,appname[1])
color(0xb40000)
fcolor(0xffffff)
set(w-2,1," X ")
local userColor=tonumber(reg.userColor) or tonumber("0x"..reg.userColor) or math.random(16777215)
i=1
file=io.open("/fos/apps/settings.app/lang/"..reg.lang,"r")
for var in file:lines() do
--if var:find("{") ~= nil then (Attempt to fix the bug)
--	tblarg=unicode.sub(var,1,-2)
--	tbl=1
--end
--if tbl == 1 then
--	if var:find("}") ~= nil then
--		print("antitick")
--		tbl=0
--	else
--		lang[tblarg][i]=var
--		print("tick")
--		i=i+1
--	end
--end
if var:find("=") ~= nil then
	check=var:find("=")
	arg=unicode.sub(var,1,check-1)
	var=unicode.sub(var,check+1)
	lang[arg]=var
else
	table.insert(lang,var)
end
end
file:close()
--print(tools.tblprint(reg))
--event.pull("touch")

function iconLang(x,y)
fcolor(0x0000ff)
set(x+6,y,"⣶⡄")
set(x,y+3,"⠘⠿    ⠿⠃")
fcolor(0x00ff00)
set(x,y,"⢠⣶")
color(0x0000ff)
set(x+2,y,"⣿⣿⡟⣿")
set(x,y+1,"⣿⣿⣿⠟⠋ ⡀ ")
set(x,y+2," ⠉⠿⣆⣠⠈  ")
set(x+2,y+3," ⠛⠁ ")
end

function iconUser(x,y)
fclr=gpu.getForeground()
fcolor(userColor)
set(x+1,y,"⢠⡶⢿⡿⢶⡄")
set(x+1,y+1,"⣿⣇⣸⣇⣸⣿")
set(x+1,y+2,"⠘⠿⣮⣵⠿⠃")
set(x+1,y+3,"⣀⣤⣿⣿⣤⣀")
fcolor(fclr)
end

function iconComp(x,y)
color(0x0094ff)
fcolor(0)
set(x,y,"⡏⠉⠉⠉⠉⠉⠉⢹")
set(x,y+1,"⡇      ⢸")
set(x,y+2,"⣇⣀⣀⣀⣀⣀⣀⣸")
fcolor(0xffffff)
set(x+3,y+1,"⢸⠅")
fcolor(0)
color(0xffffff)
set(x+3,y+3,"⣸⣇")
end

function iconAuto(x,y)
color(0xffffff)
fcolor(0)
set(x,y,"⡏⠍⠭⠭⠭⠭⠭⢹")
set(x,y+1,"⡇⠅⠭⠭⠭⠭⠭⢸")
set(x,y+2,"⡇⠅⠭⠭⠭⠭⠭⢸")
set(x,y+3,"⣇⣁⣭⣭⣭⣭⣉⣸")
end

function MainMenu()
local cords={x={},y={}}
if reg.powerSafe == "1" then
	color(0)
else
	color(0xe0e0e0)
end
fill(1,2,w,h-2," ")
color(0xffffff)
fcolor(0)
i=1
li=1 --lang i
ci=1 --cords i
ww=3 --window
hw=3
wi=4 --icon
hi=4
wn=13 --name
while i-1 ~= 4 do
	table.insert(cords.x,ci,ww)
	table.insert(cords.y,ci,hw)
	fill(ww,hw,23,6," ")
	if i == 3 then
		iconLang(wi,hi)
	elseif i == 2 then
		iconUser(wi,hi)
	elseif i == 1 then
		iconComp(wi,hi)
	elseif i == 4 then
		iconAuto(wi,hi)
	else
		fill(wi,hi,8,4,"?")
	end
	color(0xffffff)
	fcolor(0)
	set(wn,hi,lang[li])
	fcolor(0x727272)
	set(wn,hi+1,lang[li+1])
	set(wn,hi+2,lang[li+2])
	set(wn,hi+3,lang[li+3])	
	fcolor(0)
	wi=wi+26
	ww=ww+26
	wn=wn+26
	table.insert(cords.x,ci+1,ww-4)
	table.insert(cords.y,ci+1,hw+6)
	li=li+4
	ci=ci+2
	if ww+23 >= w then
		ww=3
		wi=4
		wn=13
		hw=hw+8
		hi=hi+8
	end
	i=i+1
end
while open == nil do
	i=1
	c=1
	_,_,x,y=event.pull("touch")
	while c-1 ~= #cords.x do
		if x >= cords.x[c] and x <= cords.x[c+1] and y >= cords.y[c] and y <= cords.y[c+1] then
			open=i
		end
		c=c+2
		i=i+1
	end
	if x >= w-2 and x <= w and y == 1 then
		lang=nil
		os.exit()
	end
end
return open
end

function userInput(txt)
slen=len(txt)
x=w/2-slen/2
color(0)
fill(x+1,h/2-1,slen+4,4," ")
color(0xe0e0e0)
fill(x,h/2-2,slen+4,4," ")
color(0xb40000)
fcolor(0xffffff)
set(x+slen+1,h/2-2," X ")
fcolor(0)
color(0xffffff)
set(x,h/2-2,txt.." ")
fill(x+1,h/2,slen+2,1," ")
exit=0
while exit ~= 1 do
	no=false
	local _,_,tx,ty=event.pull("touch")
	if tx >= x+1 and tx <= x+slen+2 and ty == math.floor(h/2) then
		exit=1
	elseif tx >= x+slen+1 and tx <= x+slen+3 and ty == math.floor(h/2-2) then
		no="yes"
		exit=1
	end
end
return no
end

function apply()
file=io.open("/fos/system/registry","w")
for k in pairs(reg) do
	file:write(k.."="..reg[k].."\n")
end
file:close()
end

function autoDraw()
if reg.powerSafe == "1" then
	color(0)
else
	color(0xffffff)
end
fcolor(0)
fill(5,5,w-8,h-5," ")
color(0xe0e0e0)
max=0
i=1
while i-1 ~= #auto do
	slen=len(auto[i])
	if slen > max then
		max=slen
	end
	i=i+1
end
max=max+8+#auto
fill(w/2-max/2,h/2-#auto/2,max,#auto," ")
i=1
while i-1 ~= #auto do
	set(w/2-max/2,h/2-#auto/2+i-1,tostring(i)..". "..auto[i])
	i=i+1
end
color(0xefefef)
fill(w/2+max/2-6,h/2-#auto/2,6,#auto," ")
fill(w/2+max/2-5,h/2-#auto/2,1,#auto,"▾")
fill(w/2+max/2-2,h/2-#auto/2,1,#auto,"▴")
if reg.powerSafe == "1" then
	color(0)
else
	color(0xffffff)
end
tools.btn(w/2-2,h/2+#auto/2+1,"+")
tools.btn(w/2+2,h/2+#auto/2+1,"-")
return max
end

function autoApply()
file=io.open("/fos/system/auto.cfg","w")
i=1
while i-1 ~= #auto do
	file:write(auto[i])
	if i ~= #auto then
		file:write("\n")
	end
	i=i+1
end
file:close()
end

function autostart()
auto={}
file=io.open("/fos/system/auto.cfg","r")
for var in file:lines() do table.insert(auto,var) end
file:close()
max=autoDraw()
while true do
	_,_,x,y=event.pull("touch")
	if x >= 6 and x <= 9 and y == 4 then
		autoApply()
		break
	elseif x >= w-2 and x <= w and y == 1 then
		lang=nil
		autoApply()
		os.exit()
	elseif x >= w/2-3 and x <= w/2-1 and y == math.floor(h/2+#auto/2+1) then
		no=userInput(lang.autoAdd)
		if no ~= "yes" then
			var=tools.input()
			table.insert(auto,var)
		end
		max=autoDraw()
	elseif x >= w/2+2 and x <= w/2+5 and y == math.floor(h/2+#auto/2+1) then
		no=userInput(lang.autoSub)
		if no ~= "yes" then
			var=tools.input()
			result=pcall(autoSubTbl,var)
			if not result then
				tools.error(lang.autoSubErr,1)
			end
		end
		max=autoDraw()
	elseif x >= math.floor(w/2+max/2-6) and x <= math.floor(w/2+max/2-4) and y >= math.floor(h/2-#auto/2) and y <= math.floor(h/2+#auto/2) then
		i=0
		a=0
		while i ~= #auto do
			if y == math.floor(h/2-#auto/2+i) then
				a=i
			end
			i=i+1
		end
		autoMove(a+1,a+2)
		max=autoDraw()
	elseif x >= math.floor(w/2+max/2-3) and x <= math.floor(w/2+max/2-1) and y >= math.floor(h/2-#auto/2) and y <= math.floor(h/2+#auto/2) then
		i=0
		a=0
		while i ~= #auto do
			if y == math.floor(h/2-#auto/2+i) then
				a=i
			end
			i=i+1
		end
		autoMove(a+1,a)
		max=autoDraw()
	end
end
end

function autoSubTbl(var)
table.remove(auto,var)
table.pack(auto)
end

function autoMove(tbl1,tbl2)
if tbl1 > #auto or tbl1 < 1 or tbl2 > #auto or tbl2 < 1 then
	tools.error(lang.autoMoveErr.." ("..tbl1..";"..tbl2..")",1)
else
	temp=auto[tbl1]
	auto[tbl1]=auto[tbl2]
	auto[tbl2]=temp
	table.pack(auto)
end
end

function compDraw()
if reg.powerSafe == "1" then
	color(0)
	fill(1,2,w,h-2," ")
	fcolor(0xffffff)
else
	color(0xe0e0e0)
	fill(1,2,w,h-2," ")
	color(0xffffff)
	fcolor(0)
end
fill(5,4,w-8,h-4," ")
tools.btn(6,4,"<-")
slen=len(lang.compPowerSafe)
elen=slen+7
set(w/2-elen/2,5,lang.compPowerSafe)
tools.lvr(w/2+elen/2-6,5,reg.powerSafe)
tlen=len(lang.compResolution)
slen=len(reg.width.."x"..reg.height)
rlen=tlen+slen
set(w/2-rlen/2,8,lang.compResolution)
set(w/2+rlen/2-slen,8,reg.width.."x"..reg.height)
fcolor(0x727272)
slen=len(lang.compPowerSafeMsg)
set(w/2-slen/2,6,lang.compPowerSafeMsg)
end

function compResUpd()
color(0xe0e0e0)
fcolor(0)
fill(cw+1,ch+3,max-2,1," ")
fill(cw+1,ch+6,max-2,1," ")
set(cw+1,ch+3,reg.width)
set(cw+1,ch+6,reg.height)
end

function computer()
compDraw()
while true do
	local _,_,x,y=event.pull("touch")
	if x >= 6 and x <= 9 and y == 4 then
		apply()
		break
	elseif x >= w/2+elen/2-7 and x <= w/2+elen/2-1 and y == 5 then
		if reg.powerSafe == "1" then
			reg.powerSafe="0"
		else
			reg.powerSafe="1"
		end
		compDraw()
	elseif x >= w/2-rlen/2 and x <= w/2+rlen/2 and y == 8 then
		local data1=picture.screenshot(1,1,w,1)
		local data2=picture.screenshot(1,h,w,1)
		if reg.powerSafe == "1" then
			color(0)
		else
			color(0x2b2b2b)
		end
		fill(1,1,w,h," ")
		slen1=len(lang.cancel)
		slen2=len(lang.default)
		tlen=slen1+slen2+10
		max=tlen
		slen=len(lang.compResolutionTitle)
		if slen > max then
			max=slen+2
		end
		max=max+2
		cw=math.floor(w/2-max/2)
		ch=math.floor(h/2-4)
		color(0)
		fcolor(0)
		fill(cw+1,ch+1,max,10," ")
		color(0xffffff)
		fill(cw,ch,max,10," ")
		set(cw,ch,lang.compResolutionTitle)
		set(cw+1,ch+2,lang.width)
		set(cw+1,ch+5,lang.height)
		tools.btn(cw+2,ch+8,"OK")
		tools.btn(cw+7,ch+8,lang.cancel)
		tools.btn(cw+max-slen2-2,ch+8,lang.default)
		while true do
			compResUpd()
			_,_,x,y=event.pull("touch")
			if x >= cw+1 and x <= cw+max-2 and y == ch+3 then
				temp=tools.input()
				if tonumber(temp) ~= nil and temp ~= nil then
					reg.width=temp
				else
					tools.error(lang.compResolutionCompErr,1)
				end
			elseif x >= cw+1 and x <= cw+max-2 and y == ch+6 then
				temp=tools.input()
				if tonumber(temp) ~= nil and temp ~= nil then
					reg.height=temp
				else
					tools.error(lang.compResolutionCompErr,1)
				end
			elseif x >= cw+6 and x <= cw+slen1+7 and y == ch+8 then
				reg.width=tostring(w)
				reg.height=tostring(h)
				break
			elseif x >= cw+max-slen2-3 and x <= cw+max-2 and y == ch+8 then
				neww,newh=gpu.maxResolution()
				reg.width=tostring(neww)
				reg.height=tostring(newh)
			elseif x >= cw+1 and x <= cw+4 and y == ch+8 then
				if gpu.setResolution(tonumber(reg.width),tonumber(reg.height)) == true then
					apply()
					comp.shutdown(true)
				else
					tools.error(lang.compResolutionErr,2)
				end
			end
		end
		picture.draw(1,1,data1)
		picture.draw(1,h,data2)
		compDraw()
	elseif x >= w-2 and x <= w and y == 1 then
		apply()
		lang=nil
		os.exit()
	end
end
end

function language()
tools.tblprint(lang)
slen=len(lang.lang)
if reg.powerSafe == "1" then
	fcolor(0xffffff)
else
	fcolor(0)
end
set(w/2-slen/2+1,5,lang.lang)
tools.btn(w/2-8,7,"English")
tools.btn(w/2+2,7,"Русский")
fcolor(0x727272)
slen=len(lang.langMsg1)
set(w/2-slen/2,9,lang.langMsg1)
slen=len(lang.langMsg2)
set(w/2-slen/2,10,lang.langMsg2)
while true do
	_,_,x,y=event.pull("touch")
	if x >= w/2-9 and x <= w/2-1 and y == 7 then
		langchoise="english.lang"
	elseif x >= w/2+1 and x <= w/2+9 and y == 7 then
		langchoise="russian.lang"
	elseif x >= w-2 and x <= w and y == 1 then
		lang=nil
		os.exit()
	elseif x >= 6 and x <= 9 and y == 4 then
		break
	end
	if langchoise ~= nil then
		reg.lang=langchoise
		apply()
		os.exit()
	end
end
end

function userDraw()
userColor=tonumber(reg.userColor) or tonumber("0x"..reg.userColor) or math.random(16777215)
if reg.powerSafe == "1" then
	color(0)
	fcolor(0xffffff)
else
	color(0xffffff)
	fcolor(0)
end
fill(5,5,w-8,h-5," ")
ulen=len(reg.username)
if tonumber(reg.userColor) ~= nil then
	clen=len(lang.userColor..": "..reg.userColor)
elseif tonumber("0x"..reg.userColor) ~= nil then
	clen=len(lang.userColor..": ".."0x"..reg.userColor)
else
	clen=len(lang.userColor..": "..lang.userRandom)
end
if clen > ulen then
	uw=clen
else
	uw=ulen
end
xu=w/2-5-uw/2
iconUser(xu,5)
set(xu+9,6,reg.username)
if tonumber(reg.userColor) ~= nil or tonumber("0x"..reg.userColor) ~= nil then
	set(xu+9,7,lang.userColor..": "..reg.userColor)
else
	set(xu+9,7,lang.userColor..": "..lang.userRandom)
end
slen=len(lang.user)
tlen=slen+7
set(w/2-tlen/2,10,lang.user)
tools.lvr(w/2+tlen/2-6,10,reg.passwordProtection)
if reg.passwordProtection == "1" then
	plen=len(lang.userbtn)
	tools.btn(w/2-plen/2,12,lang.userbtn)
else
	plen=0
end
return tlen,ulen,uw,plen
end

function userApply()
if reg.passwordProtection == "1" and reg.password == nil then
	reg.passwordProtection="0"
	reg.password="0"
end
apply()
end

function userColorUpd()
color(0xe0e0e0)
fcolor(0)
fill(cw+1,ch+3,max-7,1," ")
if reg.userColor == "random" then
	set(cw+1,ch+3,lang.userRandom)
else
	set(cw+1,ch+3,reg.userColor)
end
color(userClr)
fill(cw+max-5,ch+2,4,2," ")
end

function userSett()
tlen,ulen,uw,plen=userDraw()
while true do
local _,_,x,y=event.pull("touch")
if x >= 6 and x <= 9 and y == 4 then
	userApply()
	break
elseif x >= w-2 and x <= w and y == 1 then
	userApply()
	os.exit()
elseif x >= w/2+tlen/2-7 and x <= w/2+tlen/2-1 and y == 10 then
	if reg.passwordProtection == "1" then
		reg.passwordProtection="0"
		reg.password=nil
	else
		reg.passwordProtection="1"
	end
	userDraw()
elseif x >= w/2-5-uw/2+8 and x <= w/2-5-uw/2+ulen+8 and y == 6 then
	no=userInput(lang.userNick)
	if no ~= "yes" then
		reg.username=tools.input()
	end
	tlen,ulen,uw=userDraw()
elseif x >= w/2-5-uw/2+8 and x <= w/2-5-uw/2+8+clen and y == 7 then
	oldclr=reg.userColor
	local data1=picture.screenshot(1,1,w,4)
	local data2=picture.screenshot(1,h,w,1)
	if reg.powerSafe == "1" then
		color(0)
	else
		color(0x2b2b2b)
	end
	fill(1,1,w,h," ")
	slen1=len(lang.cancel)
	slen2=len(lang.default)
	slen3=len(lang.userRandom)
	tlen=slen1+slen2+slen3+13
	max=tlen
	slen=len(lang.compResolutionTitle)
	if slen > max then
		max=slen+2
	end
	max=max+2
	cw=math.floor(w/2-max/2)
	ch=math.floor(h/2-3)
	color(0)
	fcolor(0)
	fill(cw+1,ch+1,max,7," ")
	color(0xffffff)
	fill(cw,ch,max,7," ")
	set(cw,ch,lang.userColorTitle)
	set(cw+1,ch+2,lang.userColor)
	tools.btn(cw+2,ch+5,"OK")
	tools.btn(cw+7,ch+5,lang.cancel)
	tools.btn(cw+slen1+10,ch+5,lang.default)
	tools.btn(cw+max-slen3-2,ch+5,lang.userRandom)
	while true do
		userClr=tonumber(reg.userColor) or tonumber("0x"..reg.userColor) or math.random(16777215)
		userColorUpd()
		_,_,x,y=event.pull("touch")
		if x >= cw+1 and x <= cw+max-7 and y == ch+3 then
			temp=tools.input()
			temp=tonumber(temp) or tonumber("0x"..temp)
			if tonumber(temp) ~= nil and temp ~= nil then
				reg.userColor=tostring(temp)
			else
				tools.error(lang.compResolutionCompErr,1)
			end
		elseif x >= cw+6 and x <= cw+slen1+7 and y == ch+5 then
			reg.userColor=oldclr
			break
		elseif x >= cw+slen1+9 and x <= cw+max-slen3-5 and y == ch+5 then
			reg.userColor="0x0094ff"
		elseif x >= cw+1 and x <= cw+4 and y == ch+5 then
			userApply()
			break
		elseif x >= cw+max-slen3-3 and x <= cw+max-2 and y == ch+5 then
			reg.userColor="random"
		end
	end
	picture.draw(1,1,data1)
	picture.draw(1,h,data2)
	if reg.powerSafe == "1" then
		color(0)
	else
		color(0xe0e0e0)
	end
	fill(1,5,w,h-5," ")
	tlen,ulen,uw=userDraw()
elseif x >= w/2-plen/2-1 and x <= w/2+plen/2 and y == 12 and reg.passwordProtection == "1" then
	no=userInput(lang.userPassword)
	if no ~= "yes" then
		temp=tools.input(true)
		if temp ~= "" then
			reg.password=temp
		end
	end
	userDraw()
end
end
return cords
end

while true do
	open=MainMenu()
	if reg.powerSafe == "1" then
		color(0)
		fill(1,2,w,h-2," ")
	else
		color(0xe0e0e0)
		fill(1,2,w,h-2," ")
		color(0xffffff)
	end
	fill(5,4,w-8,h-4," ")
	tools.btn(6,4,"<-")
	fcolor(0)
	if open == 3 then
		language()
	elseif open == 2 then
		userSett()
	elseif open == 1 then
		computer()
	elseif open == 4 then
		autostart()
	end
	open=nil
end