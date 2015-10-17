// HTTPRequestParserContext.swift
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

final class HTTPRequestParserContext {
    var request = RawHTTPRequest()
    var currentHeaderField = ""
    var completion: HTTPParseResult<RawHTTPRequest> -> Void

    init(completion: HTTPParseResult<RawHTTPRequest> -> Void) {
        self.completion = completion
    }
}

func onRequestURL(parser: UnsafeMutablePointer<http_parser>, data: UnsafePointer<Int8>, length: Int) -> Int32 {
    let context = UnsafeMutablePointer<HTTPRequestParserContext>(parser.memory.data)

    var buffer: [Int8] = [Int8](count: length + 1, repeatedValue: 0)
    strncpy(&buffer, data, length)
    context.memory.request.uri = String.fromCString(buffer)!

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
    context.memory.request.headers[headerField] =
        (context.memory.request.headers[headerField] ?? "") + String.fromCString(buffer)!

    return 0
}

func onRequestHeadersComplete(parser: UnsafeMutablePointer<http_parser>) -> Int32 {
    let context = UnsafeMutablePointer<HTTPRequestParserContext>(parser.memory.data)

    context.memory.currentHeaderField = ""
    let method = http_method_str(http_method(parser.memory.method))
    context.memory.request.method = String.fromCString(method)!
    let major = parser.memory.http_major
    let minor = parser.memory.http_minor
    context.memory.request.version = "HTTP/\(major).\(minor)"

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

    return 0
}

