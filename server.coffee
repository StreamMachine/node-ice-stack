Response = require('./').IceResponseStack

class Server extends require('net').Server
    constructor: (listener) ->
        super {}, (stream) => @setup(stream)
        
        if typeof listener == "function"
            @on "request", listener

    setup: (stream) ->
        if stream.readable && stream.writable
            response = new Response(stream)
            response.on "request", (req) =>
                @emit "request", req, response
        else
            console.error "Stream is not readable / writable"
            stream.end()
       
exports.Server = Server 
exports.createServer = (listener) ->
    new Server(listener) 