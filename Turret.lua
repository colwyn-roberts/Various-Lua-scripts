--config
local radius = 30
local whiteList = {"Squi_Pig","osyl5153"}
local axis = "north" --axis turret is facing
local chat = true
local messageCooldown = 5 --seconds
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
local chatBox = peripheral.find("chatBox")

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
local prevX = 0
local prevZ = 0
local messageSentNames = {}
local messageSentTimes = {}
local messageSentMessage = {}
messageSentNames[0] = "Squid"
messageSentTimes[0] = os.clock()
messageSentMessage[0] = "empty"

--terminal setup
term.clear()
print("> Program Start")
require "math"

--basic utility functions
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
function shouldSendMessage(player, message) --message is the message you are *attempting* to send to the player, used in lastSentMessage() function
    local returnValue = false
    local replaceIndex = tablelength(messageSentNames)-1
    local hasMessageBeenSent = false
    for i3 = 0, tablelength(messageSentNames)-1 do
        if ((messageSentNames[i3] == player)) then
            if (((messageSentTimes[i3]+messageCooldown) > os.clock())) then
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
    return returnValue
end

--returns last message sent to player
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
redstoneController.setOutput(shootPosition,false)
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
    --required to not break speed controller
    sleep(0.21)

    --detects players outside range and resets their warnings if they stay out for a while
    for i = 1,tablelength(messageSentNames) do
        if not(playerDetector.isPlayerInRange(radius,messageSentNames[i-1])) then
            if not (lastSentMessage(messageSentNames[i-1]) == "Region Left") then
                if (shouldSendMessage(messageSentNames[i-1],"Region Left")) then
                    print("Player " .. messageSentNames[i-1] .." Left Region")
                    if (chat) then
                        chatBox.sendMessageToPlayer("You have left the region",messageSentNames[i-1],"Turret")
                    end
                end
            end
        end
    end

    --detects and reports info on that player
    targetPos.distanceToTarget = 0
    if playerDetector.isPlayersInRange(radius) then
        for i = 1, tablelength(playerDetector.getPlayersInRange(radius)) do
            targetName = playerDetector.getPlayersInRange(radius)[i]
            for i2 = 1, tablelength(whiteList) do
                if targetName == whiteList[i2] then
                    if not (lastSentMessage(targetName) == "Welcome") then
                        if (shouldSendMessage(targetName,"Welcome")) then
                            if (chat) then
                                chatBox.sendMessageToPlayer("Welcome " .. targetName,targetName,"Turret")
                            end
                            print("Friendly " .. targetName .." Detected")
                        end
                    end
                    targetName = nil
                end
            end
            if not (targetName == nil) then
                --picks target closest to turret
                local tempTargetPos = playerDetector.getPlayerPos(targetName)
                tempTargetPos.distanceToTarget = math.sqrt(math.pow(tempTargetPos.x - turretPos.x,2) + math.pow(tempTargetPos.z - turretPos.z,2))
                if (tempTargetPos.distanceToTarget > targetPos.distanceToTarget) then
                    targetPos = playerDetector.getPlayerPos(targetName)
                    targetPos.dX = prevX - targetPos.x
                    targetPos.dZ = prevZ - targetPos.z
                end
                --increments a player's warnings
                local lastMessage = lastSentMessage(targetName)
                if (lastMessage ~= "Warning" and lastMessage ~= "Locking" and lastMessage ~= "Shooting") then
                    if (shouldSendMessage(targetName,"Warning")) then
                        if (chat) then 
                            chatBox.sendMessageToPlayer("Warning " .. targetName .. "!",targetName,"Turret")
                            --chatBox.sendToastToPlayer("Stay away", "WARNING",targetName,"Turret")
                        end
                        print("Warning given to " .. targetName)
                    end
                elseif (lastMessage ~= "Locking" and lastMessage ~= "Shooting") then
                    if (shouldSendMessage(targetName,"Locking")) then
                        if (chat) then
                            chatBox.sendMessageToPlayer("Turret locked onto " .. targetName .. "'s location",targetName,"Turret")
                            --chatBox.sendToastToPlayer("Turret Locking", "WARNING",targetName,"Turret")
                        end
                        print("Locking onto " .. targetName)
                        --single warning shot
                        redstoneController.setOutput(shootPosition,true)
                        sleep(0.1)
                        redstoneController.setOutput(shootPosition,false)
                    end
                else
                    if (shouldSendMessage(targetName,"Shooting")) then
                        if (chat) then
                            chatBox.sendMessageToPlayer("Shooting at " .. targetName .. "!",targetName,"Turret")
                            --chatBox.sendToastToPlayer("Opening Fire", "WARNING",targetName,"Turret")
                        end
                        print("Shooting at " .. targetName)
                        --opens fire
                        redstoneController.setOutput(shootPosition,true)
                    end
                end
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
    prevX = targetPos.x
    prevZ = targetPos.z
end