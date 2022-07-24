if fs.exists("downloader.lua") then
    fs.delete("downloader.lua")
end

local f = fs.open("downloader.lua", "w")
f.write(http.get("https://raw.githubusercontent.com/PvlvYT/computercraft/main/downloader.lua#", {["Cache-Control"] = "no-cache"}).readAll())
f.close()