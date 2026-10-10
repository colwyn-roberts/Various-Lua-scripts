local playerDetector = peripheral.find("playerDetector")
local monitor = peripheral.wrap("right")
local targets = {"boxygame123"}
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
local listSize = tablelength(targets)

function printPlayerInfo(playerName,column)
    targetInfo = playerDetector.getPlayerPos(playerName)
    monitor.setTextScale(1)

    --name of player
    monitor.setCursorPos(1,column)
    monitor.setBackgroundColor(colors.blue)
    monitor.setTextColor(colors.black)
    monitor.write(playerName.."                              ")

    --makes sure they are online
    if targetInfo.x == nil then
        monitor.setCursorPos(1,column+2)
        monitor.setBackgroundColor(colors.black)
        monitor.setTextColor(colors.red)
        monitor.setTextScale(1)
        monitor.write("Offline")
    else
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

while 1 do 
    while i < listSize do
        i = i + 1
        printPlayerInfo(targets[i],((i-1)*10)+1)
    end
    i = 0
    sleep(0.1)
    monitor.clear()
end