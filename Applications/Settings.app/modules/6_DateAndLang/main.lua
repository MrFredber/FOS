local r=require
local module={}
local gpu=r("component").gpu
local fill=gpu.fill
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set
local unicode=r("unicode")
local tools=r("fos/tools")
local fs=r("filesystem")
local finder=r("fos/finder")
local os=r("os")
local user,lang,menustr={},{},{}
local menuopen,open,scrollY,x,y,maincolor,secondcolor,mainfcolor,secondfcolor,file,screenh,moduleh,hlimit,time,timeCorrection=1,0,0
local len=unicode.len
function module.init(usersett,language)
menuopen=1
scrollY=0
langsuccess=nil
user=usersett
lang=language
module.name=lang.DateAndLangName
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
contrastColor=user.contrastColor or 0x0094ff
screenh=h-4
end

local function menu()
fill(x,y-1,w,h-y+1," ")
menustr={lang.timeName,lang.langName}
for i=1,#menustr do
	color(secondcolor)
	fcolor(mainfcolor)
	fill(x,3+i+i+i+scrollY,w-x,1," ")
	set(x+1,3+i+i+i+scrollY,menustr[i])
	set(w-2,3+i+i+i+scrollY,">")
	color(maincolor)
	fcolor(secondcolor)
	fill(x+1,2+i+i+i+scrollY,w-x-1,1,"⣶")
	fill(x+1,4+i+i+i+scrollY,w-x-1,1,"⠿")
	set(x,2+i+i+i+scrollY,"⣴")
	set(x,4+i+i+i+scrollY,"⠻")
	set(w-1,2+i+i+i+scrollY,"⣦")
	set(w-1,4+i+i+i+scrollY,"⠟")
	moduleh=4+i+i+i
end
end

local function language()
rightmax=0
maxh=3
temp={"English","Русский"}
for i=1,#temp do
	slen=len(temp[i])
	if slen > rightmax then
		rightmax=slen
	end
