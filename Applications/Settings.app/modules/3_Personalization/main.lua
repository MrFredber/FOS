local r=require
local module={}
local gpu=r("component").gpu
local fill=gpu.fill
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set
local unicode=r("unicode")
local io=r("io")
local tools=r("fos/tools")
local picture=r("fos/picture")
local user,lang,menustr,colors={},{},{},{}
local menuopen,open,scrollY,x,y,maincolor,secondcolor,mainfcolor,secondfcolor,file,screenh,moduleh,hlimit=1,0,0
local len=unicode.len

function module.init(usersett,language,a)
menuopen=1
scrollY=0
user=usersett
lang=language
module.name=lang.PersonalizationName
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
screenh=h-4
if a == "colors" then
	menuopen=0
	open=2
end
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
end

local function menu()
fill(x,y-1,w,h-y+1," ")
menustr={"---",lang.colors,"---","---"}--Фон,Темы,Экран блокировки
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

local function colorsMenuDraw()
rightmax=0
maxh=3
temp={lang.light,lang.dark}
for i=1,#temp do
	slen=len(temp[i])
	if slen > rightmax then
		rightmax=slen
	end
end
rightmax=rightmax+2
text=tools.wrap(lang.PersonalizationModeMsg,w-x-(4+rightmax))
if #text > 2 then
	maxh=maxh+(#text-2)
end
fill(x,y-1,w,h-y+1," ")
color(secondcolor)
fill(x,y+3+scrollY,w-x,maxh," ")
set(w-(2+rightmax),y+(maxh/2)+2+scrollY,lang.light)
set(w-(2+rightmax),y+(maxh/2)+4+scrollY,lang.dark)
if user.darkMode then
	tools.radioBtn(w-3,y+(maxh/2)+2+scrollY,"0")
	tools.radioBtn(w-3,y+(maxh/2)+4+scrollY,"1")
else
	tools.radioBtn(w-3,y+(maxh/2)+2+scrollY,"1")
	tools.radioBtn(w-3,y+(maxh/2)+4+scrollY,"0")
end
set(x+1,y+3+scrollY,lang.PersonalizationMode)
fcolor(secondfcolor)
for i=1,#text do
	set(x+1,y+3+i+scrollY,text[i])
end
color(maincolor)
fcolor(secondcolor)
fill(x+1,y+2+scrollY,w-x-1,1,"⣶")
set(x,y+2+scrollY,"⣴")
set(w-1,y+2+scrollY,"⣦")
if user.powerSafe then
	text=tools.wrap(lang.PersonalizationModeBlocked,w-x-2)
	warncolor=0xb40000
	amaxh=#text
	color(secondcolor)
	fcolor(warncolor)
	fill(x,y+3+maxh+scrollY,w-x,1,"⣀")
	color(warncolor)
	fcolor(mainfcolor)
	fill(x,y+4+maxh+scrollY,w-x,amaxh," ")
	for i=1,#text do
		set(x+1,y+3+maxh+i+scrollY,text[i])
	end
	fcolor(warncolor)
else
	amaxh=-1
	fcolor(secondcolor)
end
color(maincolor)
fill(x+1,y+4+maxh+amaxh+scrollY,w-x-1,1,"⠿")
set(x,y+4+maxh+amaxh+scrollY,"⠻")
set(w-1,y+4+maxh+amaxh+scrollY,"⠟")
colors={0xffb900,0xff8c00,0xff0000,0xe3008c,0xd95be6,0x0000ff,0x0094ff,0x00ff00,0x00cc6a}
wc=x-3
hc=y+9+maxh+amaxh+scrollY
bmaxh=7
for i=1,#colors do
	wc=wc+4
	if wc+4 >= w-3 then
		wc=x-3
		hc=hc+2
		bmaxh=bmaxh+2
	end
end
arightmax=len(lang.set)+3
text=tools.wrap(lang.PersonalizationCustom,w-x-(2+arightmax))
text1=tools.wrap(lang.PersonalizationHeaders,w-x-7)
bmaxh=bmaxh+#text+#text1
color(maincolor)
fcolor(secondcolor)
fill(x+1,y+5+maxh+amaxh+scrollY,w-x-1,1,"⣶")
set(x,y+5+maxh+amaxh+scrollY,"⣴")
set(w-1,y+5+maxh+amaxh+scrollY,"⣦")
color(secondcolor)
fcolor(mainfcolor)
fill(x,y+6+maxh+amaxh+scrollY,w-x,bmaxh," ")
set(x+1,y+6+maxh+amaxh+scrollY,lang.PersonalizationContrast)
set(x+1,y+8+maxh+amaxh+scrollY,lang.PersonalizationContrastFOS)
for i=1,#text do
	set(x+1,hc+2+i,text[i])
end
for i=1,#text1 do
	set(x+1,hc+3+i+#text,text1[i])
end
tools.btn(w-arightmax,hc+3+(#text/2),lang.set)
tools.lvr(w-5,hc+4+#text+(#text1/2),user.contrastColorHeaders)
fcolor(maincolor)
fill(x,y+7+maxh+amaxh+scrollY,w-x,1,"⠤")
--fill(x,hc+2,w-x,1,"⠤")
fill(x,hc+3+#text,w-x,1,"⠤")
wc=x-3
hc=y+9+maxh+amaxh+scrollY
for i=1,#colors do
	wc=wc+4
	if wc+4 >= w-3 then
		wc=x+1
		hc=hc+2
	end
	color(tonumber(colors[i]))
	if tonumber(user.contrastColor) == tonumber(colors[i]) then
		local _,gg=picture.HEXtoRGB(colors[i])
		if gg < 160 then
			fcolor(0xffffff)
		else
			fcolor(0)
		end
		set(wc,hc,"  ⢀⠄")
		set(wc,hc+1," ⠑⠁ ")
	else
		fill(wc,hc,4,2," ")
	end
end
color(maincolor)
fcolor(secondcolor)
fill(x+1,hc+4+#text+#text1,w-x-1,1,"⠿")
set(x,hc+4+#text+#text1,"⠻")
set(w-1,hc+4+#text+#text1,"⠟")
moduleh=y+6+maxh+amaxh+bmaxh
end

function module.draw(tx,ty)
x=tx
y=ty
color(maincolor)
fcolor(mainfcolor)
if menuopen == 1 then
	menu()
elseif open == 2 then
	colorsMenuDraw()
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

function module.press(tip,cx,cy,click)
local toApp,wtr=nil,nil
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
		if cx >= w-(2+rightmax) and cx <= w-3 and cy == y+math.floor(maxh/2)+2+scrollY then
			if user.darkMode then
				user.darkMode=false
				toApp="reboot"
				wtr="colors"
			end
		elseif cx >= w-(2+rightmax) and cx <= w-3 and cy == y+math.floor(maxh/2)+4+scrollY then
			if user.darkMode == false then
				user.darkMode=true
				toApp="reboot"
				wtr="colors"
			end
		elseif cx >= w-5 and cx <= w-2 and cy == math.floor(hc+4+#text+(#text1/2)) then
			toApp="noupdateui"
			if user.contrastColorHeaders then
				user.contrastColorHeaders=false
			else
				user.contrastColorHeaders=true
			end
			color(secondcolor)
			tools.lvr(w-5,hc+4+#text+(#text1/2),"0","1")
			os.sleep(0.1)
			tools.lvr(w-5,hc+4+#text+(#text1/2),user.contrastColorHeaders)
		elseif cx >= w-arightmax and cx <= w-2 and cy == math.floor(hc+3+(#text/2)) then
			temp=tools.input(w-arightmax,hc+3+(#text/2),arightmax-1,"0",user.contrastColor,"1")
			if tonumber(temp) == nil then
				tools.error({lang.notNumber},1)
				toApp="a"
			else
				if type(temp) == "number" then
					user.contrastColor=temp
				else
					user.contrastColor=tonumber(temp)
				end
				toApp="reboot"
				wtr="colors"
			end
		end
		wc=x-3
		hc=y+9+maxh+amaxh+scrollY
		a=0
		for i=1,#colors do
			wc=wc+4
			if wc+4 >= w-3 then
				wc=x+1
				hc=hc+2
			end
			if cx >= wc and cx <= wc+3 and cy >= hc and cy <= hc+1 then
				a=i
			end
		end
		if a ~= 0 then
			user.contrastColor=colors[a]
			toApp="reboot"
			wtr="colors"
		else
			if toApp == nil then
				toApp="noupdateui"
			end
		end
	else
		toApp="noupdateui"
	end
end
return toApp,wtr
end

return module