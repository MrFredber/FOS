local pgbar = {}
local gpu = require("component").gpu
local term = require("term")

function pgbar.bar(x, y, w, procent)

w, h = gpu.getResolution();
 a = 100/w

gpu.setForeground(0x777777)
wsave = 0
 d = 0
while wsave < w+1 do
gpu.set(x+d, y, "-")
  d = d+1
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
