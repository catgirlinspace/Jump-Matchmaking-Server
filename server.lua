local json = require('json')
local Utils = require("lib/Utils")

local Matches = {}
local FriendLobbies = {} -- Format: { OwnerId = 0, Players = {} }
-- Player Format: { Id = info.userId, Rank = rank }

require("weblit-app")
    .bind({
        host = "0.0.0.0",
        port = 8888
    })
    
    .use(require('weblit-logger'))
    .use(require('weblit-auto-headers'))
    .use(require('weblit-etag-cache'))
  
    .route({
        method = "GET",
        path = "/",
    }, function (req, res, go)
        res.code = 200
        res.body = "Hello, world!"
    end)
    
    .route({
        method = "POST",
        path = "/matchmaking/findmatch"
    }, function (req, res, go)
        local info = json.decode(req.body)
        if info then
            -- Player has info
            local BestMatchId = Utils:FindMatch(Matches, info)
            if BestMatchId ~= nil then
                res.code = 200
                res.body = json.encode({ Success = true, Id = BestMatchId })
            else
                res.code = 200
                res.body = json.encode({ Success = false, code = 1 })
            end
        end
    end)
    
    .route({
        method = "POST",
        path = "/matchmaking/createfriendlobby"
    }, function (req, res, go)
        local info = json.decode(req.body)
        local userId = info.userId
        local userRank = info.matchmakingLevel
        FriendLobbies[userId] = { Players = { { Id = userId, Rank = userRank } } }
        res.code = 200
        res.body = json.encode({ success = true, msg = "Lobby made" })
    end)
    
    .route({
        method = "GET",
        path = "/matchmaking/findfriendlobbies"
    }, function (req, res, go)
        local info = json.decode(req.body)
        local friendsOnline = info.friendsOnline
        local friendsOnlineLobbies = {}
        for i, v in pairs(friendsOnline) do
            if FriendLobbies[i] then
                table.insert(friendsOnlineLobbies, FriendLobbies[i])
        end
        local resBody = { success = true, msg = "Friend lobbies found", FriendsLobbies = friendsOnlineLobbies }
        res.code = 200
        res.body = json.encode(resBody)
        end
    end)
    
    .route({
        method = "POST",
        path = "/matchmaking/joinfriendlobby"
    }, function (req, res, go)
        local info = json.decode(req.body)
        local friendId = info.friendId
        local userId = info.userId
        local userRank = info.userRank
        if friendLobbies[friendId] then
            -- Add player to lobby
            local player = { Id = userId, Rank = userRank }
            local pos = #friendLobbies[friendId][Players]
            table.insert(friendLobbies[friendId].Players, player, pos)
            res.code = 200
            res.body = json.encode({success = true, msg = "Player added"})
        else
            res.code = 200
            res.body = json.encode({success = false, msg = "Invalid friend id"})
        end
    end)
    
    .route({
        method = "GET",
        path = "/matchmaking/getfriendlobby"
    }, function (req, res, go)
        local info = json.decode(req.body)
        local friendId = info.friendId
        local r = friendLobbies[friendId] and { success = true, msg = "Friend exists", info = friendLobbies[friendId] } or { success = false, msg = "Friend lobby doesn't exist." }
        res.code = 200
        res.body = json.encode(r)
    end)
    
    .start()