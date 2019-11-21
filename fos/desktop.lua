local desktop = {}
local fs = require("filesystem")
local com = require("component")
local gpu = com.gpu

local wd = 0
local hd = 3
local delaymax = 2
local delay = 0
local w, h = gpu.getResolution();

function desktop.createdesktop(...)

for file in fs.list("/fos") do

  while delay < delaymax+1 do

    gpu.set(wd+1, hd, " ")
    wd = wd+1
    delay = delay+1

  end  
  
  gpu.set(wd+1, hd, file)
  delay = 0
  wd = wd+9
  
  if wd == w  then
  
  wd = 0
  hd = hd+2

  end
  if wd == w-1 then

  wd = 0
  hd = hd+2

  end
  if wd == w-2 then

  wd = 0 
  hd = hd+2

end
end
end

return desktop