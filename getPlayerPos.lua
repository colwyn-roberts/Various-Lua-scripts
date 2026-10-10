--gets length of input table, outputs int
function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

--gathers position of input player if they are within the 1000 block limit
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