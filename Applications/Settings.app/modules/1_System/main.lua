local r=require
local module={}
local gpu=r("component").gpu
local fill=gpu.fill
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set
local unicode=r("unicode")
local tools=r("fos/tools")
local comp=r("computer")
local finder=r("fos/finder")
local user,lang,menustr,gensett={},{},{},{}
local menuopen,open,lastopen,scrollY,x,y,maincolor,secondcolor,mainfcolor,secondfcolor,file,screenh,moduleh,hlimit=1,0,0,0
local len=unicode.len
function module.init(usersett,language)
menuopen=1
scrollY=0
ressuccess=false
user=usersett
lang=language
module.name=lang.SystemName
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
contrastColor=tonumber(user.contrastColor) or math.random(16777215)
screenh=h-4
gensett={}
file=io.open("/fos/system/generalSettings.cfg","r")
for var in file:lines() do
	table.insert(gensett,var)
end
file:close()
gensett=finder.unserialize(gensett)
var=nil
end

local function menu()
fill(x,y-1,w,h-y+1," ")
menustr={lang.SystemDisplay,"---","---","О системе"}--,"Питание","Память"
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

local function display()
rightmax=0
maxh=3
temp={lang.width..":",lang.height..":"}
for i=1,#temp do
	slen=len(temp[i])
	if slen > rightmax then
		rightmax=slen
	end
end
rightmax=rightmax+3
text1=tools.wrap(lang.resolution,w-x-(4+rightmax))
text=tools.wrap(lang.resolutionMsg,w-x-(4+rightmax))
if #text1+#text > 3 then
	maxh=maxh+(#text1+#text-3)
end
maxh=maxh+2
color(secondcolor)
fill(x,y+3+scrollY,w-x,maxh," ")
set(w-(2+rightmax),y+(maxh/2)+2+scrollY,lang.width..":")
set(w-(2+rightmax),y+(maxh/2)+4+scrollY,lang.height..":")
set(w-4,y+(maxh/2)+2+scrollY,tostring(gensett.width))
set(w-4,y+(maxh/2)+4+scrollY,tostring(gensett.height))
for i=1,#text1 do
	set(x+1,y+2+i+scrollY,text1[i])
end
fcolor(secondfcolor)
for i=1,#text do
	set(x+1,y+2+#text1+i+scrollY,text[i])
end
bslen=len(lang.ok)
bslen1=len(lang.default)
tools.btn(x+1,y+3+maxh+scrollY-1,lang.ok)
tools.btn(x+4+bslen,y+3+maxh+scrollY-1,lang.default)
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

local function power()

end

local function about()
color(secondcolor)
fill(x,y+2+scrollY,w-x,6," ")
fcolor(secondcolor)
color(maincolor)
set(x,y+2+scrollY,"⣾")
set(w-1,y+2+scrollY,"⣷")
set(x,y+7+scrollY,"⢿")
set(w-1,y+7+scrollY,"⡿")
color(thirdcolor)
fcolor(0x0094ff)
set(x+3,y+3+scrollY,"⠀⢀⣀⣀⡀⠀")
set(x+2,y+4+scrollY,"⠀⠀⢸⣏⣉⡁⠀⠀")
set(x+2,y+5+scrollY,"⠀⠀⢸⡏⠉⠁⠀⠀")
set(x+3,y+6+scrollY,"⠀⠈⠁⠀⠀⠀")
color(secondcolor)
fcolor(thirdcolor)
set(x+2,y+3+scrollY,"⣾")
set(x+9,y+3+scrollY,"⣷")
set(x+2,y+6+scrollY,"⢿")
set(x+9,y+6+scrollY,"⡿")
fcolor(mainfcolor)
set(x+12,y+4+scrollY,"FredberOS")
fcolor(secondfcolor)
set(x+12,y+5+scrollY,"©2019-2022")
end

function module.draw(tx,ty)
x=tx
y=ty
color(maincolor)
fcolor(mainfcolor)
if lastopen ~= open then
	fill(x,y-1,w-x+1,h-y+1," ")
end
if menuopen == 1 then
	menu()
elseif open == 1 then
	display()
elseif open == 3 then
	power()
elseif open == 4 then
	about()
end
color(maincolor)
fcolor(mainfcolor)
if menuopen == 1 then
	set(x,y+scrollY,module.name)
elseif lastopen ~= open then
	set(x,y+scrollY,module.name.." > "..menustr[open])
end
hlimit=-(moduleh-screenh-2)
lastopen=open
end

function module.press(tip,cx,cy,click)
local toApp=nil
if tip == "scroll" then
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
elseif tip == "touch" then
	if menuopen == 1 then
		open=0
		lastopen=0
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
	elseif open == 1 then
		if cx >= w-(2+rightmax) and cx <= w-1 and cy == math.floor(y+(maxh/2)+2+scrollY) then
			temp=tools.input(w-4,y+(maxh/2)+2+scrollY,3,"0",tostring(gensett.width),"1")
			temp=tonumber(temp) or "a"
			if temp then
				if temp < 27 then
					tools.error({lang.resolutionAbove.."27"},1)
				else
					gensett.width=temp
				end
			else
				tools.error({lang.notNumber},1)
			end
		elseif cx >= w-(2+rightmax) and cx <= w-1 and cy == math.floor(y+(maxh/2)+4+scrollY) then
			temp=tools.input(w-4,y+(maxh/2)+4+scrollY,3,"0",tostring(gensett.height),"1")
			temp=tonumber(temp) or "a"
			if temp then
				if temp < 15 then
					tools.error({lang.resolutionAbove.."15"},1)
				else
					gensett.height=temp
				end
			else
				tools.error({lang.notNumber},1)
			end
		elseif cx >= x+1 and cx <= x+3+bslen and cy == y+3+maxh+scrollY-1 then
			if gpu.setResolution(tonumber(gensett.width),tonumber(gensett.height)) == true then
				ressuccess=true
				module.save()
				comp.shutdown(true)
			else
				tools.error({lang.resolutionErr},2)
			end
		elseif cx >= x+4+bslen and cx <= x+6+bslen+bslen1 and cy == y+3+maxh+scrollY-1 then
			gensett.width,gensett.height=gpu.maxResolution()
		else
			toApp="noupdateui"
		end
	elseif open == 3 then

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
temp=finder.serialize(gensett)
file=io.open("/fos/system/generalSettings.cfg","w")
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