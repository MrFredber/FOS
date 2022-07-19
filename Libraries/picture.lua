local picture={}
local gpu=require("component").gpu
local w,h=gpu.getResolution()
local unicode=require("unicode")
local set=gpu.set
local color=gpu.setBackground
local fcolor=gpu.setForeground
local len=unicode.len
local file,temp,tmp

--function picture.screenshot(x,y,width,height)
--w,h=gpu.getResolution()
--	local data={compressed=true,width=width,height=height,color={},fcolor={},txt={}}
--	local hi=1
--	local ti=1
--	local ci=1
--	while hi ~= height+1 do
--		local i=1
--		temp={txt={},f={},c={},stack={}}
--		while i ~= width+1 do
--			if ci == 1 then
--				temp.stack[ci],tfclr,tclr=gpu.get(x+i-1,y+hi-1)
--			end
--			if x+i < w+1 then
--				temp.stack[ci+1],fclr,clr=gpu.get(x+i,y+hi-1)
--			end
--			if tfclr ~= fclr or tclr ~= clr or i+1 > width then
--				table.remove(temp.stack,ci+1)
--				table.insert(temp.c,ti,ci)
--				table.insert(temp.c,ti+1,tclr)
--				table.insert(temp.f,ti,ci)
--				table.insert(temp.f,ti+1,tfclr)
--				table.insert(temp.txt,table.concat(temp.stack))
--				temp.stack={}
--				ci=0
--				ti=ti+2
--			end
--			ci=ci+1
--			i=i+1
--		end
--		data.color[hi]=temp.c
--		data.fcolor[hi]=temp.f
--		data.txt[hi]=temp.txt
--		hi=hi+1
--		ti=1
--		ci=1
--	end
--return data
--end

function picture.adaptiveText(x,y,text,fclr)
data=picture.screenshot(x,y,len(text),1)
for i=1,data.width do
	data.txt[1][i]=unicode.sub(text,i,i)
	temp=bit32.rshift(data.color[1][i],16)
	if temp > 160 then temp=0 else temp=0xffffff end
	data.fcolor[1][i]=fclr or temp
end
picture.draw(x,y,data)
data=nil
end

--function picture.draw(x,y,data)
--local hi=1
--if data.compressed == true then
--	while hi ~= data.height+1 do
--		local i=1
--		local ti=1
--		local ai=1
--		while i ~= data.width+1 do
--			if data.txt[hi][ti] == nil or data.color[hi][ai+1] == nil or data.fcolor[hi][ai+1] == nil then
--				break
--			else
--				color(data.color[hi][ai+1])
--				fcolor(data.fcolor[hi][ai+1])
--				set(x+i-1,y+hi-1,data.txt[hi][ti])
--			end
--			i=i+data.color[hi][ai]
--			ai=ai+2
--			ti=ti+1
--		end
--		hi=hi+1
--	end
--else
--	while hi ~= data.height+1 do
--		i=1
--		while i ~= data.width+1 do 
--			color(data.color[hi][i])
--			fcolor(data.fcolor[hi][i])
--			set(x+i-1,y+hi-1,data.txt[hi][i])
--			i=i+1
--		end
--		hi=hi+1
--	end
--end
--end

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
for hi=1,data.height do
temp={data.txt[hi][1]}--text buffer
tmp=1
	for i=1,data.width do
		if data.color[hi][i] == data.color[hi][i+1] and data.fcolor[hi][i] == data.fcolor[hi][i+1] then
			table.insert(temp,data.txt[hi][i+1])
		else
			if #temp == 0 then
				temp=data.txt[hi][i]
			else
				temp=table.concat(temp,"")
			end
			if data.color[hi][i] == "n" and data.fcolor[hi][i] == "n" then
			elseif data.color[hi][i] == "n" then
				picture.adaptiveText(x+tmp-1,y+hi-1,temp,data.fcolor[hi][i])
			else
				color(data.color[hi][i])
				fcolor(data.fcolor[hi][i])
				set(x+tmp-1,y+hi-1,temp)
			end
			temp={data.txt[hi][i+1]}
			tmp=i+1
		end
	end
end
end

function picture.decompress(data)
temp={width=data.width,height=data.height,color={},fcolor={},txt={}}
for hi=1,data.height do
	tmp={color={},fcolor={},txt={}}
	for i=1,#data.color[hi]/2 do
	temp1=1
		for a=1,data.color[hi][i+i-1] do
			table.insert(tmp.color,data.color[hi][i+i])
			table.insert(tmp.fcolor,data.fcolor[hi][i+i])
			table.insert(tmp.txt,unicode.sub(data.txt[hi][i],temp1,temp1))
			temp1=temp1+1
		end
	end
	temp.color[hi]=tmp.color
	temp.fcolor[hi]=tmp.fcolor
	temp.txt[hi]=tmp.txt
end
return temp
end


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