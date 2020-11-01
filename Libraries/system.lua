local system = {}
local fs = require("filesystem")
local gpu = require("component").gpu
local term = require("term")
local icons = require("/fos/icons")
local debug = require("/fos/debug")
local io = require("io")

function system.drawMenu(lang, sett)
  i = 1
  smax = 0
  while i ~= 4 do
    slen = string.len(lang[i])
    if slen > smax then
      smax = slen
    end
    i = i+1
  end 
  if sett[1] == "russian.lang" then
    smax = smax/2
  end
  gpu.setBackground(0x009400)
  gpu.fill(1, h-4, smax, 1, " ")
  offset = 0
  slen = string.len(lang[1])
  if sett[1] == "russian.lang" then
    slen = slen/2
  end
  if slen <= smax-1 then
    div = slen/2
    offset = smax/2-div
  end
  gpu.set(1+offset, h-4, lang[1])
  gpu.setBackground(0x0000ff)
  gpu.fill(1, h-3, smax, 1, " ")
  offset = 0
  slen = string.len(lang[4])
  if sett[1] == "russian.lang" then
    slen = slen/2
  end
  if slen <= smax-1 then
    div = slen/2
    offset = smax/2-div
  end
  gpu.set(1+offset, h-3, lang[4])
  gpu.setBackground(0xb40000)
  gpu.fill(1, h-2, smax, 1, " ")
  offset = 0
  slen = string.len(lang[2])
  if sett[1] == "russian.lang" then
    slen = slen/2
  end
  if slen <= smax-1 then
    div = slen/2
    offset = smax/2-div
  end
  gpu.set(1+offset, h-2, lang[2])
  gpu.setBackground(0xffb400)
  gpu.fill(1, h-1, smax, 1, " ")
  offset = 0
  slen = string.len(lang[3])
  if sett[1] == "russian.lang" then
    slen = slen/2
  end
  if slen <= smax-1 then
    div = slen/2
    offset = smax/2-div
  end
  gpu.set(1+offset, h-1, lang[3])
  return smax
end

function system.background()
w, h = gpu.getResolution();
gpu.setBackground(0x0069ff)
gpu.setForeground(0xffffff)
gpu.fill(1, h, w, 1, " ")
gpu.set(1, h, "⡯")
gpu.setBackground(0x2b2b2b)
gpu.fill(1, 1, w, h-1, " ")
term.setCursor(1, 1)
end

function system.workplace(filesname, path, lang)
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
  
  filename = fs.name(filesname[i])
  if string.find(filename, "Settings.lua", _, true) ~= nil then
    gpu.set(wf+4, hf, lang[9])
  else
    gpu.set(wf+4, hf, string.sub(filename, 1,8))
  end
  wf = wf+11
  wi = wf-7
  hi = hf-5

  p = fs.concat(path, filesname[i])
  dir = fs.isDirectory(p)

  if string.find(filesname[i], ".app", _, true) ~= nil then
    iconfile = io.open(fs.concat(path, filesname[i]).."/icon.spic", "r")
    icondata = {}
    for var in iconfile:lines() do
      table.insert(icondata, var)
    end
    icons.spic(icondata, wi, hi)
  elseif dir ~= false then
    icons.folder(wi, hi)
  elseif string.find(filesname[i],".lua", _, true) ~= nil then
    icons.lua(wi, hi)
  elseif string.find(filesname[i], ".lang", _, true) ~= nil then
    icons.lang(wi, hi)
  elseif string.find(filesname[i], ".man", _, true) ~= nil then
    icons.man(wi, hi)
  elseif string.find(filesname[i], ".cfg", _, true) ~= nil then
    icons.cfg(wi,hi)
  elseif string.find(filesname[i], ".txt", _, true) ~= nil then
    icons.txt(wi,hi)
  else
    icons.unkFile(wi, hi)
  end
  gpu.setBackground(0x2b2b2b)
  gpu.setForeground(0xffffff)

  if hf+7 >= h then
    system.error(lang)
  end
end
end --конец функции

function system.createButtons(filesname, sett, x, y)
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

function system.pressButton(cords, filesname, x, y)
  i = 1
  c = 1
  a = 0 --счётик файла
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
  return filesname[a], a
end

function system.updAfterPress(filename, a, lang)
  i = 1
  w, h = gpu.getResolution()
  local wf = 0
  hf = 8
  hi = 3

  if a ~= 0 then
    while i ~= a do
      if wf+12 >= w then
        wf = 0
        hf = hf+7
        hi = hf-5
      end
      wf = wf+11
      wi = wf+4
      i = i+1
    end
    gpu.setBackground(0x7a7a7a)
    if string.find(filename, "Settings.lua", _, true) ~= nil then
      gpu.set(wf+4, hf, lang[9])
    else
      gpu.set(wf+4, hf, string.sub(filename, 1,8))
    end
    if dir ~= false then
      icons.folder(wi, hi)
    elseif string.find(filename,".lua", _, true) ~= nil then
      icons.lua(wi, hi)
    elseif string.find(filename, ".lang", _, true) ~= nil then
      icons.lang(wi, hi)
    elseif string.find(filename, ".man", _, true) ~= nil then
      icons.man(wi, hi)
    elseif string.find(filename, ".cfg", _, true) ~= nil then
      icons.cfg(wi,hi)
    elseif string.find(filename, ".txt", _, true) ~= nil then
      icons.txt(wi,hi)
    else
      icons.unkFile(wi, hi)
    end
    gpu.setBackground(0x2b2b2b)
    gpu.setForeground(0xffffff)
  end
end

function system.bsod(error)
w, h = gpu.getResolution()
gpu.setBackground(0x0000ff)
gpu.fill(1, 1, w, h, " ")
gpu.set(1, 1, "A Problem Has been detected and FOS closed the programm")
gpu.set(1, 2, "Technical Information:")
end
function system.error(lang)
gpu.setBackground(0xFF0000)
len = string.len(lang[10])
gpu.set(w-len+1, h-1, lang[10])
gpu.setBackground(0x2b2b2b)
end
return system