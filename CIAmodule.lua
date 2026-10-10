local playerDetector = peripheral.find("playerDetector")
local modem = peripheral.wrap("left")

--gets length of input table, outputs int
function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

--gathers position of input player if they are within the 1000 block limit
function getPlayerPos(user)

    --initializing variables
    local availablePlayers = playerDetector.getPlayersInRange(1000)
    local availablePlayersLen = tablelength(availablePlayers)
    local onlinePlayers = playerDetector.getOnlinePlayers()
    local onlinePlayersLen = tablelength(onlinePlayers)
    local i = 0
    local returnList

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
            returnList = playerDetector.getPlayerPos(user)
            returnList.name = user
            return returnList
        end
        i = i + 1
    end
    return user.." is out of Range"
    
end

local playerList = {"End_Studios","Potatoes2727","Squid_Pig","Potatoes2727","0TheBlueFires0","Sophestas","boxygame123","osyl","Zyrax17","grunky007","byronixus"}
local playerListLen = tablelength(playerList)

while 1 do
    i = 1
    while i <= playerListLen do
        modem.transmit(48736,5245,getPlayerPos(playerList[i]))
        i = i + 1
        sleep(0.01)
    end
end