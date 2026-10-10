local redstoneController = peripheral.find("redstoneIntegrator")
local monitor = peripheral.wrap("right")
local iterations = 20

--redstone link positions
function mouldDeployer(state,name)
    if name == "very small" then
        redstone.setOutput("top",state)
    end
    else if name == "small" then
        redstone.setOutput("front",state)
    end
    else if name == "medium" then
        redstoneController.setOutput("right",state)
    end
end

function sandDeployer(state)
    redstone.setOutput("back",state)
end

function castPiston(state)
    redstone.setOutput("left",state)
end

function boreBearing(state)
    redstoneController.setOutput("front",state)
end

function drillCannon(state)
    redstoneController.setOutput("left",state)
end

function finalRotate(state)
    redstoneController.setOutput("bottom",state)
end

function finalPiston(state)
    redstoneController.setOutput("back",state)
end

--sets redstone to default positions
function redstoneReset()
    redstoneController.setOutput("front",false)
    redstoneController.setOutput("left",false)
    redstoneController.setOutput("right",false)
    redstoneController.setOutput("back",false)
    redstoneController.setOutput("top",false)
    redstoneController.setOutput("bottom",false)

    redstone.setOutput("front",false)
    redstone.setOutput("left",false)
    redstone.setOutput("right",false)
    redstone.setOutput("back",false)
    redstone.setOutput("top",false)
    redstone.setOutput("bottom",false)

    mouldDeployer(true)
    boreBearing(true)
end

redstoneReset()
monitor.setBackgroundColor(colors.black)
monitor.setTextScale(1)
monitor.clear()
local i = 0
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
        mouldDeployer(false,"very small")
        sleep(0.1)
        mouldDeployer(true,"very small")
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
        mouldDeployer(false,"very small")
        sleep(0.1)
        mouldDeployer(true,"very small")

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

    i = i + 1
end