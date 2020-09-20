local gpu = require("component").gpu
local io = require("io")
local os = require("os")
local term = require("term")
sett = {}
lang = {}
settfile = io.open("/fos/system/settings.cfg", "r")

for var in settfile:lines() do
	table.insert(sett, var)
end
settfile:close()
langfile = io.open("/fos/lang/settings/"..sett[1], "r")
for var in langfile:lines() do
	table.insert(lang, var)
end
langfile:close()
gpu.setBackground(0x000000)
gpu.setForeground(0xffffff)
term.clear()
print(lang[3]) --do changes
print("1 - " .. lang[1])
print(lang[4] .. " - " .. lang[2])
print(">")
term.setCursor(2,4)
local dochange = io.read()

--Main

if dochange == "1" then
	print(lang[5]) --lang
	print("1 - " .. lang[6])
	print("2 - " .. lang[7])
	print(lang[4] .. " - " .. lang[9])
	print(">")
	term.setCursor(2, 9)
	langchoice = io.read()
	if langchoice == "1" then
		language = "english.lang"
	elseif langchoice == "2" then
		language = "russian.lang"
	else
		language = sett[1]
	end
	print(lang[8]) --icon buttons
	print("1 - " .. lang[1])
	print("2 - " .. lang[2])
	print(lang[4] .. " - " .. lang[9])
	print(">")
	term.setCursor(2, 14)
	iconbutton = io.read()
	if iconbutton == "1" then
		iconbuttons = "true"
	elseif iconbutton == "2" then
		iconbuttons = "false"
	else
		iconbuttons = sett[2]
	end
	settfile = io.open("/fos/system/settings.cfg", "w")
	settfile:write(language .. "\n" .. iconbuttons)
	settfile:close()
	require("computer").shutdown(true)
else
	os.exit()
end