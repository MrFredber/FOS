local r=require
local module={}
local gpu=r("component").gpu
local fill=gpu.fill
local color=gpu.setBackground
local fcolor=gpu.setForeground
local set=gpu.set
local fs=r("filesystem")
local unicode=r("unicode")
local finder=r("fos/finder")
local tools=r("fos/tools")
local event=r("event")
local len=unicode.len
local files,reg,lang,appnames,sizes={},{},{},{},{}
local scrollY,first=0,1
function module.init(registry,language)
scrollY=0
first=1
reg=registry
lang=language
module.name=lang.AppsName.." (not functioning yet)"
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
screenh=h-4
end

function module.draw(x,y)
if first == 1 then
	color(maincolor)
	fcolor(mainfcolor)
	fill(x,y-1,w,h-y+1," ")
	appnames={}
	files=finder.files("/fos/apps")
	for i=1,#files do
		set(x,y,"Loading ("..i.."/"..#files..")")
		appname={}
		if fs.exists("/fos/apps/"..files[i].."appname/"..reg.lang) then
			file=io.open("/fos/apps/"..files[i].."appname/"..reg.lang)
			for var in file:lines() do table.insert(appname,var) end
			file:close()
		else
			appname={files[i]}
		end
		table.insert(appnames,appname[1])
		result=finder.findAll("/fos/apps/"..files[i])
		temp=0
		for i=1,#result do
			temp1=fs.size(result[i])
			temp=temp+temp1
		end
		table.insert(sizes,finder.verbalSize(temp))
	end
	first=0
end
color(maincolor)
fcolor(mainfcolor)
fill(x,y-1,w,h-y+1," ")
set(x,y,module.name)
color(secondcolor)
for i=1,#appnames do
	color(secondcolor)
	fcolor(mainfcolor)
	fill(x,y+i+i+i+scrollY,w-x,1," ")
	rightmax=len(sizes[i])+1
	set(x+1,y+i+i+i+scrollY,appnames[i])
	set(w-(2+rightmax),y+i+i+i+scrollY,sizes[i].." >")
	color(maincolor)
	fcolor(secondcolor)
	fill(x+1,y-1+i+i+i+scrollY,w-x-1,1,"⣶")
	fill(x+1,y+1+i+i+i+scrollY,w-x-1,1,"⠿")
	set(x,y-1+i+i+i+scrollY,"⣴")
	set(x,y+1+i+i+i+scrollY,"⠻")
	set(w-1,y-1+i+i+i+scrollY,"⣦")
	set(w-1,y+1+i+i+i+scrollY,"⠟")
	moduleh=y+1+i+i+i
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
	toApp="noupdateui"
	--OwO
end
return toApp
end

function module.save()
--OwO
end

return module