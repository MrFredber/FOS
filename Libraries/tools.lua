local tools={}
local r=require
local gpu=r("component").gpu
local unicode=r("unicode")
local term=r("term")
local event=r("event")
local picture=r("/fos/picture")
local fill=gpu.fill
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set
local len=unicode.len
local data,reg={},{}
local maincolor,secondcolor,mainfcolor,secondfcolor,contrastColor,file
local w,h=gpu.getResolution()
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
if reg.darkMode == "1" or reg.powerSafe == "1" then
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
contrastColor=tonumber(reg.contrastColor) or 0x0094ff

function tools.update(registry)
reg=registry
if reg.darkMode == "1" or reg.powerSafe == "1" then
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
contrastColor=tonumber(reg.contrastColor) or 0x0094ff
end

function tools.bar(x,y,width,procent)
fcolor(0x777777)
fill(x,y,width,1,"⠒")
fcolor(0x00bf00)
a=width/100
b=a*procent
c=math.floor(b)
fill(x,y,c,1,"⠒")
fcolor(0xffffff)
end

function tools.fullbar(x,y,width,procent)
fcolor(0x777777)
fill(x,y,width,1,"⣿")
fcolor(0x00bf00)
a=width/100
b=a*procent
c=math.floor(b)
fill(x,y,c,1, "⣿")
fcolor(0xffffff)
end

function tools.btn(x,y,t)
clr=gpu.getBackground()
fclr=gpu.getForeground()
fcolor(contrastColor)
slen=len(t)
set(x,y,"⢾")
set(x+slen+1,y,"⡷")
color(contrastColor)
local _,gg=picture.HEXtoRGB(contrastColor)
if gg < 160 then
	fcolor(0xffffff)
else
	fcolor(0)
end
set(x+1,y,t)
color(clr)
fcolor(fclr)
end

function tools.lvr(x,y,a,b)
clr=gpu.getBackground()
fclr=gpu.getForeground()
if a == "1" or a == true then
	fcolor(contrastColor)
	set(x,y,"⢾")
	if reg.darkMode == "1" or reg.powerSafe == "1" then
		fcolor(0xffffff)
	else
		fcolor(0x202020)
	end
	set(x+3,y,"⡷")
	color(contrastColor)
	set(x+1,y," ⢾")
elseif b == "1" or b == true then
	fcolor(contrastColor)
	set(x,y,"⢾")
	fcolor(maincolor)
	set(x+3,y,"⡷")
	if reg.darkMode == "1" or reg.powerSafe == "1" then
		fcolor(0xffffff)
	else
		fcolor(0x202020)
	end
	color(contrastColor)
	set(x+1,y,"⢾")
	color(maincolor)
	set(x+2,y,"⡷")
else
	if reg.darkMode == "1" or reg.powerSafe == "1" then
		fcolor(0xffffff)
	else
		fcolor(0x202020)
	end
	set(x,y,"⢾")
	fcolor(maincolor)
	set(x+3,y,"⡷")
	color(maincolor)
	if reg.darkMode == "1" or reg.powerSafe == "1" then
		fcolor(0xffffff)
	else
		fcolor(0x202020)
	end
	set(x+1,y,"⡷ ")
end
color(clr)
fcolor(fclr)
end

function tools.input(x,y,width,hidden,backgroundText,active)
text={}
line=""
cursorX=1
if backgroundText ~= nil and (active == "1" or active == true) then
	for i=1,len(backgroundText) do
		table.insert(text,unicode.sub(backgroundText,i,i))
		cursorX=cursorX+1
	end
