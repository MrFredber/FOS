local r=require
local io=r("io")
local gpu=r("component").gpu
local unicode=r("unicode")
local event=r("event")
local tools=r("/fos/tools")
local comp=r("computer")
local fill=gpu.fill
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set
local len=unicode.len
local lang={}
local user={}
local comp={}
local auto={}
local max=0
local no=""
local open=nil
local file=io.open("/fos/system/user.cfg","r")
for var in file:lines() do table.insert(user,var) end
file:close()
local file=io.open("/fos/system/comp.cfg","r")
for var in file:lines() do table.insert(comp,var) end
file:close()
local userColor=tonumber(user[2]) or tonumber("0x"..user[2]) or math.random(16777215)
local w,h=gpu.getResolution();
local langsett={}
local file=io.open("/fos/system/lang.cfg","r")
for var in file:lines() do table.insert(langsett,var) end
file:close()
local file=io.open("/fos/apps/settings.app/lang/"..langsett[1],"r")
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

local function iconLang(x,y)
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

local function iconUser(x,y)
fcolor(userColor)
set(x+1,y,"⢠⡶⢿⡿⢶⡄")
set(x+1,y+1,"⣿⣇⣸⣇⣸⣿")
set(x+1,y+2,"⠘⠿⣮⣵⠿⠃")
set(x+1,y+3,"⣀⣤⣿⣿⣤⣀")
end

local function iconComp(x,y)
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

local function iconAuto(x,y)
color(0xffffff)
fcolor(0)
set(x,y,"⡏⠍⠭⠭⠭⠭⠭⢹")
set(x,y+1,"⡇⠅⠭⠭⠭⠭⠭⢸")
set(x,y+2,"⡇⠅⠭⠭⠭⠭⠭⢸")
set(x,y+3,"⣇⣁⣭⣭⣭⣭⣉⣸")
end

local function MainMenu()
local cords={x={},y={}}
if comp[1] == "1" then
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

