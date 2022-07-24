local gitDownloadablesPath = "https://raw.githubusercontent.com/PvlvYT/computercraft/main/downloadables/"
local gitDownloadablesApi = "https://api.github.com/repos/PvlvYT/computercraft/contents/downloadables"

local function clr()
    term.clear()
    term.setCursorPos(1,1)
end

local function resetCol()
    term.setTextColor(colors.white)
    term.setBackgroundColor(colors.black)
end

local function setCol(txtC, bgC)
    if txtC then
        term.setTextColor(txtC)
    end
    if bgC then
        term.setBackgroundColor(bgC)
    end
end

local function strSplit (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

local function downloadFile(path, saveAs)
    local response = http.get(gitDownloadablesPath .. path, {["Cache-Control"] = "no-cache"})

    if not response then
        return false
    end
    if fs.exists(saveAs) then
        fs.delete(saveAs)
    end

    local new = fs.open(saveAs, "w")
    new.write(response.readAll())
    new.close()

    return true
end

local commands = {}

commands.download = {
    usage = "<programName> <saveAs>";
    desc = "Download a program";
    exec = function(args)
        local progName = args[1] or ""
        local saveAs = args[2] or "pvlv_downloaded"

        progName = progName:gsub(".lua", "")
        progName = progName .. ".lua"
        saveAs = saveAs:gsub(".lua", "")
        saveAs = saveAs .. ".lua"

        if fs.exists(saveAs) then
            setCol(colors.black, colors.red)
            write('Path "' .. saveAs .. '" already exists, type YES to proceed: ')
            resetCol()
            local proc = read():lower()
            if proc ~= "yes" then
                print("Aborted")
                return
            end
            print("Overwrite confirmed")
        end

        print("Starting download")
        local success = downloadFile(progName, saveAs)
        if success then
            setCol(colors.black, colors.green)
            print("Download successful")
            resetCol()
            print('Saved as "' .. saveAs .. '"')
        else
            setCol(colors.black, colors.red)
            print("Download failed")
            resetCol()
            print("Is the program name correct?")
        end
    end;
}

local progList = {"chat.lua"}
commands.list = {
    desc = "List programs";
    exec = function(args)
        setCol(colors.blue)
        print("Note: this list might not be completely up-to-date")
        print("You can see the up-to-date list here:")
        print("https://github.com/PvlvYT/computercraft/tree/main/downloadables")
        setCol(colors.lightBlue)
        for _, n in ipairs(progList) do
            print(n)
        end
        resetCol()
    end;
}

commands.exit = {
    desc = "Exit the downloader";
    exec = function(args) end;
}

resetCol()
clr()
setCol(colors.blue)

print("Welcome to Pvlv's program downloader")
print("Available commands:")
resetCol()

for name, info in pairs(commands) do
    setCol(colors.lightBlue)

    write(name)
    if info.usage then
        write(" " .. info.usage)
    end
    
    resetCol()

    if info.desc then
        write(" " .. info.desc)
    end

    local _,y = term.getCursorPos()
    term.setCursorPos(1, y+1)
end

local _,y = term.getCursorPos()
y = y + 1
term.setCursorPos(1, y)

local cmdRaw
local cmd
local args
while true do
    setCol(colors.blue)
    write("> ")
    resetCol()

    cmdRaw = read()
    cmd = strSplit(cmdRaw:lower(), "%s")[1]
    args = strSplit(cmdRaw:sub(#cmd+1))
    if commands[cmd] then
        break
    end

    term.setCursorPos(1, y)
    term.clearLine()
    setCol(colors.red)
    write("Invalid command")
    sleep(2)
    resetCol()
    term.setCursorPos(1,y)
    term.clearLine()
end

clr()
setCol(colors.blue)
write("> ")
resetCol()
print(cmdRaw)

commands[cmd].exec(args)