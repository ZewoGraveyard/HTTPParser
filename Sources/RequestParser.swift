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

import CHTTPParser

typealias RequestContext = UnsafeMutablePointer<RequestParserContext>

struct RequestParserContext {
    var method: Method! = nil
    var uri: URI! = nil
    var version: Version = Version(major: 0, minor: 0)
    var headers: Headers = Headers([:])
    var body: Data = []

    var currentURI = ""
    var buildingHeaderName = ""
    var currentHeaderName: CaseInsensitiveString = ""
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

public final class RequestParser: S4.RequestParser {
    let context: RequestContext
    var parser = http_parser()
    var request: Request?

    public init() {
        context = RequestContext(allocatingCapacity: 1)
        context.initialize(with: RequestParserContext { request in
            self.request = request
            })

        resetParser()
    }

    deinit {
        context.deinitialize(count:1)
        context.deallocateCapacity(1)
    }

    func resetParser() {
        http_parser_init(&parser, HTTP_REQUEST)
        parser.data = UnsafeMutablePointer<Void>(context)
    }

    public func parse(_ data: Data) throws -> Request? {
        defer { request = nil }

        let buffer = data.withUnsafeBufferPointer {
            UnsafeMutablePointer<Int8>($0.baseAddress)
        }

        let bytesParsed = http_parser_execute(&parser, &requestSettings, buffer, data.count)

        if bytesParsed != data.count {
            resetParser()
            let errorName = http_errno_name(http_errno(parser.http_errno))
            let errorDescription = http_errno_description(http_errno(parser.http_errno))
            let error = ParseError(description: "\(String(validatingUTF8: errorName)!): \(String(validatingUTF8: errorDescription)!)")
            throw error
        }

        if request != nil {
            resetParser()
        }

        return request
    }
}

extension RequestParser {
    public func parse(_ convertible: DataConvertible) throws -> Request? {
        return try parse(convertible.data)
    }
}

func onRequestURL(_ parser: Parser, data: UnsafePointer<Int8>!, length: Int) -> Int32 {
    return RequestContext(parser.pointee.data).withMemory {
        guard let uri = String(pointer: data, length: length) else {
            return 1
        }

        $0.currentURI += uri
        return 0
    }
}

func onRequestHeaderField(_ parser: Parser, data: UnsafePointer<Int8>!, length: Int) -> Int32 {
    return RequestContext(parser.pointee.data).withMemory {
        guard let headerName = String(pointer: data, length: length) else {
            return 1
        }

        if $0.currentHeaderName != "" {
            $0.currentHeaderName = ""
        }

        $0.buildingHeaderName += headerName
        return 0
    }
}

func onRequestHeaderValue(_ parser: Parser, data: UnsafePointer<Int8>!, length: Int) -> Int32 {
    return RequestContext(parser.pointee.data).withMemory {
        guard let headerValue = String(pointer: data, length: length) else {
            return 1
        }

        if $0.currentHeaderName == "" {
            $0.currentHeaderName = CaseInsensitiveString($0.buildingHeaderName)
            $0.buildingHeaderName = ""

            $0.headers[$0.currentHeaderName].append("")
        }

        let previousHeaderValue = $0.headers[$0.currentHeaderName].values.last ?? ""
        $0.headers[$0.currentHeaderName][$0.headers[$0.currentHeaderName].count - 1] = previousHeaderValue + headerValue

        return 0
    }
}

func onRequestHeadersComplete(_ parser: Parser) -> Int32 {
    return RequestContext(parser.pointee.data).withMemory {
        $0.method = Method(code: Int(parser.pointee.method))
        let major = Int(parser.pointee.http_major)
        let minor = Int(parser.pointee.http_minor)
        $0.version = Version(major: major, minor: minor)

        guard let uri = try? URI($0.currentURI) else {
            return 1
        }

        $0.uri = uri
        $0.currentURI = ""
        $0.buildingHeaderName = ""
        $0.currentHeaderName = ""
        return 0
    }
}

func onRequestBody(_ parser: Parser, data: UnsafePointer<Int8>!, length: Int) -> Int32 {
    RequestContext(parser.pointee.data).withMemory {
        $0.body += Data(pointer: data, length: length)
        return
    }

    return 0
}

func onRequestMessageComplete(_ parser: Parser) -> Int32 {
    return RequestContext(parser.pointee.data).withMemory {
        let request = Request(
            method: $0.method,
            uri: $0.uri,
            version: $0.version,
            headers: $0.headers,
            body: .buffer($0.body)
        )

        $0.completion(request)

        $0.method = nil
        $0.uri = nil
        $0.version = Version(major: 0, minor: 0)
        $0.headers = Headers([:])
        $0.body = []
        return 0
    }
}
