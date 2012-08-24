STATUS_CODES = require('http').STATUS_CODES

module.exports = class Response extends require('./').IceBaseStack
    _headerCompleteEvent: "request"
    headerSent: false
    
    constructor: (stream) ->
        super stream
        
    writeHead: (statusCode,headers) ->
        @headerSent = true
        @_writeHeader [@httpVersion,statusCode,STATUS_CODES[statusCode]].join(" "), headers||[]
        
    _parseFirstLine: (line,req) ->
        i = line.indexOf(' ')
        req.method = line.substring(0, i)
        j = line.indexOf(' ', i+1);
        req.path = line.substring(i+1, j);
        req.httpVersion = line.substring(j+1);
        
    