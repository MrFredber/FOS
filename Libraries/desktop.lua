local desktop = {}
local fs = require("filesystem")
local com = require("component")
local gpu = com.gpu
local term = require("term")
stop = 0

local icons = require("/fos/icons")

function desktop.workplace(...)

w, h = gpu.getResolution();
wf = 0
hf = 8
delay = 0
delaymax = 2
wi = 0
hi = 0

gpu.setBackground(0x2b2b2b)
gpu.fill(1, 1, w, h-1, " ")
gpu.setBackground(0x0069ff)
gpu.fill(1, h, w, h, " ")
gpu.set(1, h, "F")

gpu.setBackground(0x2b2b2b)
term.setCursor(1, 1)


path = "/fos"
for file in fs.list(path) do

--if stop == 0 then

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
  elseif string.find(filename,".lua") ~= nil then
  icons.lua(wi, hi)
  else
  icons.unkFile(wi, hi)
  end

  if wf > w-7 then
  
  wf = 0
  hf = hf+7
  wi = 0
  hi = hf-5

end
--end

while wf == w do
gpu.set(wf, hf, " ")
wf = wf+1
end

if hf+7 > h then
  gpu.setBackground(0xff0000)
  gpu.set(w, h-1, "!")
  gpu.setBackground(0x2b2b2b)
  stop = 1
end
end 
end

return desktop