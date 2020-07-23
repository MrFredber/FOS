local pgbar = {}
local gpu = require("component").gpu
local term = require("term")

function pgbar.bar(x, y, width, procent)

a = width/100

w, h = gpu.getResolution();

gpu.setForeground(0x777777)
wsave = 0
while wsave < width do
gpu.set(x+wsave, y, "-")
wsave = wsave+1
end
gpu.setForeground(0x00bf00)

b = a*procent
c = math.floor(b)
d = 0

while d < c do

gpu.set(x+d, y, "-")
d = d+1

end

gpu.setForeground(0xffffff)
 
end

return pgbar