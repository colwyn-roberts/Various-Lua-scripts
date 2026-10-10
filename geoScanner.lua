--config
local radius = 16 --16 max radius
--mining axis is the axis that the robot will move along, (x,y,z) is the starting position of the line
local miningAxis = {}
    miningAxis.x = -39
    miningAxis.y = 13
    miningAxis.z = -526
    miningAxis.axis = "-z" --format of '+z', '-z', '+y'
local toMine = {}
    toMine[1] = "minecraft:ancient_debris"
    toMine[2] = "minecraft:iron_ore"
    toMine[3] = "minecraft:diamond_ore"

--position of turtle when code run
local position = {}
    position.x = -39
    position.y = 13
    position.z = -524
    position.yaw = "North"

--Position the block must go to and point in direction of chest NOT position of chest
local refuelPosition = {}
    refuelPosition.x = -39
    refuelPosition.y = 13
    refuelPosition.z = -525
    refuelPosition.yaw = "East"

--Position the block must go to and point in direction of chest NOT position of chest
local depositPosition = {}
    depositPosition.x = -39
    depositPosition.y = 13
    depositPosition.z = -526
    depositPosition.yaw = "East"


--setup
local geoScanner = peripheral.find("geoScanner")
local slotsFull = 0
--North fwd: z--
--South fwd: z++
--East  fwd: x++
--West  fwd: x--
require "math"

--[[  basic utility functions  ]]--

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

--[[  Turtle Movement Functions  ]]--

--converts string direction to number [0,3] North = 0, East = 3
function directionToNum(direction)
    if (direction == "North") then
        return 0
    elseif (direction == "West") then
        return 1
    elseif (direction == "South") then
        return 2
    elseif (direction == "East") then
        return 3
    end
end

--makes turtle face in specified direction
function face(direction)
    local target = directionToNum(direction)
    local currentPos = directionToNum(position.yaw)
    if not (direction == position.yaw) then
        if ((target + 2)%4 == currentPos) then --lets you know if it is 180 away
            turtle.turnLeft()
            turtle.turnLeft()
        elseif ((target + 1)%4 == currentPos) then
            turtle.turnRight()
        else
            turtle.turnLeft()
        end
    end
    position.yaw = direction
end

--moves to input coordinates
function goTo(x,y,z)
    --adjusts y value upwards
    while (position.y < y) do
        if (turtle.detectUp()) then
            turtle.digUp()
        end
        if (turtle.up()) then
            position.y = position.y + 1
            print("Y: " ..position.y)
        end
    end
    --adjusts y value downwards
    while (position.y > y) do
        if (turtle.detectDown()) then
            turtle.digDown()
        end
        if (turtle.down()) then
            position.y = position.y - 1
            print("Y: " ..position.y)
        end
    end
    --adjusts x value up
    while (position.x < x) do
        face("East")
        if (turtle.detect()) then
            turtle.dig()
        end
        if (turtle.forward()) then
            position.x = position.x + 1
            turtle.digUp()
            print("X: " ..position.x)
        end
    end
    --adjusts x value down
    while (position.x > x) do
        face("West")
        if (turtle.detect()) then
            turtle.dig()
        end
        if (turtle.forward()) then
            turtle.digUp()
            position.x = position.x - 1
            print("X: " ..position.x)
        end
    end
    --adjusts z value up
    while (position.z < z) do
        face("South")
        if (turtle.detect()) then
            turtle.dig()
        end
        if (turtle.forward()) then
            turtle.digUp()
            position.z = position.z + 1
            print("Z: " ..position.z)
        end
    end
    --adjusts z value down
    while (position.z > z) do
        face("North")
        if (turtle.detect()) then
            turtle.dig()
        end
        if (turtle.forward()) then
            turtle.digUp()
            position.z = position.z - 1
            print("Z: " ..position.z)
        end
    end
end

--calculates number of tiles turtle will move to get to coords, used for fuel calculations
function pathLengthTo(x,y,z)
    local dY = math.abs(position.y - y)
    local dX = math.abs(position.x - x)
    local dZ = math.abs(position.z - z)
    return dY + dX + dZ
end

function findClosestBlock(BlockList)
    local outputBlock = {}
    outputBlock.distance = 50000
    for i = 0, tablelength(BlockList)-1 do
        local block = BlockList[i]
        block.index = i
        if block.distance ~= 50001 then
            block.distance = pathLengthTo(block.x,block.y,block.z)
            if (block.distance < outputBlock.distance) then
                outputBlock = block
            end
        end
    end
    return outputBlock
end

