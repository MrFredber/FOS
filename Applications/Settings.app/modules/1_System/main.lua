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
local reg,lang,menustr={},{},{}
local menuopen,open,scrollY,x,y,maincolor,secondcolor,mainfcolor,secondfcolor,file,screenh,moduleh,hlimit=1,0,0
local len=unicode.len
function module.init(registry,language)
menuopen=1
scrollY=0
ressuccess=false
reg=registry
lang=language
module.name=lang.SystemName
if reg.powerSafe == "1" then
	maincolor=0
	secondcolor=0x404040
	mainfcolor=0xffffff
	secondfcolor=0xbbbbbb
elseif reg.darkMode == "1" then
	maincolor=0x202020
	secondcolor=0x404040
	mainfcolor=0xffffff
	secondfcolor=0xbbbbbb
else
	maincolor=0xdddddd
	secondcolor=0xffffff
	mainfcolor=0
	secondfcolor=0x707070
end
contrastColor=tonumber(reg.contrastColor) or math.random(16777215)
screenh=h-4
end

local function menu()
fill(x,y-1,w,h-y+1," ")
menustr={lang.SystemDisplay,"---","---","---"}--,"Питание","Память","О системе"
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
fill(x,y-1,w,h-y+1," ")
color(secondcolor)
fill(x,y+3+scrollY,w-x,maxh," ")
set(w-(2+rightmax),y+(maxh/2)+2+scrollY,lang.width..":")
set(w-(2+rightmax),y+(maxh/2)+4+scrollY,lang.height..":")
set(w-4,y+(maxh/2)+2+scrollY,reg.width)
set(w-4,y+(maxh/2)+4+scrollY,reg.height)
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

function module.draw(tx,ty)
x=tx
y=ty
color(maincolor)
fcolor(mainfcolor)
if menuopen == 1 then
	menu()
elseif open == 1 then
	display()
elseif open == 3 then
	power()
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
	elseif open == 1 then
		if cx >= w-(2+rightmax) and cx <= w-1 and cy == math.floor(y+(maxh/2)+2+scrollY) then
			temp=tools.input(w-4,y+(maxh/2)+2+scrollY,3,"0",tostring(reg.width),"1")
			temp=temp or "a"
			if tonumber(temp) then
				if tonumber(temp) < 27 then
					tools.error({lang.resolutionAbove.."27"},1)
				else
					reg.width=temp
				end
			else
				tools.error({lang.notNumber},1)
			end
		elseif cx >= w-(2+rightmax) and cx <= w-1 and cy == math.floor(y+(maxh/2)+4+scrollY) then
			temp=tools.input(w-4,y+(maxh/2)+4+scrollY,3,"0",tostring(reg.height),"1")
			temp=temp or "a"
			if tonumber(temp) then
				if tonumber(temp) < 15 then
					tools.error({lang.resolutionAbove.."15"},1)
				else
					reg.height=temp
				end
			else
				tools.error({lang.notNumber},1)
			end
		elseif cx >= x+1 and cx <= x+3+bslen and cy == y+3+maxh+scrollY-1 then
			if gpu.setResolution(tonumber(reg.width),tonumber(reg.height)) == true then
				ressuccess=true
				module.save()
				comp.shutdown(true)
			else
				tools.error({lang.resolutionErr},2)
			end
		elseif cx >= x+4+bslen and cx <= x+6+bslen+bslen1 and cy == y+3+maxh+scrollY-1 then
			temp,temp1=gpu.maxResolution()
			reg.width=tostring(temp)
			reg.height=tostring(temp1)
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
if ressuccess then
	file=io.open("/fos/system/registry","w")
	for k in pairs(reg) do
		file:write(k.."="..reg[k].."\n")
	end
	file:close()
end
end

return module