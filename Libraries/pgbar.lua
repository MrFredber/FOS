local pgbar = {}
local gpu = require("component").gpu
local term = require("term")

function pgbar.bar(x, y, width, procent)

w, h = gpu.getResolution();
gpu.setForeground(0x777777)
gpu.fill(x,y,width, 1, "-")
gpu.setForeground(0x00bf00)

a = width/100
b = a*procent
c = math.floor(b)

gpu.fill(x, y, c, 1, "-")
gpu.setForeground(0xffffff)
 
end

function pgbar.fullbar(x, y, width, procent)

w, h = gpu.getResolution();
gpu.setBackground(0x777777)
gpu.fill(x,y,width, 1, " ")
gpu.setBackground(0x00bf00)

a = w/100
b = a*procent
c = math.floor(b)
wsafe = 1
while wsafe ~= c do
	gpu.set(wsafe, y, " ")
	wsafe = wsafe+1
end

--gpu.fill(x, y, c, 1, " ")
 
end

return pgbar