StreamStack  = require('stream-stack').StreamStack
Headers      = require('header-stack').Headers
HeaderParser = require('header-stack').Parser

module.exports = class IceBaseStack extends StreamStack
    httpVersion: "ICE/1.0"
    
    constructor: (stream) ->
        super stream, data:@_onData
        
        @_headerParser = new HeaderParser emitFirstLine:true
        @_headerParser.on "firstLine", (line) => @_onFirstLine(line)
    
    write: (chunk,enc) ->
        if @chunkedOutgoing
            @_writeChunk chunk, enc
        else
            @stream.write chunk, enc
            
    end: (chunk,enc) ->
        @write chunk, enc if chunk
        @stream.end()
        
    _writeHeader: (firstline,headers) ->
        @stream.write Headers(headers).toString firstLine:firstline
        
    _onData: (data) ->
        if @_headerParser
            @_headerParser.parse(data)
        else
            @emit "data", data
        
    _onFirstLine: (line) ->
        stream = new StreamStack @
        @_headerParser.on "headers", (headers,leftover) =>
            @_onHeaders headers, leftover, stream
            
        @_parseFirstLine line, stream
        
    _onHeaders: (headers,leftover,stream) ->
        @_headerParser = null
        
        stream.headers = headers
        @emit @_headerCompleteEvent, stream
        
        @emit "data", leftover if leftover