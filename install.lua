if fs.exists("downloader.lua") then
    fs.delete("downloader.lua")
end

fs.open("downloader.lua", "w")
fs.write(http.get("https://raw.githubusercontent.com/PvlvYT/computercraft/main/downloader.lua#", {["Cache-Control"] = "no-cache"}).readAll())
fs.close()