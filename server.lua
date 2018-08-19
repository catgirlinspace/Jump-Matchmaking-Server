local json = require('json')

local Matches = {}

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
        end
    end)
    
    .start()