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
local data={}
local w,h=gpu.getResolution()

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
fcolor(0x0069ff)
slen=len(t)
set(x-1,y,"⢾")
set(x+slen,y,"⡷")
color(0x0069ff)
fcolor(0xffffff)
set(x,y,t)
color(clr)
fcolor(fclr)
end

function tools.lvr(x,y,a)
clr=gpu.getBackground()
fclr=gpu.getForeground()
color(0xe0e0e0)
fcolor(0xffffff)
if a == "1" or a == true then
set(x,y,"   ")
color(0x009400)
set(x+3,y," √ ")
else
set(x+3,y,"   ")
color(0xb40000)
set(x,y," X ")
end
color(clr)
fcolor(fclr)
end

function tools.input(s)
clr=gpu.getBackground()
fclr=gpu.getForeground()
data=picture.screenshot(1,h,w,1)
term.setCursor(1,h)
color(0xffffff)
fcolor(0)
fill(1,h,w,1," ")
if s == true then
	text=term.read({},false,"","*")
else
	text=term.read({},false)
end
text=unicode.sub(text,1,-2)
picture.draw(1,h,data)
color(clr)
fcolor(fclr)
return text
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
data=picture.screenshot(x,y,max+1,#args+1)
color(0)
fill(x+1,y+1,max,#args," ")
color(0xffffff)
fcolor(0)
fill(x,y,max,#args," ")
i=1
while i-1 ~= #args do
	if args[i]:find("|") ~= nil then
		fill(x,y+i-1,max,1,"―")
	elseif args[i]:find("<gray>") ~= nil then
		fcolor(0x727272)
		temp=unicode.sub(args[i],7)
		set(x+1,y+i-1,temp)
		fcolor(0)
	else
		set(x+1,y+i-1,args[i])
	end
	i=i+1
end
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
maxh=4
slen=len(msg)
if type == 1 or type == 2 then
	tlen=slen+11
	maxh=maxh+2
	xw=((w/2-tlen/2+10)+(w/2+tlen/2))/2-2
else
	tlen=slen+2
	xw=((w/2-tlen/2)+(w/2+tlen/2))/2-1
end
data=picture.screenshot(w/2-tlen/2,h/2-maxh/2,tlen+1,maxh+2)
color(0)
fill(w/2-tlen/2+1,h/2-maxh/2+1,tlen,maxh," ")
color(0xffffff)
fcolor(0)
fill(w/2-tlen/2,h/2-maxh/2,tlen,maxh," ")
if type == 1 or type == 2 then
	set(w/2-tlen/2+10,h/2-1,msg)
else
	set(w/2-tlen/2+1,h/2-1,msg)
end
if type == 2 then
	fcolor(0xff0000)
	set(w/2-tlen/2+1,h/2-2,"⢠⡶⢿⣿⣿⡿⢶⡄")
	set(w/2-tlen/2+1,h/2-1,"⣿⣷⣄⠙⠋⣠⣾⣿")
	set(w/2-tlen/2+1,h/2,"⣿⡿⠋⣠⣄⠙⢿⣿")
	set(w/2-tlen/2+1,h/2+1,"⠘⠷⣾⣿⣿⣷⠾⠃")
elseif type == 1 then
	fcolor(0xffd800)
	set(w/2-tlen/2+4,h/2-2,"⣼⣧")
	set(w/2-tlen/2+3,h/2-1,"⣼⡇⢸⣧")
	set(w/2-tlen/2+2,h/2,"⣼⣿⣧⣼⣿⣧")
	set(w/2-tlen/2+1,h/2+1,"⣼⣿⣿⣧⣼⣿⣿⣧")
end
tools.btn(xw,h/2,"OK")
while true do
	_,_,x,y=event.pull("touch")
	if x >= xw-1 and x <= xw+2 and y == math.floor(h/2) then
		break
	end
end
picture.draw(w/2-tlen/2,h/2-3,data)
color(clr)
fcolor(fclr)
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