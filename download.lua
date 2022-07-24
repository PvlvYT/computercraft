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

local commands = {}

commands.list = {
    desc = "Show all downloadable programs";
    exec = function()
        print("list lmfao!")
    end;
}

commands.download = {
    usage = "<programName>";
    desc = "Download a program from Pvlv's GitHub";
    exec = function()
        print("downlaod lol")
    end;
}

resetCol()
clr()
setCol(colors.yellow)

print("Welcome to Pvlv's program downloader")
print("Available Commands:")
resetCol()
for name, info in pairs(commands) do
    setCol(colors.lightBlue)

    write(name)
    if info.usage then
        write(" ", info.usage)
    end
    
    resetCol()

    if info.desc then
        write(" ", info.desc)
    end
end