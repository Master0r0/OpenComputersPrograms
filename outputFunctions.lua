local comp = require("component")
local fs = require("filesystem")

component = ...
if component then
    local dir = "home/functions/"..component..".txt"
    writeStream, err = fs.open(dir,"wb")
    if err then
        print(err)
    end
    for i,k in pairs(comp[component]) do
        outString = string.format("%s():%s\n",i,k)
        writeStream:write(outString)
    end
    writeStream:close()
else
    print("Usage: outputFunctions.lua componentName")
end
