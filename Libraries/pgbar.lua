local pgbar = {}
local gpu = require("component").gpu
local term = require("term")
local a = 0.25

function pgbar.bar(x, y, w, procent)

w, h = gpu.getResolution();

gpu.setForeground(0x777777)
wsave = 0
while wsave ~= w+1
gpu.set(x, y, "-")
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
 
end

return pgbar