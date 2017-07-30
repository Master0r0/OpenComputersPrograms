local comp = require("component")
local fs = require("filesystem")

component = ...

local dir = "home/functions/"..component..".txt"
writeStream, err = fs.open(dir,"wb")
print(err)
for i,k in pairs(comp[component]) do
    outString = string.format("%s():%s\n",i,k)
    writeStream:write(outString)
end
writeStream:close()
