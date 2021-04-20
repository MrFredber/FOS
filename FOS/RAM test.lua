local r=require
r("term").clear()
r("os").execute("free")
r("event").pull("touch")