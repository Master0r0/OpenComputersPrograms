local comp = require("component")
local fs = require("filesystem")
local shell = require("shell")

folderLoc = shell.getWorkingDirectory()

component = ...

if not fs.isDirectory(folderLoc.."/functions") then
    fs.makeDirectory(folderLoc.."/functions")
end
if component then
    local dir = folderLoc.."/functions/"..component..".txt"
    writeStream, err = fs.open(dir,"wb")
    if err then
        print(err)
    else
        for i,k in pairs(comp[component]) do
            outString = string.format("%s():%s\n",i,k)
            writeStream:write(outString)
        end
        writeStream:close()
    end
else
    print("Usage: outputFunctions.lua componentName")
end
