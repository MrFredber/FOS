local picture={}
local gpu=require("component").gpu
local set=gpu.set
local color=gpu.setBackground
local fcolor=gpu.setForeground

function picture.screenshot(x,y,width,height)
local data={width=width,height=height,color={},fcolor={},txt={}}
hi=1
while hi ~= height+1 do
	i=1
	temp={txt={},c={},f={}}
	while i ~= width+1 do
		temp.txt[i],temp.f[i],temp.c[i]=gpu.get(x+i-1,y+hi-1)
		i=i+1
	end
	data.color[hi]=temp.c
	data.fcolor[hi]=temp.f
	data.txt[hi]=temp.txt
	hi=hi+1
end
return data
end

function picture.draw(x,y,data)
hi=1
while hi ~= data.height+1 do
	i=1
	while i ~= data.width+1 do 
		color(data.color[hi][i])
		fcolor(data.fcolor[hi][i])
		set(x+i-1,y+hi-1,data.txt[hi][i])
		i=i+1
	end
	hi=hi+1
end
end

function picture.spic(x,y,data)
count=1
if data[1] == "2" then --ver 2
	count=2
	while count-1 ~= #data do
		if data[count]:find("set") ~= nil then
			p=data[count]:find("|")
			s=data[count]:sub(p+1)
			p=s:find("|")
			a=s:sub(0,p-1)
			s=s:sub(p+1)
			p=s:find("|")
			b=s:sub(0,p-1)
			set(x+tonumber(a),y+tonumber(b),s:sub(p+1))
		elseif data[count]:find("color") ~= nil then
			p=data[count]:find("|")
			color(tonumber(data[count]:sub(p+1)))
		else
			print("SPIC: UnkCommand")
		end
		count=count+1
	end
else --ver 1
	while count-1 ~= #data do
		if string.find(data[count],"set") ~= nil then
			set(x+tonumber(data[count+1]),y+tonumber(data[count+2]),data[count+3])
			count=count+3
		elseif string.find(data[count],"color") ~= nil then
			color(tonumber(data[count+1]))
			count=count+1
		else
			print("SPIC: UnkCommand")
		end
		count=count+1
	end
end
end

return picture