end
rightmax=rightmax+1
text1=tools.wrap(lang.lang,w-x-(4+rightmax))
text=tools.wrap(lang.langMsg,w-x-(4+rightmax))
if #text1+#text > 3 then
	maxh=maxh+(#text1+#text-3)
end
fill(x,y-1,w,h-y+1," ")
color(secondcolor)
fill(x,y+3+scrollY,w-x,maxh," ")
tools.btn(w-(2+rightmax),y+(maxh/2)+2+scrollY,"English")
tools.btn(w-(2+rightmax),y+(maxh/2)+4+scrollY,"Русский")
for i=1,#text1 do
	set(x+1,y+2+i+scrollY,text1[i])
end
fcolor(secondfcolor)
for i=1,#text do
	set(x+1,y+2+#text1+i+scrollY,text[i])
end
color(maincolor)
fcolor(secondcolor)
fill(x+1,y+2+scrollY,w-x-1,1,"⣶")
fill(x+1,y+3+maxh+scrollY,w-x-1,1,"⠿")
set(x,y+2+scrollY,"⣴")
set(w-1,y+2+scrollY,"⣦")
set(x,y+3+maxh+scrollY,"⠻")
set(w-1,y+3+maxh+scrollY,"⠟")
moduleh=y+3+maxh
end

local function time()
rightmax=0
maxh=1
timeCorrection=user.timeZone*3600
temp=io.open("/tmp/time","w")
temp:close()
temp=fs.lastModified("/tmp/time")
date=tonumber(string.sub(temp,1,-4))+timeCorrection
date=os.date(user.dataType,date)
rightmax=len(date)
rightmax=rightmax+1
text=tools.wrap(lang.DateAndLangNow,w-x-(2+rightmax))
if #text > 1 then
	maxh=#text
end
fill(x,y-1,w,h-y+1," ")
color(secondcolor)
fill(x,y+3+scrollY,w-x,maxh," ")
set(w-rightmax,y+(maxh/2)+3+scrollY,date)
for i=1,#text do
	set(x+1,y+2+i+scrollY,text[i])
end
color(maincolor)
fcolor(secondcolor)
fill(x+1,y+2+scrollY,w-x-1,1,"⣶")
set(x,y+2+scrollY,"⣴")
set(w-1,y+2+scrollY,"⣦")
fill(x+1,y+3+maxh+scrollY,w-x-1,1,"⠿")
set(x,y+3+maxh+scrollY,"⠻")
set(w-1,y+3+maxh+scrollY,"⠟")
rightmax=len(user.dataType)+1
text=tools.wrap(lang.DateAndLangFormat,w-x-(2+rightmax))
text1=tools.wrap(lang.taskbarSeconds,w-x-7)
amaxh=1+#text+#text1
color(secondcolor)
fcolor(mainfcolor)
fill(x,y+5+maxh+scrollY,w-x,amaxh," ")
for i=1,#text do
	set(x+1,y+4+maxh+scrollY+i,text[i])
end
for i=1,#text1 do
	set(x+1,y+5+maxh+scrollY+#text+i,text1[i])
end
set(w-rightmax,y+5+maxh+scrollY+(#text/2),user.dataType)
tools.lvr(w-5,y+6+maxh+scrollY+#text+(#text1/2),user.taskbarShowSeconds)
fcolor(maincolor)
fill(x,y+5+maxh+scrollY+#text,w-x,1,"⠤")
color(maincolor)
fcolor(secondcolor)
fill(x+1,y+4+maxh+scrollY,w-x-1,1,"⣶")
set(x,y+4+maxh+scrollY,"⣴")
set(w-1,y+4+maxh+scrollY,"⣦")
fill(x+1,y+5+maxh+amaxh+scrollY,w-x-1,1,"⠿")
set(x,y+5+maxh+amaxh+scrollY,"⠻")
set(w-1,y+5+maxh+amaxh+scrollY,"⠟")
moduleh=y+5+maxh+amaxh
end

function module.draw(tx,ty)
x=tx
y=ty
color(maincolor)
fcolor(mainfcolor)
if menuopen == 1 then
	menu()
elseif open == 2 then
	language()
elseif open == 1 then
	time()
end
color(maincolor)
fcolor(mainfcolor)
if menuopen == 1 then
	set(x,y+scrollY,module.name)
else
	set(x,y+scrollY,module.name.." > "..menustr[open])
end
hlimit=-(moduleh-screenh-2)
end

function module.press(type,cx,cy,click)
local toApp=nil
if type == "scroll" then
	toApp="noupdateui"
	if click == 1 then
		if scrollY < 0 then
			toApp=nil
			scrollY=scrollY+click
		end
	else
		if scrollY > hlimit then
			toApp=nil
			scrollY=scrollY+click
		end
	end
elseif type == "touch" then
	if menuopen == 1 then
		open=0
		for i=1,#menustr do
			if cx >= x and cx <= w-1 and cy >= y-1+i+i+i and cy <= y+1+i+i+i then
				open=i
				menuopen=0
				scrollY=0
			end
		end
	elseif menuopen == 0 and cx >= x and cx <= x+len(module.name) and cy == y then
		scrollY=0
		menuopen=1
	elseif open == 2 then
		if cx >= w-(2+rightmax) and cx <= w-1 and cy == math.floor(y+(maxh/2)+2+scrollY) then
			if user.lang ~= "english.lang" then
				user.lang="english.lang"
				module.save()
				os.exit()
			end
		elseif cx >= w-(2+rightmax) and cx <= w-1 and cy == math.floor(y+(maxh/2)+4+scrollY) then
			if user.lang ~= "russian.lang" then
				user.lang="russian.lang"
				module.save()
				os.exit()
			end
		else
			toApp="noupdateui"
		end
	elseif open == 1 then
		if cx >= w-rightmax and cx <= w-2 and cy == math.floor(y+5+maxh+scrollY+(#text/2)) then
			user.dataType=tools.input(w-rightmax,y+5+maxh+scrollY+(#text/2),rightmax-1,"0",user.dataType,"1")
		elseif cx >= w-5 and cx <= w-2 and cy == math.floor(y+6+maxh+scrollY+#text+(#text1/2)) then
			toApp="noupdateui"
			if user.taskbarShowSeconds then
				user.taskbarShowSeconds=false
			else
				user.taskbarShowSeconds=true
			end
			color(secondcolor)
			tools.lvr(w-5,y+6+maxh+scrollY+#text+(#text1/2),"0","1")
			os.sleep(0.1)
			tools.lvr(w-5,y+6+maxh+scrollY+#text+(#text1/2),user.taskbarShowSeconds)
		end
	else
		toApp="noupdateui"
	end
end
return toApp
end

function module.save()
file=io.open(user.path.."settings.cfg","w")
user.name=nil
user.path=nil
temp=finder.serialize(user)
for i=1,#temp do
	file:write(temp[i])
	if i ~= #temp then
		file:write("\n")
	end
end
file:close()
temp=nil
end

return module