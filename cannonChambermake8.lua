local monitor = peripheral.wrap("back")
local wiredModem = peripheral.wrap("front")
local iterations = 24

--redstone link positions --good
function mouldDeployer(state,name)
    if name == "very small" then
        wiredModem.callRemote("redstoneIntegrator_2","setOutput","back",state)
    elseif name == "small" then
        wiredModem.callRemote("redstoneIntegrator_3","setOutput","back",state)
    elseif name == "medium" then
        wiredModem.callRemote("redstoneIntegrator_4","setOutput","back",state)
    elseif name == "all" then
        wiredModem.callRemote("redstoneIntegrator_2","setOutput","back",state)
        wiredModem.callRemote("redstoneIntegrator_3","setOutput","back",state)
        wiredModem.callRemote("redstoneIntegrator_4","setOutput","back",state)
    end 
end

function castDeploy() --good
    wiredModem.callRemote("redstoneIntegrator_5","setOutput","back",false)
    sleep(0.1)
    wiredModem.callRemote("redstoneIntegrator_5","setOutput","back",true)
end

function mouldReset(state) --good
    wiredModem.callRemote("redstoneIntegrator_1","setOutput","back",state)
end

function sandDeployer(state) --good
    redstone.setOutput("right",state)
end

function castPiston(state) --good
    redstone.setOutput("top",state)
end

function boreBearing(state) --good
    wiredModem.callRemote("redstoneIntegrator_0","setOutput","left",state)
end

function drillCannon(state) --good
    redstone.setOutput("left",state) 
end

function finalRotate(state) --good
    wiredModem.callRemote("redstoneIntegrator_0","setOutput","front",state)
end

function finalPiston(state) --good
    wiredModem.callRemote("redstoneIntegrator_0","setOutput","top",state)
end

--sets redstone to default positions
function redstoneReset()

    redstone.setOutput("front",false)
    redstone.setOutput("left",false)
    redstone.setOutput("right",false)
    redstone.setOutput("back",false)
    redstone.setOutput("top",false)
    redstone.setOutput("bottom",false)

    wiredModem.callRemote("redstoneIntegrator_0","setOutput","top",false)
    wiredModem.callRemote("redstoneIntegrator_0","setOutput","top",false)
    wiredModem.callRemote("redstoneIntegrator_0","setOutput","top",false)
    wiredModem.callRemote("redstoneIntegrator_0","setOutput","top",false)
    wiredModem.callRemote("redstoneIntegrator_0","setOutput","top",false)
    wiredModem.callRemote("redstoneIntegrator_0","setOutput","top",false)

    wiredModem.callRemote("redstoneIntegrator_1","setOutput","back",true)
    wiredModem.callRemote("redstoneIntegrator_2","setOutput","back",true)
    wiredModem.callRemote("redstoneIntegrator_3","setOutput","back",true)
    wiredModem.callRemote("redstoneIntegrator_4","setOutput","back",true)
    wiredModem.callRemote("redstoneIntegrator_5","setOutput","back",true)

    mouldReset(true)
    boreBearing(true)
end

redstoneReset()
monitor.setBackgroundColor(colors.black)
monitor.setTextScale(1)
monitor.clear()
local i = 0
local castSize = "very small"
while i < iterations do

    monitor.setCursorPos(1,1)
    monitor.setBackgroundColor(colors.blue)
    monitor.setTextColor(colors.black)
    monitor.write(iterations-i.." Cannon Pieces Left                               ")
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.white)
    
    monitor.setCursorPos(1,2)
    monitor.setBackgroundColor(colors.black)
    monitor.write("Deploy Mould")

    monitor.setCursorPos(1,4)
    monitor.setBackgroundColor(colors.black)
    monitor.write("Deploy Sand")

    monitor.setCursorPos(1,6)
    monitor.setBackgroundColor(colors.black)
    monitor.write("Cast (300s)")

    monitor.setCursorPos(1,8)
    monitor.setBackgroundColor(colors.black)
    monitor.write("Drill Cannon")

    monitor.setCursorPos(1,10)
    monitor.setBackgroundColor(colors.black)
    monitor.write("Place Cannon Piece")

    --places and removes cast
    monitor.setTextColor(colors.black)
    monitor.setCursorPos(1,2)
    monitor.setBackgroundColor(colors.yellow)
    monitor.write("Deploy Mould")
        mouldReset(false)
        sleep(0.1)
        mouldReset(true)
        sleep(0.1)
        mouldDeployer(false,castSize)
        sleep(0.1)
        mouldDeployer(true,castSize)
        sleep(1)
        castDeploy()
    monitor.setCursorPos(1,2)
    monitor.setBackgroundColor(colors.lime)
    monitor.write("Deploy Mould")
    monitor.setCursorPos(1,4)
    monitor.setBackgroundColor(colors.yellow)
    monitor.write("Deploy Sand")
        sleep(0.1)
        sandDeployer(true)
        sleep(0.5)
        sandDeployer(false)
    monitor.setCursorPos(1,4)
    monitor.setBackgroundColor(colors.lime)
    monitor.write("Deploy Sand")
        castDeploy()
        mouldReset(false)
        sleep(0.1)
        mouldReset(true)

    --waits for cast to harden
    sleep(1)
    local i2 = 300
    while i2 >= 0 do
        sleep(1)
        monitor.setCursorPos(1,6)
        monitor.setBackgroundColor(colors.black)
        monitor.write("                                       ")
        monitor.setCursorPos(1,6)
        monitor.setBackgroundColor(colors.yellow)
        monitor.write("Cast ("..i2.."s)")
        i2 = i2 -1
    end
    monitor.setCursorPos(1,6)
    monitor.setBackgroundColor(colors.lime)
    monitor.write("Cast (0s)")
    --places cast into processing chamber
        castPiston(true)
        sleep(0.1)
        castPiston(false)
        sleep(1)

    --drills piece
    monitor.setCursorPos(1,8)
    monitor.setBackgroundColor(colors.yellow)
    monitor.write("Drill Cannon")
        boreBearing(false)
        sleep(0.1)
        drillCannon(true)
        sleep(0.1)
        drillCannon(false)
        sleep(2)
        boreBearing(true)
        sleep(0.5)
    monitor.setCursorPos(1,8)
    monitor.setBackgroundColor(colors.lime)
    monitor.write("Drill Cannon")
    
    --pushes onto cannon
    monitor.setCursorPos(1,10)
    monitor.setBackgroundColor(colors.yellow)
    monitor.write("Place Cannon Piece")
        finalRotate(true)
        sleep(0.1)
        finalRotate(false)
        sleep(1)

        finalPiston(true)
        sleep(0.1)
        finalPiston(false)
    monitor.setCursorPos(1,10)
    monitor.setBackgroundColor(colors.lime)
    monitor.write("Place Cannon Piece")
    sleep(1)


    if castSize == "very small" then castSize = "small"
    elseif castSize == "small" then castSize = "medium"
    elseif castSize == "medium" then castSize = "very small" end
    i = i + 1
end