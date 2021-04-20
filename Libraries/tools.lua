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
local data={}

function tools.bar(x,y,width,procent)
w,h=gpu.getResolution()
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
w,h=gpu.getResolution();
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
len=unicode.len(t)
set(x-1,y,"⢾")
set(x+len,y,"⡷")
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

function tools.error(msg,critical)
clr=gpu.getBackground()
fclr=gpu.getForeground()
slen=unicode.len(msg)
tlen=slen+11
color(0)
fill(w/2-tlen/2+1,h/2-2,tlen,6," ")
color(0xffffff)
fcolor(0)
fill(w/2-tlen/2,h/2-3,tlen,6," ")
set(w/2-tlen/2+10,h/2-1,msg)
fcolor(0xffd800)
set(w/2-tlen/2+4,h/2-2,"⣼⣧")
set(w/2-tlen/2+3,h/2-1,"⣼⡇⢸⣧")
set(w/2-tlen/2+2,h/2,"⣼⣿⣧⣼⣿⣧")
set(w/2-tlen/2+1,h/2+1,"⣼⣿⣿⣧⣼⣿⣿⣧")
xw=((w/2-tlen/2+10)+(w/2+tlen/2))/2-2
tools.btn(xw,h/2,"OK")
exit=0
while exit ~= 1 do
	_,_,x,y=event.pull("touch")
	if x >= xw-1 and x <= xw+2 and y == math.floor(h/2) then
		exit=1
	end
end
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