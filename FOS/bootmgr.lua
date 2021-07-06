local r=require
local io=r("io")
local os=r("os")
local gpu=r("component").gpu
local unicode=r("unicode")
local args={...}
local reg={}
local file,a=0,0
if #args == 0 then
	print("Usage: bootmgr <argument1> [<argument2> [...]]")
	os.exit()
end
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

i=1
while i-1 ~= #args do
if args[i] == "/fixboot" then
	os.execute("wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/FOS/boot.lua /lib/core/boot.lua")
elseif args[i] == "/fixlangcfg" then
	reg.lang="english.lang"
	a=1
elseif args[i] == "/fixusercfg" then
	reg.username="User"
	reg.passwordProtection=0
	reg.password=0
	a=1
elseif args[i] == "/fixcompcfg" then
	local w,h=gpu.maxResolution()
	reg.powerSafe=0
	reg.width=w
	reg.height=h
	a=1
elseif args[i] == "/fixlang" then
	os.execute("wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Language/fos/english.lang /fos/lang/fos/english.lang")
elseif args[i] == "/fixautocfg" then
	file=io.open("/fos/system/auto.cfg","w")
	file:write("")
	file:close()
elseif args[i] == "/fixregistry" then
	reg={}
	reg.lang="english.lang"
	reg.username="User"
	reg.passwordProtection=0
	reg.password=0
	local w,h=gpu.maxResolution()
	reg.powerSafe=0
	reg.width=w
	reg.height=h
	reg.ver="a7"
	reg.userColor="0x0094ff"
	reg.gpu=tostring(gpu.maxDepth())
	a=1
else
	print("Unknown argument: "..args[i])
end
i=i+1
end
if a == 1 then
file=io.open("/fos/system/registry","w")
for k in pairs(reg) do
	file:write(k.."="..reg[k].."\n")
end
end
file:close()