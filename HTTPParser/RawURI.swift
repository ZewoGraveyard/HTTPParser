// RawURI.swift
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

public struct RawURI {
    public let scheme: String?
    public let userInfo: String?
    public let host: String?
    public let port: Int?
    public let path: String?
    public let query: String?
    public let fragment: String?

}

extension RawURI {
    init() {
        self.scheme = nil
        self.userInfo = nil
        self.host = nil
        self.port = nil
        self.path = nil
        self.query = nil
        self.fragment = nil
    }
}

extension RawURI {
    init(uri: parsed_uri) {
        self.scheme   = String.fromCString(uri.scheme)
        self.userInfo = String.fromCString(uri.user_info)
        self.host     = String.fromCString(uri.host)
        self.port     = (uri.port != nil) ? Int(uri.port.memory) : nil
        self.path     = String.fromCString(uri.path)
        self.query    = String.fromCString(uri.query)
        self.fragment = String.fromCString(uri.fragment)
    }
}

extension RawURI {
    public init(string: String) {
        self = RawURI(uri: parse_uri(string))
    }
}