function mineAllBlocksInArea()
    local scan
    if ((turtle.getFuelLevel() - geoScanner.cost(radius)) > pathLengthTo(refuelPosition.x,refuelPosition.y,refuelPosition.z) + 5000) then-- the 5000 is for the mining of the ores itself, keeps a healthy level of fuel
        scan = geoScanner.scan(radius)
    end
    print("> Scanning... ")
    if not (scan == nil) then 
        --extracts all relavent blocks and stores in importantBlocks array
        local importantBlocks = {}
        local importantBlocksLength = 0
        for i = 1, tablelength(scan) do
            for ii = 1, tablelength(toMine) do
                if (scan[i].name == toMine[ii]) then
                    importantBlocks[importantBlocksLength] = scan[i]
                    --scan output position is relative to turtles position, so it converts to real coords
                    importantBlocks[importantBlocksLength].x = importantBlocks[importantBlocksLength].x + position.x
                    importantBlocks[importantBlocksLength].y = importantBlocks[importantBlocksLength].y + position.y
                    importantBlocks[importantBlocksLength].z = importantBlocks[importantBlocksLength].z + position.z
                    --sets an integer value for distance while block created
                    importantBlocks[importantBlocksLength].distance = 0
                    importantBlocksLength = importantBlocksLength + 1
                end
            end
            local block = scan[i]
            print(block.name .. " ("..block.x..","..block.y..","..block.z..")")
        end
        --debug
        print("> Printing all relavent Blocks")
        if (tablelength(importantBlocks) ~= 0) then
            --prints all important blocks
            for i = 0, tablelength(importantBlocks)-1 do
                local block = importantBlocks[i]
                print(block.name .. " ("..block.x..","..block.y..","..block.z..")")
            end
        else
            print("Nothing detected")
        end
    
        --moves to and mines all blocks detected
        for i = 0, tablelength(importantBlocks)-1 do
            print("> Printing Closest Block")
            local closestBlock = findClosestBlock(importantBlocks)
            print(closestBlock.name .. " ("..closestBlock.x..","..closestBlock.y..","..closestBlock.z..") Distance: "..closestBlock.distance .."m")
            goTo(closestBlock.x,closestBlock.y,closestBlock.z)
    
            --50001 will cause this block to never be selected as closest block again
            importantBlocks[closestBlock.index].distance = 50001
        end
    else
        print("> Scan Failed")
    end
end

function returnToRefuel()
    goTo(refuelPosition.x,refuelPosition.y,refuelPosition.z)
    face(refuelPosition.yaw)
    turtle.select(16)
    --100000 is fuel cap for advanced, change to 20000 for normal turtles
    while (turtle.getFuelLevel() < 10000) do
        turtle.suck(64)
        turtle.refuel()
    end
end

function returnToDeposit()
    goTo(depositPosition.x,depositPosition.y,depositPosition.z)
    face(depositPosition.yaw)
    turtle.select(1)
    local hasBlock, blockData = turtle.inspect()
    while (blockData.name ~= "minecraft:chest") do
        sleep(0.5)
    end
    while(turtle.getSelectedSlot() ~= 16) do
        while not (turtle.drop(turtle.getItemCount(turtle.getSelectedSlot()))) do
            print("> Chest is Full, please wait")
            sleep(0.5)
        end
        if (turtle.getSelectedSlot() ~= 16) then
            turtle.select(turtle.getSelectedSlot()+1)
        end
    end
    slotsFull = 0
end

--[[  Main Code  ]]--

--Starting Tasks
    term.clear()
    print("> Program Start")
    --turtle.refuel()
    print("> Refueling")
    returnToRefuel()
--Main Loop
local timesTraveled = 0
while (timesTraveled < 10) do
    goTo(miningAxis.x,miningAxis.y,miningAxis.z)
    while (((turtle.getFuelLevel() - geoScanner.cost(radius)) > pathLengthTo(refuelPosition.x,refuelPosition.y,refuelPosition.z) + 5000) and (slotsFull <= 8)) do
        print("> Mining all blocks in area")
        --heads to the next position on mining axis
        if (miningAxis.axis == "+x") then
            goTo(miningAxis.x + (timesTraveled * radius * 2),miningAxis.y,miningAxis.z)
        elseif (miningAxis.axis == "-x") then
            goTo(miningAxis.x - (timesTraveled * radius * 2),miningAxis.y,miningAxis.z)
        elseif (miningAxis.axis == "+y") then
            goTo(miningAxis.x,miningAxis.y + (timesTraveled * radius * 2),miningAxis.z)
        elseif (miningAxis.axis == "-y") then
            goTo(miningAxis.x,miningAxis.y - (timesTraveled * radius * 2),miningAxis.z)
        elseif (miningAxis.axis == "+z") then
            goTo(miningAxis.x,miningAxis.y,miningAxis.z + (timesTraveled * radius * 2))
        elseif (miningAxis.axis == "-z") then
            goTo(miningAxis.x,miningAxis.y,miningAxis.z - (timesTraveled * radius * 2))
        end
        turtle.select(1)
        mineAllBlocksInArea()
        timesTraveled = timesTraveled + 1

        slotsFull = 0
        local slot = 1
        while (slot < 16) do
            turtle.select(slot)
            if (turtle.getItemCount(slot) ~= 0) then
                slotsFull = slotsFull + 1
            end
            slot = slot + 1
        end
        print("There are "..slotsFull.." Slots full")
    end

    if not (slotsFull <= 8) then
        print("> Slots full")
    elseif not ((turtle.getFuelLevel() - geoScanner.cost(radius)) > pathLengthTo(refuelPosition.x,refuelPosition.y,refuelPosition.z) + 5000) then
        print("> Not enough fuel for journey home")
        print("FuelLevel - cost: " .. (turtle.getFuelLevel() - geoScanner.cost(radius)))
        print("Path Length + 5000: ".. pathLengthTo(refuelPosition.x,refuelPosition.y,refuelPosition.z) + 5000)
    end
    print("> Depositing")
    returnToDeposit()
    print("> Refueling")
    returnToRefuel()
end
print("> Program End")