local redstoneController1 = peripheral.wrap("right")
local redstoneController2 = peripheral.wrap("left")
local redstoneController3 = peripheral.wrap("bottom")

function bottomPistons(num,state)
    if     num == 1 then redstoneController1.setOutput("top",state)
    elseif num == 2 then redstoneController1.setOutput("right",state)
    elseif num == 3 then redstoneController1.setOutput("front",state)
    elseif num == 4 then redstoneController1.setOutput("back",state)
    elseif num == 5 then redstoneController2.setOutput("top",state)
    elseif num == 6 then redstoneController2.setOutput("left",state)
    elseif num == 7 then redstoneController2.setOutput("front",state)
    elseif num == 8 then redstoneController2.setOutput("back",state) end
end

function cannonBuilderPushMode(state)
    redstone.setOutput("back",state)
end

function cannonBuilderShove(state)
    redstone.setOutput("top",state)
end

function secondCannonBuilderShove(state)
    redstoneController1.setOutput("bottom",state)
end

function secondCannonPushMode(state)
    redstoneController2.setOutput("bottom",state)
end

function finalChamberGrab(state)
    redstoneController3.setOutput("bottom",state)
end

function finalChamberRotate(state)
    redstoneController3.setOutput("back",state)
end

function finalChamberPush(state)
    redstoneController3.setOutput("front",state)
end

redstoneController1.setOutput("front",false)
redstoneController1.setOutput("right",false)
redstoneController1.setOutput("top",false)
redstoneController1.setOutput("back",false)
redstoneController1.setOutput("left",false)
redstoneController1.setOutput("bottom",false)

redstoneController2.setOutput("front",false)
redstoneController2.setOutput("right",false)
redstoneController2.setOutput("top",false)
redstoneController2.setOutput("back",false)
redstoneController2.setOutput("left",false)
redstoneController2.setOutput("bottom",false)

redstoneController3.setOutput("front",false)
redstoneController3.setOutput("right",false)
redstoneController3.setOutput("top",false)
redstoneController3.setOutput("back",false)
redstoneController3.setOutput("left",false)
redstoneController3.setOutput("bottom",false)

redstone.setOutput("front",false)
redstone.setOutput("right",false)
redstone.setOutput("top",false)
redstone.setOutput("back",false)
redstone.setOutput("left",false)
redstone.setOutput("bottom",false)

bottomPistons(1,true)
bottomPistons(2,true)
bottomPistons(3,true)
bottomPistons(4,true)
bottomPistons(5,true)
bottomPistons(6,true)
bottomPistons(7,true)
bottomPistons(8,true)


sleep(1)

local i = 6

bottomPistons(i,true)
cannonBuilderPushMode(true)
sleep(0.1)
cannonBuilderPushMode(false)
cannonBuilderShove(true)
sleep(5)
cannonBuilderPushMode(true)
sleep(0.1)
cannonBuilderPushMode(false)
bottomPistons(i,false)
cannonBuilderShove(false)

sleep(1.5)
secondCannonPushMode(true)
secondCannonBuilderShove(true)
sleep(0.1)
secondCannonPushMode(false)
sleep(5)
secondCannonBuilderShove(true)
secondCannonPushMode(true)
sleep(0.1)
secondCannonPushMode(false)
secondCannonBuilderShove(false)
sleep(0.1)
secondCannonBuilderShove(true)
sleep(2)
secondCannonBuilderShove(false)
sleep(0.1)

finalChamberGrab(true)
sleep(5)
finalChamberGrab(false)
sleep(5)
finalChamberRotate(true)
sleep(0.1)
finalChamberRotate(false)
sleep(0.2)
finalChamberPush(true)
sleep(2)
finalChamberPush(false)
bottomPistons(i,true)