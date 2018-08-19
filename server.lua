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
        res.body = "Hello!"
    end)
    
    .start()