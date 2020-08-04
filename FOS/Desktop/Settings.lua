local com = require("component")
local gpu = com.gpu
local io = require("io")
local w, h = gpu.getResolution()
local set = gpu.set
local color = gpu.setBackground
local os = require("os")
local fill = gpu.fill
local event = require("event")
local cords = {
	x = {1, 10, 1, 10, 1, 10},
	y = {1, 3, 4, 6, 7, 9}
}

function draw(x, y)
	sett = {}
	file = io.open("/fos/system/settings.cfg", "r")
	for var in file:lines() do
		table.insert(sett, var)
	end
	color(0x424242)
	fill(x, y, 10, 9, " ")

end

function select(x, y, xp, yp, cords)
	c = 1
	i = 1
	a = 0
	while c-1 ~= #cords do
		if xp >= cords.x[c] and xp <= cords.x[c+1] and yp >= cords.y[c] and yp <= cords.y[c+1] then
			gpu.setBackground(0x7a7a7a)
     		gpu.fill(cords.x[c], cords.y[c], 10, 3, " ")
     		gpu.setBackground(0x424242)
			a = i
		end
		c = c+2
    	i = i+1
    end
	set(x+1, y+1, "Language")
	set(x+2, y+4, "debug")
	set(x+2, y+7, "Other")
end

draw(1, 1)
while true do
	local _, _, xp, yp = event.pull("touch")
	if xp ~= nil and yp ~= nil then
		select(1, 1, xp, yp, cords)
	end
end
select(1, 1)

os.exit()