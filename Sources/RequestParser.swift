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

        self.context = UnsafeMutablePointer<RequestParserContext>(allocatingCapacity: 1)
        self.context.initialize(RequestParserContext(completion: completion))

        http_parser_init(&self.parser, HTTP_REQUEST)
        self.parser.data = UnsafeMutablePointer<Void>(context)
    }

    deinit {
        context.destroy()
        context.deallocateCapacity(1)
    }

    public func parse(data: UnsafeMutablePointer<Void>, length: Int) throws {
        let bytesParsed = http_parser_execute(&parser, &requestSettings, UnsafeMutablePointer<Int8>(data), length)

        if bytesParsed != length {
            let errorName = http_errno_name(http_errno(parser.http_errno))
            let errorDescription = http_errno_description(http_errno(parser.http_errno))
            let error = ParseError(description: "\(String(validatingUTF8: errorName)!): \(String(validatingUTF8: errorDescription)!)")
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
    let context = UnsafeMutablePointer<RequestParserContext>(parser.pointee.data)

    var buffer: [Int8] = [Int8](count: length + 1, repeatedValue: 0)
    strncpy(&buffer, data, length)
    context.pointee.currentURI += String(validatingUTF8: buffer)!

    return 0
}

func onRequestHeaderField(parser: UnsafeMutablePointer<http_parser>, data: UnsafePointer<Int8>, length: Int) -> Int32 {
    let context = UnsafeMutablePointer<RequestParserContext>(parser.pointee.data)

    var buffer: [Int8] = [Int8](count: length + 1, repeatedValue: 0)
    strncpy(&buffer, data, length)
    context.pointee.buildingHeaderField += String(validatingUTF8: buffer)!

    return 0
}

func onRequestHeaderValue(parser: UnsafeMutablePointer<http_parser>, data: UnsafePointer<Int8>, length: Int) -> Int32 {
    let context = UnsafeMutablePointer<RequestParserContext>(parser.pointee.data)

    var buffer: [Int8] = [Int8](count: length + 1, repeatedValue: 0)
    strncpy(&buffer, data, length)
    if context.pointee.buildingHeaderField != "" {
        context.pointee.currentHeaderField = context.pointee.buildingHeaderField
    }
    context.pointee.buildingHeaderField = ""
    let headerField = context.pointee.currentHeaderField
    let previousHeaderValue = context.pointee.headers[headerField] ?? ""
    context.pointee.headers[headerField] = previousHeaderValue + String(validatingUTF8: buffer)!

    return 0
}

func onRequestHeadersComplete(parser: UnsafeMutablePointer<http_parser>) -> Int32 {
    let context = UnsafeMutablePointer<RequestParserContext>(parser.pointee.data)

    context.pointee.method = Method(code: Int(parser.pointee.method))
    context.pointee.majorVersion = Int(parser.pointee.http_major)
    context.pointee.minorVersion = Int(parser.pointee.http_minor)
    context.pointee.uri = URI(string: context.pointee.currentURI)

    context.pointee.currentURI = ""
    context.pointee.buildingHeaderField = ""
    context.pointee.currentHeaderField = ""

    return 0
}

func onRequestBody(parser: UnsafeMutablePointer<http_parser>, data: UnsafePointer<Int8>, length: Int) -> Int32 {
    let context = UnsafeMutablePointer<RequestParserContext>(parser.pointee.data)

    var buffer: [Int8] = [Int8](count: length, repeatedValue: 0)
    memcpy(&buffer, data, length)
    context.pointee.body += buffer

    return 0
}

func onRequestMessageComplete(parser: UnsafeMutablePointer<http_parser>) -> Int32 {
    let context = UnsafeMutablePointer<RequestParserContext>(parser.pointee.data)

    let request = Request(
        method: context.pointee.method,
        uri: context.pointee.uri,
        majorVersion: context.pointee.majorVersion,
        minorVersion: context.pointee.minorVersion,
        headers: context.pointee.headers,
        body: context.pointee.body
    )

    context.pointee.completion(request)

    context.pointee.method = nil
    context.pointee.uri = nil
    context.pointee.majorVersion = 0
    context.pointee.minorVersion = 0
    context.pointee.headers = [:]
    context.pointee.body = []

    return 0
}
