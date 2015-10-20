// HTTPRequestParser.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Zewo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import http_parser

struct HTTPRequestParserContext {
    var request = RawHTTPRequest()
    var currentURI = ""
    var currentHeaderField = ""
    var completion: HTTPParseResult<RawHTTPRequest> -> Void

    init(completion: HTTPParseResult<RawHTTPRequest> -> Void) {
        self.completion = completion
    }
}

var requestSettings: http_parser_settings = {
    var settings = http_parser_settings()
    http_parser_settings_init(&settings)

    settings.on_url              = onRequestURL
    settings.on_header_field     = onRequestHeaderField
    settings.on_header_value     = onRequestHeaderValue
    settings.on_headers_complete = onRequestHeadersComplete
    settings.on_body             = onRequestBody
    settings.on_message_complete = onRequestMessageComplete

    return settings
}()

public final class HTTPRequestParser {
    let completion: HTTPParseResult<RawHTTPRequest> -> Void
    let context: UnsafeMutablePointer<HTTPRequestParserContext>
    var parser = http_parser()

    public init(completion: HTTPParseResult<RawHTTPRequest> -> Void) {
        self.completion = completion

        self.context = UnsafeMutablePointer<HTTPRequestParserContext>.alloc(1)
        self.context.initialize(HTTPRequestParserContext(completion: completion))

        http_parser_init(&self.parser, HTTP_REQUEST)
        self.parser.data = UnsafeMutablePointer<Void>(context)
    }

    deinit {
        context.destroy()
        context.dealloc(1)
    }

    public func parseData(data: UnsafeMutablePointer<Void>, length: Int) {
        let bytesParsed = http_parser_execute(&parser, &requestSettings, UnsafeMutablePointer<Int8>(data), length)

        if parser.upgrade == 1 {
            let error = HTTPParseError(description: "Upgrade not supported")
            completion(HTTPParseResult.Failure(error))
        }

        if bytesParsed != length {
            let errorName = http_errno_name(http_errno(parser.http_errno))
            let errorDescription = http_errno_description(http_errno(parser.http_errno))
            let error = HTTPParseError(description: "\(String.fromCString(errorName)!): \(String.fromCString(errorDescription)!)")
            completion(HTTPParseResult.Failure(error))
        }
    }
}

extension HTTPRequestParser {
    public func parse(var data: [Int8]) {
        parseData(&data, length: data.count)
    }

    public func parse(string: String) {
        var data = string.utf8.map { Int8($0) }
        parseData(&data, length: data.count)
    }
}

func onRequestURL(parser: UnsafeMutablePointer<http_parser>, data: UnsafePointer<Int8>, length: Int) -> Int32 {
    let context = UnsafeMutablePointer<HTTPRequestParserContext>(parser.memory.data)

    var buffer: [Int8] = [Int8](count: length + 1, repeatedValue: 0)
    strncpy(&buffer, data, length)
    context.memory.currentURI += String.fromCString(buffer)!

    return 0
}

func onRequestHeaderField(parser: UnsafeMutablePointer<http_parser>, data: UnsafePointer<Int8>, length: Int) -> Int32 {
    let context = UnsafeMutablePointer<HTTPRequestParserContext>(parser.memory.data)

    var buffer: [Int8] = [Int8](count: length + 1, repeatedValue: 0)
    strncpy(&buffer, data, length)
    context.memory.currentHeaderField += String.fromCString(buffer)!

    return 0
}

func onRequestHeaderValue(parser: UnsafeMutablePointer<http_parser>, data: UnsafePointer<Int8>, length: Int) -> Int32 {
    let context = UnsafeMutablePointer<HTTPRequestParserContext>(parser.memory.data)

    var buffer: [Int8] = [Int8](count: length + 1, repeatedValue: 0)
    strncpy(&buffer, data, length)
    let headerField = context.memory.currentHeaderField
    let previousHeaderValue = context.memory.request.headers[headerField] ?? ""
    context.memory.request.headers[headerField] = previousHeaderValue + String.fromCString(buffer)!

    return 0
}

func onRequestHeadersComplete(parser: UnsafeMutablePointer<http_parser>) -> Int32 {
    let context = UnsafeMutablePointer<HTTPRequestParserContext>(parser.memory.data)

    context.memory.request.method = RawHTTPMethod(rawValue: Int(parser.memory.method))!
    context.memory.request.majorVersion = Int(parser.memory.http_major)
    context.memory.request.minorVersion = Int(parser.memory.http_minor)
    context.memory.request.URI = RawURI(string: context.memory.currentURI)

    context.memory.currentURI = ""
    context.memory.currentHeaderField = ""

    return 0
}

func onRequestBody(parser: UnsafeMutablePointer<http_parser>, data: UnsafePointer<Int8>, length: Int) -> Int32 {
    let context = UnsafeMutablePointer<HTTPRequestParserContext>(parser.memory.data)

    var buffer: [Int8] = [Int8](count: length, repeatedValue: 0)
    memcpy(&buffer, data, length)
    context.memory.request.body += buffer

    return 0
}

func onRequestMessageComplete(parser: UnsafeMutablePointer<http_parser>) -> Int32 {
    let context = UnsafeMutablePointer<HTTPRequestParserContext>(parser.memory.data)

    let result = HTTPParseResult.Success(context.memory.request)
    context.memory.completion(result)

    context.memory.request.body = []
    context.memory.request.headers = [:]
    context.memory.request.method = .UNKNOWN
    context.memory.request.URI = RawURI()
    context.memory.request.majorVersion = 0
    context.memory.request.minorVersion = 0
    
    return 0
}
