local picture={}
local gpu=require("component").gpu
local w,h=gpu.getResolution()
local unicode=require("unicode")
local set=gpu.set
local color=gpu.setBackground
local fcolor=gpu.setForeground
local len=unicode.len
local file

function picture.screenshot(x,y,width,height)
w,h=gpu.getResolution()
local data={compressed=true,width=width,height=height,color={},fcolor={},txt={}}
local hi=1
local ti=1
local ci=1
while hi ~= height+1 do
	local i=1
	temp={txt={},f={},c={},stack={}}
	while i ~= width+1 do
		if ci == 1 then
			temp.stack[ci],tfclr,tclr=gpu.get(x+i-1,y+hi-1)
		end
		if x+i < w+1 then
			temp.stack[ci+1],fclr,clr=gpu.get(x+i,y+hi-1)
		end
		if tfclr ~= fclr or tclr ~= clr or i+2 > width then
			table.remove(temp.stack,ci+1)
			table.insert(temp.c,ti,ci)
			table.insert(temp.c,ti+1,tclr)
			table.insert(temp.f,ti,ci)
			table.insert(temp.f,ti+1,tfclr)
			table.insert(temp.txt,table.concat(temp.stack))
			temp.stack={}
			ci=0
			ti=ti+2
		end
		ci=ci+1
		i=i+1
	end
	data.color[hi]=temp.c
	data.fcolor[hi]=temp.f
	data.txt[hi]=temp.txt
	hi=hi+1
	ti=1
	ci=1
end
return data
end

function picture.adaptiveText(x,y,text,fclr)
local data=picture.screenshot(x,y,len(text),1)
cur=1
for i=1,#data.txt[1] do
	slen=len(data.txt[1][i])
	cur=cur+slen
	data.txt[1][i]=unicode.sub(text,cur-slen,cur-1)
	data.fcolor[1][i+i]=fclr
end
picture.draw(x,y,data)
end

function picture.draw(x,y,data)
local hi=1
if data.compressed == true then
	while hi ~= data.height+1 do
		local i=1
		local ti=1
		local ai=1
		while i ~= data.width+1 do
			if data.txt[hi][ti] == nil or data.color[hi][ai+1] == nil or data.fcolor[hi][ai+1] == nil then
				break
			else
				color(data.color[hi][ai+1])
				fcolor(data.fcolor[hi][ai+1])
				set(x+i-1,y+hi-1,data.txt[hi][ti])
			end
			i=i+data.color[hi][ai]
			ai=ai+2
			ti=ti+1
		end
		hi=hi+1
	end
else
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
end

--function picture.spic(x,y,data)
--count=1
--if data[1] == "2" then --ver 2
--	count=2
--	while count-1 ~= #data do
--		if data[count]:find("set") ~= nil then
--			p=data[count]:find("|")
--			s=data[count]:sub(p+1)
--			p=s:find("|")
--			a=s:sub(0,p-1)
--			s=s:sub(p+1)
--			p=s:find("|")
--			b=s:sub(0,p-1)
--			set(x+tonumber(a),y+tonumber(b),s:sub(p+1))
--		elseif data[count]:find("fcolor") ~= nil then
--			p=data[count]:find("|")
--			fcolor(tonumber(data[count]:sub(p+1)))
--		elseif data[count]:find("color") ~= nil then
--			p=data[count]:find("|")
--			color(tonumber(data[count]:sub(p+1)))
--		else
--			print("SPIC: UnkCommand")
--		end
--		count=count+1
--	end
--else --ver 1
--	while count-1 ~= #data do
--		if data[count]:find("set") ~= nil then
--			set(x+tonumber(data[count+1]),y+tonumber(data[count+2]),data[count+3])
--			count=count+3
--		elseif data[count]:find("fcolor") ~= nil then
--			fcolor(tonumber(data[count+1]))
--			count=count+1
--		elseif data[count]:find("color") ~= nil then
--			color(tonumber(data[count+1]))
--			count=count+1
--		else
--			print("SPIC: UnkCommand")
--		end
--		count=count+1
--	end
--end
--end

--function picture.screenshot(x,y,width,height)
--local data={width=width,height=height,color={},fcolor={},txt={}}
--hi=1
--while hi ~= height+1 do
--	i=1
--	temp={txt={},c={},f={}}
--	while i ~= width+1 do
--		temp.txt[i],temp.f[i],temp.c[i]=gpu.get(x+i-1,y+hi-1)
--		i=i+1
--	end
--	data.color[hi]=temp.c
--	data.fcolor[hi]=temp.f
--	data.txt[hi]=temp.txt
--	hi=hi+1
--end
--return data
--end

function picture.spic(x,y,file)
local count=1
local data={width=1,height=1,color={},fcolor={},txt={}}
if file[1] == "2" then--ver 2
	count=2
	while count-1 ~= #file do
		if file[count]:find("set") ~= nil then
			p=file[count]:find("|")
			s=file[count]:sub(p+1)
			p=s:find("|")
			a=s:sub(0,p-1)
			s=s:sub(p+1)
			p=s:find("|")
			b=s:sub(0,p-1)
			set(x+tonumber(a),y+tonumber(b),s:sub(p+1))
		elseif file[count]:find("fcolor") ~= nil then
			p=file[count]:find("|")
			fcolor(tonumber(file[count]:sub(p+1)))
		elseif file[count]:find("color") ~= nil then
			p=file[count]:find("|")
			color(tonumber(file[count]:sub(p+1)))
		else
			print("SPIC: UnkCommand")
		end
		count=count+1
	end
else--ver 1
	while count-1 ~= #data do
		if file[count]:find("set") ~= nil then
			set(x+tonumber(file[count+1]),y+tonumber(file[count+2]),file[count+3])
			count=count+3
		elseif file[count]:find("fcolor") ~= nil then
			fcolor(tonumber(file[count+1]))
			count=count+1
		elseif file[count]:find("color") ~= nil then
			color(tonumber(file[count+1]))
			count=count+1
		else
			print("SPIC: UnkCommand")
		end
		count=count+1
	end
end
end

function picture.HEXtoRGB(clr)
clr=math.ceil(clr)
local rr=bit32.rshift(clr,16)
local gg=bit32.rshift(bit32.band(clr,0x00ff00),8)
local bb=bit32.band(clr,0x0000ff)
return rr,gg,bb
end

return picture