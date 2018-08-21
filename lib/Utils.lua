local Utils = {}

function CalculateMinMax(startTime, rank)
    local TimeWaiting = os.time() - startTime
    if TimeWaiting >= 30 then
        return 0, math.huge
    end
    if TimeWaitng >= 20 then
        local a = rank - 750
        local b = rank + 750
        return a, b
    end
    if TimeWaiting >= 10 then
        local a = rank - 500
        local b = rank + 250
        return a, b
    end
    return rank - 250, rank + 250
end

function Utils:FindMatch(matches, info)
    if matches and info then
        local rank = info.matchmakingLevel
        local startTime = os.time() or info.startTime
        local min, max = CalculateMinMax(startTime, rank)
        
        -- Matchmaking system
        
        local BestMatchId = nil
        
        for i, v in ipairs(matches) do
            local AvgRank = 0
            local AvgPlayers = 0
            for _, y in ipairs(v.Players) do
                AvgRank = AvgRank + y.Rank
                AvgPlayers = AvgPlayers + 1
            end
            AvgRank = AvgRank / AvgPlayers
            AvgPlayers = nil
            BestMatchID = i
            break
        end
        
        if BestMatchId == nil then -- Match not found. Decide to create new lobby or wait. 
            if #matches >= 5 then -- Create new match
                local match = { Players = {}, TeleportCode = nil }
                local player = { Id = info.userId, Rank = rank }
                table.insert(match.Players, player)
                local pos = #matches + 1
                table.insert(matches, pos, match)
                bestMatchId = pos
            else
                BestMatchId = 0
            end
        else
            local player = { Id = info.userId, Rank = rank }
            local pos = #matches + 1
            table.insert(matches[bestMatchId].Players, pos, player)
            bestMatchId = pos
        end
        return bestMatchId
    end
end