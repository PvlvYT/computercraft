local function clr(a) a.setCursorPos(1,1) a.clear() end
clr(term)

local function getPeripheral(pType)
    clr(term)
    local found
    while true do
        term.write("Choose a " .. pType .. ": ")
        found = read()
        if peripheral.getType(found) == pType then
            break
        else
            clr(term)
            print("No " .. pType .. " with that name found")
        end
    end
    return found
end

local modemName = getPeripheral("modem")
local screenName = getPeripheral("monitor")
local screen = peripheral.wrap(screenName)
screen.setTextScale(1)

clr(term)
clr(screen)

rednet.open(modemName)

print("Starting on modem " .. modemName:upper() .. " and screen " .. screenName:upper())
print("Type a message and press enter to send:")

local lines = 0
local w,h = screen.getSize()
local termRedir = term.current()

screen.setCursorBlink(false)

local function addMessage(tag, msg, tagColor, msgColor)
    term.redirect(screen)
    
    if (not msg) or #msg < 1 then return end
    
    local oldCol = screen.getTextColor()
    if tag then
        if tagColor then
            screen.setTextColor(tagColor)
        end
        write(tag)
        screen.setTextColor(oldCol)
    end
    if msgColor then
        screen.setTextColor(msgColor)
    end
    local newL = write(msg)
    lines = lines + newL + 1
    screen.setTextColor(oldCol)
    local x,y = screen.getCursorPos()
    
    if lines >= h then
        screen.scroll(1)
        screen.setCursorPos(1,y)
    else
        screen.setCursorPos(1, y+1)
    end
    
    term.redirect(termRedir)
end

local function detectReceive()
    while true do
        local id, msg = rednet.receive()
        addMessage("[" .. tostring(id) .. "]: ", msg, colors.orange)
    end
end

local function detectSend()
    while true do
        local msg = read()
        local x,y = term.getCursorPos()
        term.setCursorPos(1, y-1)
        term.clearLine()
        
        rednet.broadcast(msg)
    
        addMessage("[YOU (" .. tostring(os.computerID()) .. ")]: ", msg, colors.blue)
    end
end

local function fail(reason)
    local oldBg = term.getBackgroundColor()
            local oldTxt = term.getTextColor()
            term.setBackgroundColor(colors.red)
            term.setTextColor(oldBg)
            print(reason)
            term.setBackgroundColor(oldBg)
            term.setTextColor(oldTxt)
            error("")
end

local function detectResize()
    while true do
        local _, side = os.pullEvent("monitor_resize")
        if side == screenName then
            fail("MONITOR RESIZED, PLEASE RESTART CHAT")
        end
    end
end

local function detectDisconnect()
    while true do
        local _, side = os.pullEvent("peripheral_detach")
        if side == screenName then
            fail("MONITOR DISCONNECTED, PLEASE RESTART CHAT")
        elseif side == modemName then
            fail("MODEM DISCONNECTED, PLEASE RESTART CHAT")
        end
    end
end

addMessage(nil, "Connected successfully")
parallel.waitForAny(detectSend, detectReceive, detectResize, detectDisconnect)
