local json = require('json')
local Utils = require("lib/Utils.lua")

local Matches = {}
local FriendLobbies = {}

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
        res.body = "Hello!"
    end)
    
    .route({
        method = "POST",
        path = "/matchmaking/findmatch"
    }, function (req, res, go)
        local info = json.decode(req.body)
        if info then
            -- Player has info
            local BestMatchId = Utils:FindMatch(Matches, info)
            if BestMatchId ~= nil and BestMatchId ~= 1 then
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
    end)
    
    .route({
        method = "GET",
        path = "/matchmaking/findfriendlobbies"
    }, function (req, res, go)
        local info = json.decode(req.body)
        local friendsOnline = info.friendsOnline
    end)
    
    .start()