local comp = require("computer")
local gpu = require("component").gpu
gpu.setResolution(50, 13)
local w, h = gpu.getResolution();

gpu.setBackground(0x0000ff)
gpu.fill(1, 1, w, h, " ")
gpu.set(1, 1, "A Problem Has been detected and FOS has been shut")
gpu.set(1, 2, "down to prevent damage to your computer.")
gpu.set(1, 4, "If you see this screen in first time, restart the")
gpu.set(1, 5, "computer.")
gpu.set(1, 7, "If you see this screen in second time, delete the")
gpu.set(1, 8, "last installed programm.")
gpu.set(1, 10, "If you see this screen in third time and more,")
gpu.set(1, 11, "send the report to https://clck.ru/K9Tce")
gpu.set(1, 13, "Technical Information:")

comp.beep(100, 6)
comp.shutdown(true)