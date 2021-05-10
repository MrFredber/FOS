local r=require
local io=r("io")
local os=r("os")
local gpu=r("component").gpu
local args={...}

i=1
while i-1 ~= #args do
if args[i] == "/fixboot" then
	os.execute("wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/FOS/boot.lua /lib/core/boot.lua")
elseif args[i] == "/fixlangcfg" then
	local file=io.open("/fos/system/lang.cfg","w")
	file:write("english.lang")
	file:close()
elseif args[i] == "/fixusercfg" then
	local file=io.open("/fos/system/user.cfg","w")
	file:write("User\n\n0")
	file:close()
elseif args[i] == "/fixcompcfg" then
	local w,h=gpu.maxResolution()
	local file=io.open("/fos/system/comp.cfg","w")
	file:write("0\n"..w..","..h)
	file:close()
elseif args[i] == "/fixlang" then
	os.execute("wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Language/fos/english.lang /fos/lang/fos/english.lang")
elseif args[i] == "/fixautocfg" then
	local file=io.open("/fos/system/auto.cfg","w")
	file:write("")
	file:close()
else
	print("This file can repair important files for system operating")
end
i=i+1
end