end
blink=1
clr=gpu.getBackground()
fclr=gpu.getForeground()
color(maincolor)
while true do
	local tip,_,a,b,c=event.pull(0.5)
	if tip == "key_down" then
		if a == 13 then --enter
			break
		elseif b == 14 then --backspace
			if cursorX > 1 then
				cursorX=cursorX-1
				table.remove(text,cursorX)
			end
		elseif b == 211 then --del
			if cursorX <= #text then
				table.remove(text,cursorX)
				table.pack(text)
			end
		elseif b == 203 then --left
			if cursorX > 1 then
				cursorX=cursorX-1
			end
		elseif b == 205 then --right
			if cursorX <= #text then
				cursorX=cursorX+1
			end
		elseif b == 199 then --home
		cursorX=1
		elseif b == 207 then --end
		cursorX=#text+1
		elseif a ~= 0 then
			table.insert(text,cursorX,unicode.char(a))
			cursorX=cursorX+1
		end
		blink=1
	elseif tip == "touch" then
		if a >= x and a <= x+width-1 and b == y then

		else
			break
		end
	end
	line=table.concat(text)
	fcolor(mainfcolor)
	fill(x,y,width,1," ")
	if backgroundText ~= nil and active ~= "1" and active ~= true and line == "" then
		fcolor(secondfcolor)
		set(x,y,unicode.sub(backgroundText,1,width))
	else
		if hidden == "1" or hidden == true then
			if cursorX > width then
				fill(x,y,width-1,1,"*")
			else
				fill(x,y,len(line),1,"*")
			end
		else
			if cursorX > width then
				set(x,y,unicode.sub(line,cursorX-width+1,cursorX))
			else
				set(x,y,unicode.sub(line,1,width))
			end
		end
	end
	if blink == 1 then
		fcolor(contrastColor)
		if cursorX > width then
			set(x+width-1,y,"|")
		else
			set(x-1+cursorX,y,"|")
		end
		blink=0
	else
		blink=1
	end
end
color(clr)
fcolor(fclr)
return line
end

function tools.conMenu(x,y,args)
i=1
max=0
while i-1 ~= #args do
	if args[i]:find("<gray>") ~= nil then
		temp=unicode.sub(args[i],7)
		slen=len(temp)
	else
		slen=len(args[i])
	end
	if slen > max then
		max=slen
	end
	i=i+1
