local desktop = {}
local fs = require("filesystem")
local com = require("component")
local gpu = com.gpu

local icons = require("/fos/icons")

function desktop.workplace(...)

w, h = gpu.getResolution();
wf = 0
hf = 8
delay = 0
delaymax = 2
wi = 0
hi = 0

path = "/fos"
for file in fs.list(path) do

  while delay < delaymax+1 do

    gpu.set(wf+1, hf, " ")
    wf = wf+1
    delay = delay+1

  end  
  
  filename = fs.name(file)
  gpu.set(wf+1, hf, filename)
  delay = 0
  ifx = wf
  wf = wf+8
  wi = wf-7
  hi = hf-5

  p = fs.concat(path, file)
  dir = fs.isDirectory(p)

  if dir ~= false then
  icons.folder(wi, hi)
  elseif filename == "%.lua%" then
  icons.lua(wi, hi)
  else
  icons.unkFile(wi, hi)
  end

  if wf > w-7 then
  
  wf = 0
  hf = hf+7
  wi = 0
  hi = hf-4

end
end

while wf == w do
gpu.set(wf, hf, " ")
wf = wf+1
end
 
end

return desktop