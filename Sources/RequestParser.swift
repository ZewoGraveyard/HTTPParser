// RequestParser.swift
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

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif
import Core
import HTTP
import CHTTPParser

struct RequestParserContext {
    var method: Method! = nil
    var uri: URI! = nil
    var majorVersion: Int = 0
    var minorVersion: Int = 0
    var headers: [String: String] = [:]
    var body: [Int8] = []

    var currentURI = ""
    var buildingHeaderField = ""
    var currentHeaderField = ""
    var completion: Request -> Void

    init(completion: Request -> Void) {
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

public final class RequestParser {
    let completion: Request -> Void
    let context: UnsafeMutablePointer<RequestParserContext>
    var parser = http_parser()

    public init(completion: Request -> Void) {
        self.completion = completion

        self.context = UnsafeMutablePointer<RequestParserContext>.alloc(1)
        self.context.initialize(RequestParserContext(completion: completion))

        http_parser_init(&self.parser, HTTP_REQUEST)
        self.parser.data = UnsafeMutablePointer<Void>(context)
    }

    deinit {
        context.destroy()
        context.dealloc(1)
    }

    public func parse(data: UnsafeMutablePointer<Void>, length: Int) throws {
        let bytesParsed = http_parser_execute(&parser, &requestSettings, UnsafeMutablePointer<Int8>(data), length)

        if bytesParsed != length {
            let errorName = http_errno_name(http_errno(parser.http_errno))
            let errorDescription = http_errno_description(http_errno(parser.http_errno))
            let error = ParseError(description: "\(String.fromCString(errorName)!): \(String.fromCString(errorDescription)!)")
            throw error
        }
    }
}

extension RequestParser {
    public func parse(data: [Int8]) throws {
        var data = data
        try parse(&data, length: data.count)
    }

    public func parse(string: String) throws {
        var data = string.utf8.map { Int8($0) }
        try parse(&data, length: data.count)
    }
}

func onRequestURL(parser: UnsafeMutablePointer<http_parser>, data: UnsafePointer<Int8>, length: Int) -> Int32 {
    let context = UnsafeMutablePointer<RequestParserContext>(parser.memory.data)

    var buffer: [Int8] = [Int8](count: length + 1, repeatedValue: 0)
    strncpy(&buffer, data, length)
    context.memory.currentURI += String.fromCString(buffer)!

    return 0
}

func onRequestHeaderField(parser: UnsafeMutablePointer<http_parser>, data: UnsafePointer<Int8>, length: Int) -> Int32 {
    let context = UnsafeMutablePointer<RequestParserContext>(parser.memory.data)

    var buffer: [Int8] = [Int8](count: length + 1, repeatedValue: 0)
    strncpy(&buffer, data, length)
    context.memory.buildingHeaderField += String.fromCString(buffer)!

    return 0
}

func onRequestHeaderValue(parser: UnsafeMutablePointer<http_parser>, data: UnsafePointer<Int8>, length: Int) -> Int32 {
    let context = UnsafeMutablePointer<RequestParserContext>(parser.memory.data)

    var buffer: [Int8] = [Int8](count: length + 1, repeatedValue: 0)
    strncpy(&buffer, data, length)
    if context.memory.buildingHeaderField != "" {
        context.memory.currentHeaderField = context.memory.buildingHeaderField
    }
    context.memory.buildingHeaderField = ""
    let headerField = context.memory.currentHeaderField
    let previousHeaderValue = context.memory.headers[headerField] ?? ""
    context.memory.headers[headerField] = previousHeaderValue + String.fromCString(buffer)!

    return 0
}

func onRequestHeadersComplete(parser: UnsafeMutablePointer<http_parser>) -> Int32 {
    let context = UnsafeMutablePointer<RequestParserContext>(parser.memory.data)

    context.memory.method = Method(code: Int(parser.memory.method))
    context.memory.majorVersion = Int(parser.memory.http_major)
    context.memory.minorVersion = Int(parser.memory.http_minor)
    context.memory.uri = URI(string: context.memory.currentURI)

    context.memory.currentURI = ""
    context.memory.buildingHeaderField = ""
    context.memory.currentHeaderField = ""

    return 0
}

func onRequestBody(parser: UnsafeMutablePointer<http_parser>, data: UnsafePointer<Int8>, length: Int) -> Int32 {
    let context = UnsafeMutablePointer<RequestParserContext>(parser.memory.data)

    var buffer: [Int8] = [Int8](count: length, repeatedValue: 0)
    memcpy(&buffer, data, length)
    context.memory.body += buffer

    return 0
}

func onRequestMessageComplete(parser: UnsafeMutablePointer<http_parser>) -> Int32 {
    let context = UnsafeMutablePointer<RequestParserContext>(parser.memory.data)

    let request = Request(
        method: context.memory.method,
        uri: context.memory.uri,
        majorVersion: context.memory.majorVersion,
        minorVersion: context.memory.minorVersion,
        headers: context.memory.headers,
        body: context.memory.body
    )

    context.memory.completion(request)

    context.memory.method = nil
    context.memory.uri = nil
    context.memory.majorVersion = 0
    context.memory.minorVersion = 0
    context.memory.headers = [:]
    context.memory.body = []

    return 0
}
