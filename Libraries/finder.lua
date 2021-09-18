finder={}
local fs=require("filesystem")
local unicode=require("unicode")
local slang,reg,file,a={},{}
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
file=io.open(fs.concat("/fos/lang/shared",reg.lang),"r")
for var in file:lines() do
	check=var:find("=")
	if check ~= nil then
		arg=unicode.sub(var,1,check-1)
		var=unicode.sub(var,check+1)
		slang[arg]=var
	else
		table.insert(slang,var)
	end
end
file:close()

function finder.files(path)
filesname={}
for file in fs.list(path) do
	table.insert(filesname,file)
end
table.sort(filesname)
return filesname
end

function finder.verbalSize(a)
if a/1024 > 1 then
	a=a/1024
	temp=slang.k..slang.b
else
	temp=slang.b
end
if a/1024 > 1 then
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

return finder