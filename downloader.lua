local gitDownloadables = "https://raw.githubusercontent.com/PvlvYT/computercraft/main/downloadables/"

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
    local response = http.get(gitDownloadables .. path, {["Cache-Control"] = "no-cache"})

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

commands.list = {
    desc = "Show all downloadable programs";
    exec = function(args)
        
    end;
} commands.list = nil

commands.download = {
    usage = "<programName>";
    desc = "Download a program from Pvlv's GitHub";
    exec = function(args)
        print("downlaod lol")
    end;
}

resetCol()
clr()
setCol(colors.blue)

print("Welcome to Pvlv's program downloader")
print("Available Commands:")
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

local cmd
local args
while true do
    setCol(colors.blue)
    write("> ")

    local cmdRaw = read()
    cmd = strSplit(cmdRaw:lower(), "%s")[1]
    args = strSplit(cmdRaw:sub(#cmd+1))
    if commands[cmd] then
        break
    end

    term.setCursorPos(1, y)
    term.clearLine()
    setCol(colors.red)
    write("Invalid Command")
    sleep(2)
    resetCol()
    term.clearLine()
end

commands[cmd].exec(args)