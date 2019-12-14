local com = require("component")
local fs = require("filesystem")
local internet = com.internet
local os = require("os")
local io = require("io")
local file = io.open("/home/.shrc", w)

fs.makeDirectory("/FOS")
fs.makeDirectory("/FOS/Desktop")
fs.makeDirectory("/lib/fos")

os.execute("pastebin get -f eAaz5hSV /fos/fos.lua")
os.execute("pastebin get -f XCkhdAu3 /lib/fos/desktop.lua")
os.execute("pastebin get -f dFFawww5 /fos/bsod.lua")

io.open("/home/.shrc", w)
file:write("cd /fos")
file:write("fos/fos.lua")
file:close()

require("computer").shutdown(true)