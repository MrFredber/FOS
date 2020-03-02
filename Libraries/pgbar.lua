local pgbar = {}
local gpu = require("component").gpu
local term = require("term")

function pgbar.bar(x, y, width, procent)

w, h = gpu.getResolution();
 a = 0.25

gpu.setForeground(0x777777)
gpu.set(x, y, "-------------------------")
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
