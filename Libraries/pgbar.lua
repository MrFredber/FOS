local pgbar = {}
local gpu = require("component").gpu
local term = require("term")
local a = 0.25

function pgbar.bar(x, y, procent)

w, h = gpu.getResolution();

gpu.setForeground(0x777777)
gpu.set(x, y, "-------------------------")
gpu.setForeground(0x00bf00)
  term.write(x+11, y+1, procent)
 term.write(x+14, y+1, "%")

b = a*procent
c = math.floor(b)
d = 0

while d < c do

gpu.set(x+d, y, "-")
d = d+1

end
 
end

return pgbar
