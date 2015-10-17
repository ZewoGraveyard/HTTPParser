// HTTPResponseParserContext.swift
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

final class HTTPResponseParserCompletionContext {
    var completion: HTTPParseResult<RawHTTPResponse> -> Void

    init(completion: HTTPParseResult<RawHTTPResponse> -> Void) {
        self.completion = completion
    }
}

final class HTTPResponseParserContext {
    var response = RawHTTPResponse()
    var currentHeaderField = ""
    var completion: HTTPParseResult<RawHTTPResponse> -> Void

    init(completion: HTTPParseResult<RawHTTPResponse> -> Void) {
        self.completion = completion
    }
}

func onResponseMessageBegin(parser: UnsafeMutablePointer<http_parser>) -> Int32 {
    let completionContext = UnsafeMutablePointer<HTTPResponseParserCompletionContext>(parser.memory.data)

    let context = UnsafeMutablePointer<HTTPResponseParserContext>.alloc(1)
    context.initialize(HTTPResponseParserContext(completion: completionContext.memory.completion))
    parser.memory.data = UnsafeMutablePointer<Void>(context)

    return 0
}

func onResponseStatus(parser: UnsafeMutablePointer<http_parser>, data: UnsafePointer<Int8>, length: Int) -> Int32 {
    let context = UnsafeMutablePointer<HTTPResponseParserContext>(parser.memory.data)

    var buffer: [Int8] = [Int8](count: length + 1, repeatedValue: 0)
    strncpy(&buffer, data, length)
    context.memory.response.reasonPhrase = (context.memory.response.reasonPhrase ?? "") + String.fromCString(buffer)!

    return 0

}

func onResponseHeaderField(parser: UnsafeMutablePointer<http_parser>, data: UnsafePointer<Int8>, length: Int) -> Int32 {
    let context = UnsafeMutablePointer<HTTPResponseParserContext>(parser.memory.data)

    var buffer: [Int8] = [Int8](count: length + 1, repeatedValue: 0)
    strncpy(&buffer, data, length)
    context.memory.currentHeaderField += String.fromCString(buffer)!

    return 0
}

func onResponseHeaderValue(parser: UnsafeMutablePointer<http_parser>, data: UnsafePointer<Int8>, length: Int) -> Int32 {
    let context = UnsafeMutablePointer<HTTPResponseParserContext>(parser.memory.data)

    var buffer: [Int8] = [Int8](count: length + 1, repeatedValue: 0)
    strncpy(&buffer, data, length)
    let headerField = context.memory.currentHeaderField
    context.memory.response.headers[headerField] =
        (context.memory.response.headers[headerField] ?? "") + String.fromCString(buffer)!

    return 0
}

func onResponseHeadersComplete(parser: UnsafeMutablePointer<http_parser>) -> Int32 {
    let context = UnsafeMutablePointer<HTTPResponseParserContext>(parser.memory.data)

    context.memory.currentHeaderField = ""
    context.memory.response.statusCode = Int(parser.memory.status_code)

    let major = parser.memory.http_major
    let minor = parser.memory.http_minor
    context.memory.response.version = "HTTP/\(major).\(minor)"

    return 0
}

func onResponseBody(parser: UnsafeMutablePointer<http_parser>, data: UnsafePointer<Int8>, length: Int) -> Int32 {
    let context = UnsafeMutablePointer<HTTPResponseParserContext>(parser.memory.data)

    var buffer: [Int8] = [Int8](count: length, repeatedValue: 0)
    memcpy(&buffer, data, length)
    context.memory.response.body += buffer

    return 0
}

func onResponseMessageComplete(parser: UnsafeMutablePointer<http_parser>) -> Int32 {
    let context = UnsafeMutablePointer<HTTPResponseParserContext>(parser.memory.data)

    let result = HTTPParseResult.Success(context.memory.response)
    context.memory.completion(result)

    let completionContext = UnsafeMutablePointer<HTTPResponseParserCompletionContext>.alloc(1)
    completionContext.initialize(HTTPResponseParserCompletionContext(completion: context.memory.completion))
    parser.memory.data = UnsafeMutablePointer<Void>(completionContext)

    context.destroy()
    context.dealloc(1)

    return 0
}