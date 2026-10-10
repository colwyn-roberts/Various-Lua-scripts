local modem = peripheral.wrap("left")
local monitor = peripheral.wrap("right")
modem.open(48736)

local targets = "Squid_Pig"
local targetInfo = {}
monitor.setTextScale(1)
monitor.setTextColor(colors.lime)
monitor.setBackgroundColor(colors.black)
monitor.clear()
local i = 0

function tablelength(T)
    local count = 0
    for _ in pairs(T) do 
        count = count + 1 
        sleep(0.001)
    end
    return count
end

function printPlayerInfo(playerName,column)
    monitor.setTextScale(1)

    --name of player
    monitor.setCursorPos(1,column)
    monitor.setBackgroundColor(colors.blue)
    monitor.setTextColor(colors.black)
    monitor.write(playerName.."                              ")
    monitor.setBackgroundColor(colors.black)
    --makes sure they are online
    if message == (playerName.." is Offline") then
        monitor.setCursorPos(1,column+2)
        monitor.setBackgroundColor(colors.black)
        monitor.setTextColor(colors.red)
        monitor.setTextScale(1)
        monitor.write("Offline")
    elseif message == (playerName.." is out of Range") then
        monitor.setCursorPos(1,column+2)
        monitor.setBackgroundColor(colors.black)
        monitor.setTextColor(colors.red)
        monitor.setTextScale(1)
        monitor.write("Out of Range")
    else
        if message.name == playerName then 
            targetInfo = message
        else
            return nil
        end
        --dimension
        monitor.setCursorPos(1,column+1)
        monitor.setBackgroundColor(colors.black)
        monitor.setTextColor(colors.white)
        if targetInfo.dimension == "minecraft:overworld" then
            monitor.setTextColor(colors.lime)
            monitor.write("Overworld")
        elseif targetInfo.dimension == "minecraft:nether" then
            monitor.setTextColor(colors.red)
            monitor.write("Nether")
        elseif targetInfo.dimension == "minecraft:end" then
            monitor.setTextColor(colors.yellow)
            monitor.write("End")
        else
            monitor.write("unknown")
        end
        monitor.setTextColor(colors.white)

        --coords
        monitor.setCursorPos(1,column+2)
        monitor.write("  X: ")
        monitor.setTextColor(colors.purple)
        monitor.write(math.floor(targetInfo.x))
        monitor.setTextColor(colors.white)

        monitor.setCursorPos(1,column+3)
        monitor.write("  Z: ")
        monitor.setTextColor(colors.purple)
        monitor.write(math.floor(targetInfo.z))
        monitor.setTextColor(colors.white)

        monitor.setCursorPos(1,column+4)
        monitor.write("  Y: ")
        monitor.setTextColor(colors.purple)
        monitor.write(math.floor(targetInfo.y))
        monitor.setTextColor(colors.white)

        --bed coords
        monitor.setCursorPos(1,column+5)
        if targetInfo.respawnPosition.x == nil then
            monitor.write(" No Bed Found")
        else
            monitor.write(" Bed Position")
            monitor.setCursorPos(1,column+6)
            monitor.write("   X: ")
            monitor.setTextColor(colors.purple)
            monitor.write(math.floor(targetInfo.respawnPosition.x))
            monitor.setTextColor(colors.white)

            monitor.setCursorPos(1,column+7)
            monitor.write("   Z: ")
            monitor.setTextColor(colors.purple)
            monitor.write(math.floor(targetInfo.respawnPosition.z))
            monitor.setTextColor(colors.white)

            monitor.setCursorPos(1,column+8)
            monitor.write("   Y: ")
            monitor.setTextColor(colors.purple)
            monitor.write(math.floor(targetInfo.respawnPosition.y))
            monitor.setTextColor(colors.white)
        end

        --current hp
        monitor.setCursorPos(1,column+9)
        monitor.write(" Health: ")
        if targetInfo.health > 14 then
            monitor.setTextColor(colors.lime)
        elseif targetInfo.health > 6 then
            monitor.setTextColor(colors.yellow)
        else
            monitor.setTextColor(colors.red)
        end
        monitor.write(targetInfo.health)
    end
end

statusConfirm = 0

while 1 do
    event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
    if (message.name == targets) then
        statusConfirm = 0
        monitor.clear()
        printPlayerInfo(targets,1)
    elseif (message == targets.." is Offline") or (message == targets.." is out of Range") then
        if statusConfirm > 5 then
            monitor.clear()
            printPlayerInfo(targets,1)
        else
            statusConfirm = statusConfirm + 1
        end
    end
    i = 0
    sleep(0.1)
end