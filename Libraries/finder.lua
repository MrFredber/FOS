finder={}
local fs=require("filesystem")
function finder.files(path)
filesname={}
for file in fs.list(path) do table.insert(filesname,file) end
table.sort(filesname)
return filesname end
return finder