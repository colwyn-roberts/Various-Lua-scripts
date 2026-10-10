local playerDetector = peripheral.find("playerDetector")

local operator = "Squid_Pig"
local targets = "osyl5313"
local targetInfo = {}
local i = 0

function tablelength(T)
    local count = 0
    for _ in pairs(T) do 
        count = count + 1 
        sleep(0.001)
    end
    return count
end

function getPlayerPos(user)

    --initializing variables
    local playerDetector = peripheral.find("playerDetector")
    local availablePlayers = playerDetector.getPlayersInRange(1000)
    local availablePlayersLen = tablelength(availablePlayers)
    local onlinePlayers = playerDetector.getOnlinePlayers()
    local onlinePlayersLen = tablelength(onlinePlayers)
    local i = 0

    --checks to make sure player is online
    while i <= onlinePlayersLen do
        if user == onlinePlayers[i] then
            i = 49
        end
        i = i + 1
    end
    if not (i == 50) then
        return user.." is Offline"
    end

    --checks to see if player is within range
    i = 0
    while i <= availablePlayersLen do
        if user == availablePlayers[i] then
            return playerDetector.getPlayerPos(user)
        end
        i = i + 1
    end
    return user.." is out of Range" 

end

while 1 do
    targetInfo = getPlayerPos(targets)
    operatorInfo = getPlayerPos(operator)
    if type(targetInfo) == "table" then
        term.clear()
        print(targets)
        print("  X: "..targetInfo.x)
        print("  Y: "..targetInfo.y)
        print("  Z: "..targetInfo.z)
        print("Respawn Position")
        print("  X: "..targetInfo.respawnPosition.x)
        print("  Y: "..targetInfo.respawnPosition.y)
        print("  Z: "..targetInfo.respawnPosition.z)
        print("Health: "..targetInfo.health)
        print("\nDistance: "..math.sqrt(((operatorInfo.x - targetInfo.x)*(operatorInfo.x - targetInfo.x)) + ((operatorInfo.z - targetInfo.z)*(operatorInfo.z - targetInfo.z))))
        print("\n\n\n\n\n\n\n")

    else
        term.clear()
        print(targets)
        print(targetInfo)
    end
    sleep(0.1)
end