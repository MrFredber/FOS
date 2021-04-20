finder={}
local fs=require("filesystem")
function finder.files(path)
filesname={}
i=1
for file in fs.list(path) do table.insert(filesname,i,file)
i=i+1 end
table.sort(filesname)
return filesname end
return finder