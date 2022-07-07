finder={}
local fs=require("filesystem")
local unicode=require("unicode")
local slang,reg,user,file,a={},{},{}

function finder.unserialize(data)
temp=""
for i=1,#data do
	temp=temp..data[i]
end
data=temp
local result,reason=load("return "..data,"=data",nil,{math={huge=math.huge}})
if not result then
	return nil,reason
end
local ok,output=pcall(result)
if not ok then
	return nil,output
end
return output
end

if fs.exists("/fos/system/generalSettings.cfg") then
	file=io.open("/fos/system/generalSettings.cfg","r")
	for var in file:lines() do
		table.insert(reg,var)
	end
	file:close()
	user=finder.unserialize(reg)
end
reg={}
file=io.open("/fos/lang/shared/"..(user.lang or "english.lang"),"r")
for var in file:lines() do
	table.insert(reg,var)
end
file:close()
slang=finder.unserialize(reg)

function finder.update(fuser)
user=fuser
slang={}
file=io.open("/fos/lang/shared/"..user.lang,"r")
for var in file:lines() do
	table.insert(data,var)
end
file:close()
slang=finder.unserialize(data)
end

function finder.files(path)
filesname={}
for file in fs.list(path) do
	table.insert(filesname,file)
end
table.sort(filesname)
return filesname
end

function finder.verbalSize(a)
if a/1024 >= 1 then
	a=a/1024
	temp=slang.k..slang.b
else
	temp=slang.b
end
if a/1024 >= 1 then
	a=a/1024
	temp=slang.m..slang.b
end
a=tostring(a-a%0.01)
return a.." "..temp
end

function finder.findAll(path,result)
local result=result or {}
local list=finder.files(path)
for i=1,#list do
	if fs.isDirectory(path..list[i]) == true then
		result=finder.findAll(path..list[i],result)
	else
		table.insert(result,path..list[i])
	end
end
return result
end

local local_pairs=function(tbl)
	local mt=getmetatable(tbl)
	return(mt and mt.__pairs or pairs)(tbl)
end

function finder.serialize(value,pretty)
local kw={["and"]=true,["break"]=true,["do"]=true,["else"]=true,["elseif"]=true,["end"]=true,["false"]=true,["for"]=true,["function"]=true,["goto"]=true,["if"]=true,["in"]=true,["local"]=true,["nil"]=true,["not"]=true,["or"]=true,["repeat"]=true,["return"]=true,["then"]=true,["true"]=true,["until"]=true,["while"]=true}
local id="^[%a_][%w_]*$"
local ts={}
local result_pack={}
local function recurse(current_value,depth)
	local t=type(current_value)
	if t == "number" then
		if current_value ~= current_value then
			table.insert(result_pack,"0/0")
		elseif current_value == math.huge then
			table.insert(result_pack,"math.huge")
		elseif current_value == -math.huge then
			table.insert(result_pack,"-math.huge")
		else
			table.insert(result_pack,tostring(current_value))
		end
	elseif t == "string" then
		table.insert(result_pack,(string.format("%q",current_value):gsub("\\\n","\\n")))
	elseif
		t == "nil" or
		t == "boolean" or
		pretty and (t ~= "table" or (getmetatable(current_value) or {}).__tostring) then
		table.insert(result_pack,tostring(current_value))
	elseif t == "table" then
		if ts[current_value] then
			if pretty then
				table.insert(result_pack,"recursion")
				return
			else
				error("tables with cycles are not supported")
			end
		end
		ts[current_value]=true
		local f
		if pretty then
			local ks,sks,oks={},{},{}
			for k in local_pairs(current_value) do
				if type(k) == "number" then
					table.insert(ks,k)
				elseif type(k) == "string" then
					table.insert(sks,k)
				else
					table.insert(oks,k)
				end
			end
			table.sort(ks)
			table.sort(sks)
			for _,k in ipairs(sks) do
				table.insert(ks,k)
			end
			for _,k in ipairs(oks) do
				table.insert(ks,k)
			end
			local n=0
			f=table.pack(function()
				n=n+1
				local k=ks[n]
				if k ~= nil then
					return k,current_value[k]
				else
					return nil
				end
			end)
		else
			f=table.pack(local_pairs(current_value))
		end
		local i=1
		local first=true
		table.insert(result_pack,"{")
		for k,v in table.unpack(f) do
			if not first then
				table.insert(result_pack,",")
				if pretty then
					table.insert(result_pack,"\n" .. string.rep(" ",depth))
				end
			end
			first=nil
			local tk=type(k)
			if tk == "number" and k == i then
				i=i+1
				recurse(v,depth+1)
			else
				if tk == "string" and not kw[k] and string.match(k,id) then
					table.insert(result_pack,k)
				else
					table.insert(result_pack,"[")
					recurse(k,depth+1)
					table.insert(result_pack,"]")
				end
				table.insert(result_pack,"=")
				recurse(v,depth+1)
			end
		end
		ts[current_value]=nil
		table.insert(result_pack,"}")
	else
		error("unsupported type: "..t)
	end
end
recurse(value,1)
local result=table.concat(result_pack)
if pretty then
	local limit=type(pretty) == "number" and pretty or 10
	local truncate=0
	while limit > 0 and truncate do
		truncate=string.find(result,"\n",truncate+1,true)
		limit=limit-1
	end
	if truncate then
		return result:sub(1,truncate).."..."
	end
end
temp={}
reg=result:find(",")
temp2=1
while reg ~= nil do
	table.insert(temp,unicode.sub(result,temp2,temp2+reg-1))
	temp2=temp2+reg
	reg=unicode.sub(result,temp2):find(",")
end
table.insert(temp,unicode.sub(result,temp2))
return temp
end

function finder.ext(name)
temp={}
pos=0
for i=1,unicode.len(name) do
	if unicode.sub(name,i,i) == "." then
		pos=i
	end
	table.insert(temp,unicode.sub(name,i,i))
end
ext={}
if pos ~= 0 then
	for i=0,unicode.len(name)-pos do
		table.insert(ext,temp[pos+i])
	end
	ext=table.concat(ext,"")
end
if type(ext) == "string" then
	return ext
else
	return nil
end
end

return finder