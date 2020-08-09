local desktop = {}
local fs = require("filesystem")
local gpu = require("component").gpu
local term = require("term")
local icons = require("/fos/icons")
local debug = require("/fos/debug")

function desktop.sysBackground( ... )
w, h = gpu.getResolution();
gpu.setBackground(0x0069ff)
gpu.fill(1, h, w, 1, " ")
gpu.set(1, h, "⡯")
gpu.setBackground(0x2b2b2b)
gpu.fill(1, 1, w, h-1, " ")
term.setCursor(1, 1)
end

function desktop.files(path)
  filesname = {}
  i = 1
  for file in fs.list(path) do
  table.insert(filesname, i, file)
  i = i+1
  end
  return filesname
end

function desktop.workplace(filesname, path)
  w, h = gpu.getResolution();
wf = 0 --начало имени файла
hf = 8 --начало имени файла
wi = 0 --координаты иконок
hi = 0 --координаты иконок
i = 0 --счётчик

while i ~= #filesname do
  i = i+1

  if wf+12 >= w then
  
    wf = 0
    hf = hf+7
    wi = 0
    hi = hf-5

  end
gpu.fill(wf+1,hf, w, 1, " ")
wf = wf+3
  
  filename = fs.name(filesname[i])
  gpu.set(wf+1, hf, filename)
  delay = 0
  ifx = wf
  wf = wf+8
  wi = wf-7
  hi = hf-5

  p = fs.concat(path, filesname[i])
  dir = fs.isDirectory(p)

  if dir ~= false then
    icons.folder(wi, hi)
  elseif string.find(filename, "Settings.lua", _, true) ~= nil then
    icons.settings(wi, hi)
  elseif string.find(filename,".lua", _, true) ~= nil then
    icons.lua(wi, hi)
  elseif string.find(filename, ".lang", _, true) ~= nil then
    icons.lang(wi, hi)
  elseif string.find(filename, ".help", _, true) ~= nil then
    icons.help(wi, hi)
  elseif string.find(filename, ".cfg", _, true) ~= nil then
    icons.cfg(wi,hi)
  else
    icons.unkFile(wi, hi)
  end

  gpu.fill(wf+1, hf,w,1," ")

  if hf+7 > h and wf >= w-10 then
    desktop.error()
  end
end
end --конец функции

function desktop.error(...)
gpu.setBackground(0xFF0000)
gpu.set(w, h-1, "!")
gpu.setBackground(0x2b2b2b)
end

function desktop.createButtons(filesname, sett, x, y)
  gpu.setBackground(0x00ff00)
  cords = {
    x = {},
    y = {}
  }
  wb = 3
  hb = 2
  i = 0 --счётчик местоположения
  c = 1 --счётчик таблицы
  while i ~= #filesname do
    table.insert(cords.x, c, wb)
    table.insert(cords.x, c+1, wb+9 )
    table.insert(cords.y, c, hb )
    table.insert(cords.y, c+1, hb+6 )
    if sett[2] == "true" then
      gpu.fill(cords.x[c], cords.y[c], 10, 7, " ")
    end
    c = c+2
    wb = wb+11
    i = i+1
    if wb >= w-8 then
      wb = 3
      hb = hb+7
    end
  end
gpu.setBackground(0x2b2b2b)
return cords
end

function desktop.pressButton(cords, filesname, x, y)
  i = 1
  c = 1
  a = 0 --счётик файла
  --print(debug.tableprint(cords))
  while c-1 ~= #cords.x do
    if x >= cords.x[c] and x <= cords.x[c+1] and y >= cords.y[c] and y <= cords.y[c+1] then
      gpu.setBackground(0x7a7a7a)
      gpu.fill(cords.x[c], cords.y[c], 10, 7, " ")
      gpu.setBackground(0x2b2b2b)
      a = i
    end
    c = c+2
    i = i+1
  end
  return filesname[a]
end

return desktop