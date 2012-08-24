Server = require("../").Server

server = Server.createServer (req,res) ->
    console.log "got request", req
    
    res.writeHead(200)
    res.end("Yay!")
    
server.listen(8888)