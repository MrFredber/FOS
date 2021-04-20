local r=require
local io=r("io")
local os=r("os")
local gpu=r("component").gpu
local args={...}

if args[1] == "/fixboot" then
	file=io.open("/home/.shrc","w")
	file:write("/fos/boot\ncd /fos")
	file:close()
elseif args[1] == "/fixlangcfg" then
	file=io.open("/fos/system/lang.cfg","w")
	file:write("english.lang")
	file:close()
elseif args[1] == "/fixusercfg" then
	file=io.open("/fos/system/user.cfg","w")
	file:write("User\n\n0")
	file:close()
elseif args[1] == "/fixcompcfg" then
	w,h=gpu.maxResolution()
	file=io.open("/fos/system/comp.cfg","w")
	file:write("0\n"..w..","..h)
	file:close()
elseif args[1] == "/fixlang" then
	os.execute("wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Language/fos/english.lang /fos/lang/fos/english.lang")
elseif args[1] == "/fixautocfg" then
	file=io.open("/fos/system/auto.cfg","w")
	file:write("")
	file:close()
elseif args[1] == "/fixall" then
	file=io.open("/home/.shrc","w")
	file:write("/fos/boot\ncd /fos")
	file:close()
	file=io.open("/fos/system/lang.cfg","w")
	file:write("english.lang")
	file:close()
	file=io.open("/fos/system/user.cfg","w")
	file:write("User\n\n0")
	file:close()
	file=io.open("/fos/system/auto.cfg","w")
	file:write("")
	file:close()
	w,h=gpu.maxResolution()
	file=io.open("/fos/system/comp.cfg","w")
	file:write("0\n"..w..","..h)
	file:close()
	os.execute("wget -fq https://raw.githubusercontent.com/MrFredber/FOS/master/Language/fos/english.lang /fos/lang/fos/english.lang")
else
	print("This file can repair important files for system operating")
end