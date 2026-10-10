term.clear()
print("> Program Start")

--config
local radius = 25
local gearRatio = 2
local whiteList = {"Squ_Pig","osyl5153"}
local rpm = 128
local turretPos = {}
    turretPos.x = -37
    turretPos.y = -6
    turretPos.z = -197
    turretPos.yaw = 0

--redstone
    --front = shoot
    --bottom = build cannon
--redstoneController
    -- back = gearshift
    -- left = clutch

--setup
local playerDetector = peripheral.find("playerDetector")
local gearShift = peripheral.find("Create_SequencedGearshift")
local redstoneController = peripheral.find("redstoneIntegrator")
local targetPos
local targetName
local clock = os.clock
local degreetoTarget
local turnReset = true
redstone.setOutput("bottom",true)

--functions
function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function wait(time)
    print("wait started = "..time)
    sleep(time)
    print("wait ended")
    return nil
end

function round(num)
    if num - math.floor(num) > 0.5 then
        return math.ceil(num)
    else
        return math.floor(num)
    end
end

function turnOffRedstone()
    --local redstoneController = peripheral.find("redstoneIntegrator")
    redstone.setOutput("front",false)
    redstone.setOutput("left",false)
    redstone.setOutput("right",false)
    redstone.setOutput("back",false)
    redstone.setOutput("top",false)
    redstone.setOutput("bottom",false)

    redstoneController.setOutput("front",false)
    redstoneController.setOutput("left",false)
    redstoneController.setOutput("right",false)
    redstoneController.setOutput("back",false)
    redstoneController.setOutput("top",false)
    redstoneController.setOutput("bottom",false)
end
--speedController.setTargetSpeed(rpm)
print("> Variables Initalized")
--main code start
while 1 do
    wait(0.1)
    --term.clear()
    --detects and reports info on that player
    if playerDetector.isPlayersInRange(radius) then
        for i = 1, tablelength(playerDetector.getPlayersInRange(radius)) do
            targetName = playerDetector.getPlayersInRange(radius)[i]
            for i2 = 1, tablelength(whiteList) do
                if targetName == whiteList[i2] then
                    print("> Friendly " .. targetName .." Detected")
                    targetName = nil
                end
            end
            if not (targetName == nil) then
                targetPos = playerDetector.getPlayerPos(targetName)
                redstone.setOutput("front",true)
                print("> Player = "..targetName)
                print(">   targetX = "..targetPos.x )
                print(">   targetY = "..targetPos.y )
                print(">   targetZ = "..targetPos.z )
            else
                redstone.setOutput("front",false)
            end
        end
    else
        redstone.setOutput("front",false)
    end
    --finds degrees to aim
    degreetoTarget = round(math.atan2(targetPos.x - turretPos.x,targetPos.z - turretPos.z) * gearRatio *180/math.pi)
    
    print(">   Degrees = "..degreetoTarget)
    print(">   Degrees to Move = "..degreetoTarget - turretPos.yaw)
    if (degreetoTarget - turretPos.yaw) < 0 then
        turnReset = true
        redstoneController.setOutput("right",false)
        redstoneController.setOutput("back",false)
        wait((rpm/60)*((math.abs(degreetoTarget - turretPos.yaw))/360)) --finds rotations needed, and then converts to seconds based on rpm
        redstoneController.setOutput("right", true)
    elseif (degreetoTarget - turretPos.yaw) > 0 then
        turnReset = true
        redstoneController.setOutput("right",false)
        redstoneController.setOutput("back",true)
        wait((rpm/60)*((math.abs(degreetoTarget - turretPos.yaw))/360)) --finds rotations needed, and then converts to seconds based on rpm
        redstoneController.setOutput("right", true)
        redstoneController.setOutput("back",false)
    else
        redstoneController.setOutput("right",true) --clutch to disable speed
        if (turretPos.yaw == 0) and turnReset then
            redstone.setOutput("bottom",false)
            wait(0.1)
            redstone.setOutput("bottom",true)
            turnReset = false
        end
    end


    turretPos.yaw =turretPos.yaw + round(((degreetoTarget - turretPos.yaw)))
    print(">   Turret.yaw = " .. turretPos.yaw)
end

print("Program End")