end
max=max+2
if y+#args > h then
	y=y-(y+#args-h)
end
if x+max > w then
	x=x-(x+max-w)
end
_,_,temp1=gpu.get(x,y)
_,_,temp2=gpu.get(x+max-1,y)
_,_,temp3=gpu.get(x,y+#args-1)
data=picture.screenshot(x,y,max+1,#args+1)
color(secondcolor)
fcolor(mainfcolor)
fill(x,y,max,#args," ")
i=1
while i-1 ~= #args do
	if args[i]:find("|") ~= nil then
		fcolor(maincolor)
		fill(x,y+i-1,max,1,"⠤")
		fcolor(mainfcolor)
	elseif args[i]:find("<gray>") ~= nil then
		fcolor(secondfcolor)
		temp=unicode.sub(args[i],7)
		set(x+1,y+i-1,temp)
		fcolor(mainfcolor)
	else
		set(x+1,y+i-1,args[i])
	end
	i=i+1
end
fcolor(secondcolor)
if #args == 1 then
	color(temp1)
	set(x,y,"⢾")
	color(temp2)
	set(x+max-1,y,"⡷")
else
	color(temp1)
	set(x,y,"⣾")
	color(temp2)
	set(x+max-1,y,"⣷")
	color(temp3)
	set(x,y+#args-1,"⢿")
	color(0x101010)
	set(x+max-1,y+#args-1,"⡿")
end
fcolor(0x101010)
_,_,temp=gpu.get(x+max,y)
color(temp)
set(x+max,y,"⣄")
fill(x+max,y+1,1,#args-1,"⣿")
text=""
for i=1,max-2 do
	text=text.."⠛"
end
picture.adaptiveText(x+1,y+#args,"⠙"..text.."⠋",0x101010)
pos=nil
local _,_,tx,ty=event.pull("touch")
if tx >= x and tx <= x+max and ty >= y and ty <= y+#args then
	i=1
	while i-1 ~= #args do
		if ty == y+i-1 then
			pos=i
		end
		i=i+1
	end
end
picture.draw(x,y,data)
return pos
end

function tools.error(msg,type,buttons)
clr=gpu.getBackground()
fclr=gpu.getForeground()
text={}
maxh=4
maxw=w-4
width=3
if type == 1 or type == 2 then
	maxh=maxh+2
	maxw=maxw-9
end
for i=1,#msg do
	temp=tools.wrap(msg[i],maxw)
	for i=1,#temp do
		table.insert(text,temp[i])
	end
end
if type == 1 or type == 2 then
	if #text > maxh-3 then
		maxh=maxh+(#text-3)
	end
else
	if #text > maxh-3 then
		maxh=maxh+(#text-1)
	end
end
if #text > #msg then
	width=w-2
	xw=((w/2-width/2)+(w/2+width/2))/2-1
else
	max=0
	for i=1,#text do
		temp=len(text[i])+2
		if temp > max then
			max=temp
		end
	end
	width=max
	if type == 1 or type == 2 then
		width=width+9
		xw=((w/2-width/2+10)+(w/2+width/2))/2-2
	else
		xw=((w/2-width/2)+(w/2+width/2))/2-1
	end
end
hw=(h/2-maxh/2)
_,_,temp1=gpu.get(w/2-width/2,hw)
_,_,temp2=gpu.get((w/2+width/2)-1,hw)
_,_,temp3=gpu.get(w/2-width/2,hw+maxh-1)
data=picture.screenshot(w/2-width/2,hw,width+1,maxh+1)
color(secondcolor)
fcolor(mainfcolor)
fill(w/2-width/2,hw,width,maxh," ")
if type == 1 or type == 2 then
	for i=1,#text do
		set(w/2-width/2+10,hw+i,text[i])
	end
else
	for i=1,#text do
		set(w/2-width/2+1,hw+i,text[i])
	end
end
if type == 2 then
	fcolor(0xff0000)
	set(w/2-width/2+1,hw+1,"⢠⡶⢿⣿⣿⡿⢶⡄")
	set(w/2-width/2+1,hw+2,"⣿⣷⣄⠙⠋⣠⣾⣿")
	set(w/2-width/2+1,hw+3,"⣿⡿⠋⣠⣄⠙⢿⣿")
	set(w/2-width/2+1,hw+4,"⠘⠷⣾⣿⣿⣷⠾⠃")
elseif type == 1 then
	fcolor(0xffd800)
	set(w/2-width/2+4,hw+1,"⣼⣧")
	set(w/2-width/2+3,hw+2,"⣼⡇⢸⣧")
	set(w/2-width/2+2,hw+3,"⣼⣿⣧⣼⣿⣧")
	set(w/2-width/2+1,hw+4,"⣼⣿⣿⣧⣼⣿⣿⣧")
end
tools.btn(xw,hw+maxh-2,"OK")
fcolor(secondcolor)
color(temp1)
set(w/2-width/2,hw,"⣾")
color(temp2)
set((w/2+width/2)-1,hw,"⣷")
color(temp3)
set(w/2-width/2,hw+maxh-1,"⢿")
color(0x101010)
set((w/2+width/2)-1,hw+maxh-1,"⡿")
fcolor(0x101010)
_,_,temp=gpu.get(w/2+width/2,hw)
color(temp)
set(w/2+width/2,hw,"⣄")
fill(w/2+width/2,hw+1,1,maxh-1,"⣿")
text=""
for i=1,width-2 do
	text=text.."⠛"
end
picture.adaptiveText((w/2-width/2)+1,hw+maxh,"⠙"..text.."⠋",0x101010)
while true do
	tip,_,x,y=event.pull()
	if tip == "touch" then
		if x >= xw and x <= xw+3 and y == math.floor(hw+maxh-2) then
			break
		end
	elseif tip == "key_down" then
		if x == 13 then
			break
		end
	end
end
picture.draw(w/2-width/2,h/2-maxh/2,data)
color(clr)
fcolor(fclr)
end

function tools.radioBtn(x,y,a)
fclr=gpu.getForeground()
if a == "1" or a == true then
	fcolor(contrastColor)
	set(x,y,"●")
else
	fcolor(maincolor)
	set(x,y,"●")
end
fcolor(fclr)
end

function tools.wrap(text,width)
slen=len(text)
temp={}
if slen > width then
	txt=unicode.sub(text,width+1)
	table.insert(temp,unicode.sub(text,1,width))
	while true do
		newslen=len(txt)
		if newslen > width then
			table.insert(temp,unicode.sub(txt,1,width))
			txt=unicode.sub(txt,width+1)
		else
			table.insert(temp,txt)
			break
		end
	end
else
	table.insert(temp,text)
end
return temp
end

function tools.tblprint(o)
if type(o) == 'table' then
   local s='{ '
   for k,v in pairs(o) do
      if type(k) ~= 'number' then k='"'..k..'"' end
      s=s..'['..k..'] = '..tools.tblprint(v)..','
   end
   return s..'} '
else
   return tostring(o)
end
end
return tools