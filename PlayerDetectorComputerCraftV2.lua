--config
local radius = 300
local whiteList = {"Squid_Pig","osyl5153"}
local axis = "north"
local chatbox = true
local turretPos = {}
    turretPos.x = -3
    turretPos.y = 0
    turretPos.z = 11
    turretPos.yaw = 0

--redstoneController
local shootPosition = "front"
local buildPosition = "top"

--sets up yaw based on axis
if (axis == "north") then
    turretPos.yaw = 0
elseif (axis == "south") then
    turretPos.yaw = 0
elseif (axis == "west") then
    turretPos.yaw = 270
elseif (axis == "east") then
    turretPos.yaw = 270
end

--setup
local playerDetector = peripheral.find("playerDetector")
local speedController = peripheral.find("Create_RotationSpeedController");
local redstoneController = peripheral.find("redstoneIntegrator")
local chat
if (chatbox) then
    chat = peripheral.find("chatBox")
end

local targetPos = {}
    targetPos.x = 0
    targetPos.y = 0
    targetPos.z = 0
    targetPos.dX = 0
    targetPos.dZ = 0
local kP = 0
local kD = 0
local targetName
local degreetoTarget
local speed = 0
local turnReset = true
local prevError = 0
local prevTime = os.clock();
local messageSentNames = {}
local messageSentTimes = {}
local messageSentMessage = {}
messageSentNames[0] = "Squid"
messageSentTimes[0] = os.clock()
messageSentMessage[0] = "empty"

term.clear()
print("> Program Start")
require "math"

--functions
function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end


function round(num)
    if num - math.floor(num) > 0.5 then
        return math.ceil(num)
    else
        return math.floor(num)
    end
end

--returns boolean based on if player had met their cooldown
function shouldSendMessage(player, message)
    local returnValue = false
    if (chatbox) then
        local replaceIndex = tablelength(messageSentNames)-1
        local hasMessageBeenSent = false
        for i3 = 0, tablelength(messageSentNames)-1 do
            if ((messageSentNames[i3] == player)) then
                if (((messageSentTimes[i3]+5) > os.clock())) then
                    hasMessageBeenSent = true
                end
                replaceIndex = i3
            end
        end
        if (not hasMessageBeenSent) then
            messageSentNames[replaceIndex] = player
            messageSentTimes[replaceIndex] = os.clock()
            messageSentMessage[replaceIndex] = message
            returnValue = true
        end
    end
    return returnValue
end

function lastSentMessage(player)
    local i = 0
    local returnValue = "None Available"
    for indexName in pairs(messageSentNames) do
        if (messageSentNames[i] == player) then
            returnValue = messageSentMessage[i]
        end
        i = i + 1
    end
    return returnValue
end
--main code start

--resets to starting position
speedController.setTargetSpeed(0)
redstoneController.setOutput(buildPosition,false)
sleep(0.1)
redstoneController.setOutput(buildPosition,true)
sleep(0.1)
redstoneController.setOutput(buildPosition,false)
sleep(0.1)
redstoneController.setOutput(buildPosition,true)

print("> Angle Reset");

--targeting system
while 1 do
    sleep(0.21)
    --detects and reports info on that player
    if playerDetector.isPlayersInRange(radius) then
        for i = 1, tablelength(playerDetector.getPlayersInRange(radius)) do
            targetName = playerDetector.getPlayersInRange(radius)[i]
            for i2 = 1, tablelength(whiteList) do
                if targetName == whiteList[i2] then
                    if (shouldSendMessage(targetName,"Welcome")) then
                        chat.sendMessage("Welcome " .. targetName)
                        print("Friendly " .. targetName .." Detected")
                    end
                    targetName = nil
                end
            end
            if not (targetName == nil) then
                local prevX = targetPos.x 
                local prevZ = targetPos.z
                targetPos = playerDetector.getPlayerPos(targetName)
                targetPos.dX = prevX - targetPos.x
                targetPos.dZ = prevZ - targetPos.z
                redstoneController.setOutput(shootPosition,true)
            else
                redstoneController.setOutput(shootPosition,false)
            end
        end
    else
        redstoneController.setOutput(shootPosition,false)
    end

    --estimates targets next position
    targetPos.dX = targetPos.dX * -1.5
    targetPos.dZ = targetPos.dZ * -1.5

    --finds degrees to aim
    if (axis == "north") then
        if (targetPos.z > turretPos.z) then
            degreetoTarget = 0;
        else
            degreetoTarget =  ((math.atan(((targetPos.x + targetPos.dX) - turretPos.x)/((targetPos.z + targetPos.dZ) - turretPos.z)) *180/3.1415))
        end
    elseif (axis == "south") then
        if (targetPos.z < turretPos.z) then
            degreetoTarget = 0;
        else
            degreetoTarget =  (0 - (math.atan2(((targetPos.x + targetPos.dX) - turretPos.x),((targetPos.z + targetPos.dZ) - turretPos.z)) *180/3.1415))
        end
    elseif (axis == "east") then
        if (targetPos.x < turretPos.x) then
            degreetoTarget = 270;
        else
            degreetoTarget =  (360 - (math.atan2(((targetPos.x + targetPos.dX) - turretPos.x),((targetPos.z + targetPos.dZ) - turretPos.z)) *180/3.1415))
        end
    elseif (axis == "west") then
        if(targetPos.x > turretPos.x) then
            degreetoTarget = 270;
        else
            degreetoTarget =  (360 + (math.atan2(((targetPos.x + targetPos.dX) - turretPos.x),((targetPos.z + targetPos.dZ) - turretPos.z)) *180/3.1415))
        end
    end
    if (degreetoTarget ~= degreetoTarget) then
        degreetoTarget = 0
    end

    --adjusts yaw based on amount turret should have moved
    turretPos.yaw = turretPos.yaw + ((os.clock() - prevTime)*(speed*0.75))
    prevTime = os.clock()
    local degreesToMove = (degreetoTarget - turretPos.yaw) 

    --manipulates kD to increase accuracy at farther distances
    local distanceToTarget = math.sqrt(math.pow((targetPos.x + targetPos.dX) - turretPos.x,2) + math.pow((targetPos.z + targetPos.dZ) - turretPos.z,2))
    if (distanceToTarget < 10) then
        kD = 0
        kP = 2
        targetPos.dX = 0
        targetPos.dZ = 0
    else
        kD = ((20/distanceToTarget)) + 0.5
    end

    --pd equation
    speed = (degreesToMove * kP) + (prevError * kD)

    --clamp speed to [-256,256]
    if (speed > 256) then
        speed = 256
    elseif (speed < -256) then
        speed = -256
    end
    
    speedController.setTargetSpeed(speed)
    prevError = degreesToMove
end