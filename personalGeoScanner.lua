--config
local radius = 8 --16 max radius
--mining axis is the axis that the robot will move along, (x,y,z) is the starting position of the line
local miningAxis = {}
    miningAxis.x = -616
    miningAxis.y = -45
    miningAxis.z = -2259
    miningAxis.axis = "+z" --format of '+z', '-z', '+y'
local toMine = {}
    toMine[1] = "minecraft:diamond_ore"
    toMine[2] = "minecraft:deepslate_diamond_ore"

--position of turtle when code run
local position = {}
    position.x = 0
    position.y = 0
    position.z = 0
    position.yaw = "East"

--Position the block must go to and point in direction of chest NOT position of chest
local refuelPosition = {}
    refuelPosition.x = -616
    refuelPosition.y = -55
    refuelPosition.z = -2269
    refuelPosition.yaw = "East"

--Position the block must go to and point in direction of chest NOT position of chest
local depositPosition = {}
    depositPosition.x = -616
    depositPosition.y = -55
    depositPosition.z = -2267
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
        local closestBlock = findClosestBlock(importantBlocks)
        print(closestBlock.name .. " ("..closestBlock.x..","..closestBlock.y..","..closestBlock.z..") Distance: "..closestBlock.distance .."m")

    else
        print("> Scan Failed")
    end
end

function returnToRefuel()
    
end

function returnToDeposit()
    
end

--[[  Main Code  ]]--

--Starting Tasks
    term.clear()

--Main Loop

mineAllBlocksInArea()