local function autoDraw()
color(0xffffff)
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
color(0xffffff)
tools.btn(w/2-2,h/2+#auto/2+1,"+")
tools.btn(w/2+2,h/2+#auto/2+1,"-")
return max
end

local function autoApply()
local file=io.open("/fos/system/auto.cfg","w")
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

local function autostart()
auto={}
local file=io.open("/fos/system/auto.cfg","r")
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
			result=pcall(autoSubTbl)
			if not result then
				tools.error(lang.autoSubErr)
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

local function autoSubTbl()
table.remove(auto,var)
table.pack(auto)
end

local function autoMove(tbl1,tbl2)
if tbl1 > #auto or tbl1 < 1 or tbl2 > #auto or tbl2 < 1 then
	tools.error(lang.autoMoveErr.." ("..tbl1..";"..tbl2..")")
else
	temp=auto[tbl1]
	auto[tbl1]=auto[tbl2]
	auto[tbl2]=temp
	table.pack(auto)
end
end

local function compApply()
local file=io.open("/fos/system/comp.cfg","w")
file:write(comp[1].."\n"..comp[2])
file:close()
end

local function compDraw()
color(0xffffff)
fcolor(0)
fill(5,5,w-8,h-5," ")
slen=len(lang.compPowerSave)
elen=slen+7
set(w/2-elen/2,5,lang.compPowerSave)
tools.lvr(w/2+elen/2-6,5,comp[1])
tlen=len(lang.compResolution)
slen=len(comp[2]:gsub(",","x"))
rlen=tlen+slen
set(w/2-rlen/2,8,lang.compResolution)
set(w/2+rlen/2-slen,8,tostring(comp[2]:gsub(",","x")))
fcolor(0x727272)
slen=len(lang.compPowerSaveMsg)
set(w/2-slen/2,6,lang.compPowerSaveMsg)
if comp[1] == "1" then
	color(0)
	fill(1,10,w,h-10," ")
end
end

local function computer()
compDraw()
while true do
	local _,_,x,y=event.pull("touch")
	if x >= 6 and x <= 9 and y == 4 then
		compApply()
		break
	elseif x >= w/2+elen/2-7 and x <= w/2+elen/2-1 and y == 5 then
		if comp[1] == "1" then
			comp[1]="0"
		else
			comp[1]="1"
		end
		compDraw()
	elseif x >= w/2-rlen/2 and x <= w/2+rlen/2 and y == 8 then
		no=userInput(lang.compResolutionMsg)
		if no ~= "yes" then
			temp=tools.input()
			pos=temp:find(",")
			if pos ~= nil then
				if tonumber(temp:sub(1,pos-1)) == nil or tonumber(temp:sub(pos+1)) == nil then
					tools.error(lang.compResolutionErr)
				else
					comp[2]=temp
				end
			else
				tools.error(lang.compResolutionErr)
			end
		end
		compDraw()
	elseif x >= w-2 and x <= w and y == 1 then
		compApply()
		lang=nil
		os.exit()
	end
end
end

function language()
tools.tblprint(lang)
slen=len(lang.lang)
set(w/2-slen/2+1,5,lang.lang)
tools.btn(w/2-8,7,"English")
tools.btn(w/2+2,7,"Русский")
fcolor(0x727272)
slen=len(lang.langMsg1)
set(w/2-slen/2,9,lang.langMsg1)
slen=len(lang.langMsg2)
set(w/2-slen/2,10,lang.langMsg2)
if comp[1] == "1" then
	color(0)
	fill(1,12,w,h-12," ")
end
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
		local file=io.open("/fos/system/lang.cfg","w")
		file:write(langchoise)
		file:close()
		lang=nil
		os.exit()
	end
end
end

local function userDraw()
userColor=tonumber(user[2]) or tonumber("0x"..user[2]) or math.random(16777215)
color(0xffffff)
fill(5,5,w-8,h-5," ")
ulen=len(user[1])
if tonumber(user[2]) ~= nil then
	clen=len(lang.userColor..user[2])
elseif tonumber("0x"..user[2]) ~= nil then
	clen=len(lang.userColor.."0x"..user[2])
else
	clen=len(lang.userColor..lang.userRandom)
end
if clen > ulen then
	xw=clen
else
	xw=ulen
end
xu=w/2-5-xw/2
iconUser(xu,5)
fcolor(0)
set(xu+9,6,user[1])
if tonumber(user[2]) ~= nil or tonumber("0x"..user[2]) ~= nil then
	set(xu+9,7,lang.userColor..user[2])
else
	set(xu+9,7,lang.userColor..lang.userRandom)
end
slen=len(lang.user)
tlen=slen+7
set(w/2-tlen/2,10,lang.user)
tools.lvr(w/2+tlen/2-6,10,user[3])
if user[3] == "1" then
	plen=len(lang.userbtn)
	tools.btn(w/2-plen/2,12,lang.userbtn)
else
	plen=0
end
if comp[1] == "1" then
	color(0)
	fill(1,14,w,h-14," ")
end
return tlen,ulen,xw,plen
end

local function userInput(txt)
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

local function userApply()
local file=io.open("/fos/system/user.cfg","w")
file:write(user[1].."\n"..user[2].."\n")
if user[3] ~= "0" and user[4] ~= nil then
	file:write("1\n"..user[4])
else
	file:write("0")
end
file:close()
end

local function userSett()
tlen,ulen,xw,plen=userDraw()
while true do
local _,_,x,y=event.pull("touch")
if x >= 6 and x <= 9 and y == 4 then
	userApply()
	break
elseif x >= w-2 and x <= w and y == 1 then
	userApply()
	lang=nil
	os.exit()
elseif x >= w/2+tlen/2-7 and x <= w/2+tlen/2-1 and y == 10 then
	if user[3] == "1" then
		user[3]="0"
		user[4]=nil
	else
		user[3]="1"
	end
	userDraw()
elseif x >= w/2-5-xw/2+8 and x <= w/2-5-xw/2+ulen+8 and y == 6 then
	no=userInput(lang.userNick)
	if no ~= "yes" then
		user[1]=tools.input()
	end
	tlen,ulen,xw=userDraw()
elseif x >= w/2-5-xw/2+8 and x <= w/2-5-xw/2+8+clen and y == 7 then
	no=userInput(lang.userColorMsg)
	if no ~= "yes" then
		user[2]=tools.input()
	end
	tlen,ulen,xw=userDraw()
elseif x >= w/2-plen/2-1 and x <= w/2+plen/2 and y == 12 and user[3] == "1" then
	no=userInput(lang.userPassword)
	if no ~= "yes" then
		temp=tools.input(true)
		if temp ~= "" then
			user[4]=temp
		end
	end
	userDraw()
end
end
return cords
end

while true do
	open=MainMenu()
	if comp[1] == "1" then
		color(0)
	else
		color(0xe0e0e0)
	end
	fill(1,2,w,h-2," ")
	color(0xffffff)
	fill(5,4,w-8,h-4," ")
	tools.btn(6,4,"<-")
	color(0xffffff)
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