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

public func parseRequest(stream stream: HTTPStream, completion: HTTPParseResult<RawHTTPRequest> -> Void) {

    struct HTTPParseContext {
        var request: RawHTTPRequest = RawHTTPRequest()
        var currentHeaderField: String = ""
        var completion: HTTPParseResult<RawHTTPRequest> -> Void

        init(completion: HTTPParseResult<RawHTTPRequest> -> Void) {
            self.completion = completion
        }
    }

    func onURL(parser: UnsafeMutablePointer<http_parser>, data: UnsafePointer<Int8>, length: Int) -> Int32 {
        let contextPointer = UnsafeMutablePointer<HTTPParseContext>(parser.memory.data)

        var buffer: [Int8] = [Int8](count: length + 1, repeatedValue: 0)
        strncpy(&buffer, data, length)
        contextPointer.memory.request.uri = String.fromCString(buffer)!

        return 0
    }

    func onHeaderField(parser: UnsafeMutablePointer<http_parser>, data: UnsafePointer<Int8>, length: Int) -> Int32 {
        let contextPointer = UnsafeMutablePointer<HTTPParseContext>(parser.memory.data)

        var buffer: [Int8] = [Int8](count: length + 1, repeatedValue: 0)
        strncpy(&buffer, data, length)
        contextPointer.memory.currentHeaderField += String.fromCString(buffer)!

        return 0
    }

    func onHeaderValue(parser: UnsafeMutablePointer<http_parser>, data: UnsafePointer<Int8>, length: Int) -> Int32 {
        let contextPointer = UnsafeMutablePointer<HTTPParseContext>(parser.memory.data)

        var buffer: [Int8] = [Int8](count: length + 1, repeatedValue: 0)
        strncpy(&buffer, data, length)
        let headerField = contextPointer.memory.currentHeaderField
        contextPointer.memory.request.headers[headerField] =
            (contextPointer.memory.request.headers[headerField] ?? "") + String.fromCString(buffer)!

        return 0
    }

    func onHeadersComplete(parser: UnsafeMutablePointer<http_parser>) -> Int32 {
        let contextPointer = UnsafeMutablePointer<HTTPParseContext>(parser.memory.data)

        contextPointer.memory.currentHeaderField = ""
        let method = http_method_str(http_method(parser.memory.method))
        contextPointer.memory.request.method = String.fromCString(method)!
        let major = parser.memory.http_major
        let minor = parser.memory.http_minor
        contextPointer.memory.request.version = "HTTP/\(major).\(minor)"

        return 0
    }

    func onBody(parser: UnsafeMutablePointer<http_parser>, data: UnsafePointer<Int8>, length: Int) -> Int32 {
        let contextPointer = UnsafeMutablePointer<HTTPParseContext>(parser.memory.data)

        var buffer: [Int8] = [Int8](count: length, repeatedValue: 0)
        memcpy(&buffer, data, length)
        contextPointer.memory.request.body += buffer

        return 0
    }

    func onMessageComplete(parser: UnsafeMutablePointer<http_parser>) -> Int32 {
        let contextPointer = UnsafeMutablePointer<HTTPParseContext>(parser.memory.data)
        let result = HTTPParseResult.Success(contextPointer.memory.request)
        contextPointer.memory.completion(result)
        free(contextPointer)

        return 0
    }

    let request = UnsafeMutablePointer<HTTPParseContext>.alloc(1)
    request.initialize(HTTPParseContext(completion: completion))
    var parser = http_parser()
    http_parser_init(&parser, HTTP_REQUEST)
    parser.data = UnsafeMutablePointer<Void>(request)

    var settings: http_parser_settings = http_parser_settings(
        on_message_begin: nil,
        on_url: onURL,
        on_status: nil,
        on_header_field: onHeaderField,
        on_header_value: onHeaderValue,
        on_headers_complete: onHeadersComplete,
        on_body: onBody,
        on_message_complete: onMessageComplete,
        on_chunk_header: nil,
        on_chunk_complete: nil
    )

    do {
        try stream.readData { buffer, length in
            let bytesParsed = http_parser_execute(&parser, &settings, buffer, length)

            if parser.upgrade == 1 {
                let error = HTTPParseError(description: "Upgrade not supported")
                completion(HTTPParseResult.Failure(error))
            }

            if bytesParsed != length {
                let errorString = http_errno_name(http_errno(parser.http_errno))
                let error = HTTPParseError(description: String.fromCString(errorString)!)
                completion(HTTPParseResult.Failure(error))
            }
        }
    } catch {
        completion(HTTPParseResult.Failure(error))
    }

}
