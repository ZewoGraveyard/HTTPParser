// HTTPRequestParserTests.swift
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

import XCTest
import HTTPParser

extension String {
    var bytes: [Int8] {
        return self.utf8.map { Int8($0) }
    }
}

class HTTPRequestParserTests: XCTestCase {

    func testMalformedRequest() {
        let parser = HTTPRequestParser { result in
            result.success { request in
                XCTAssert(false)
            }
            result.failure { error in
                XCTAssert(true)
            }
        }

        let data = ("howdy ho!").bytes

        parser.parse(data)
    }

    func testShortRequest() {
        let parser = HTTPRequestParser { result in
            result.success { request in
                XCTAssert(request.method == "GET")
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.majorVersion == 1)
                XCTAssert(request.minorVersion == 1)
                XCTAssert(request.headers == [:])
                XCTAssert(request.body == [])
            }
            result.failure { error in
                XCTAssert(false)
            }
        }
        let data = ("GET / HTTP/1.1\r\n" +
                    "\r\n").bytes
        parser.parse(data)
    }

    func testDiscontinuousShortRequest() {
        let parser = HTTPRequestParser { result in
            result.success { request in
                XCTAssert(request.method == "GET")
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.majorVersion == 1)
                XCTAssert(request.minorVersion == 1)
                XCTAssert(request.headers == [:])
                XCTAssert(request.body == [])
            }
            result.failure { error in
                XCTAssert(false)
            }
        }

        let data1 = "GET / HT".bytes
        let data2 = "TP/1.".bytes
        let data3 = "1\r\n".bytes
        let data4 = "\r\n".bytes

        parser.parse(data1)
        parser.parse(data2)
        parser.parse(data3)
        parser.parse(data4)
    }

    func testMediumRequest() {
        let parser = HTTPRequestParser { result in
            result.success { request in
                XCTAssert(request.method == "GET")
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.majorVersion == 1)
                XCTAssert(request.minorVersion == 1)
                XCTAssert(request.headers["Host"] == "zewo.co")
                XCTAssert(request.body == [])
            }
            result.failure { error in
                XCTAssert(false)
            }
        }

        let data = ("GET / HTTP/1.1\r\n" +
                    "Host: zewo.co\r\n" +
                    "\r\n").bytes

        parser.parse(data)
    }

    func testDiscontinuousMediumRequest() {
        let parser = HTTPRequestParser { result in
            result.success { request in
                XCTAssert(request.method == "GET")
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.majorVersion == 1)
                XCTAssert(request.minorVersion == 1)
                XCTAssert(request.headers["Host"] == "zewo.co")
                XCTAssert(request.body == [])
            }
            result.failure { error in
                XCTAssert(false)
            }
        }

        let data1 = "GET / HTT".bytes
        let data2 = "P/1.1\r\n".bytes
        let data3 = "Hos".bytes
        let data4 = "t: zewo.c".bytes
        let data5 = "o\r\n".bytes
        let data6 = "\r".bytes
        let data7 = "\n".bytes

        parser.parse(data1)
        parser.parse(data2)
        parser.parse(data3)
        parser.parse(data4)
        parser.parse(data5)
        parser.parse(data6)
        parser.parse(data7)
    }

    func testCompleteRequest() {
        let parser = HTTPRequestParser { result in
            result.success { request in
                XCTAssert(request.method == "POST")
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.majorVersion == 1)
                XCTAssert(request.minorVersion == 1)
                XCTAssert(request.headers["Content-Length"] == "4")
                XCTAssert(request.body == "Zewo".bytes)
            }
            result.failure { error in
                XCTAssert(false)
            }
        }

        let data = ("POST / HTTP/1.1\r\n" +
                    "Content-Length: 4\r\n" +
                    "\r\n" +
                    "Zewo").bytes

        parser.parse(data)
    }

    func testDiscontinuousCompleteRequest() {
        let parser = HTTPRequestParser { result in
            result.success { request in
                XCTAssert(request.method == "POST")
                XCTAssert(request.uri.path == "/profile")
                XCTAssert(request.majorVersion == 1)
                XCTAssert(request.minorVersion == 1)
                XCTAssert(request.headers["Content-Length"] == "4")
                XCTAssert(request.body == "Zewo".bytes)
            }
            result.failure { error in
                XCTAssert(false)
            }
        }

        let data1 = "PO".bytes
        let data2 = "ST /pro".bytes
        let data3 = "file HTT".bytes
        let data4 = "P/1.1\r\n".bytes
        let data5 = "Cont".bytes
        let data6 = "ent-Length: 4".bytes
        let data7 = "\r\n".bytes
        let data8 = "\r".bytes
        let data9 = "\n".bytes
        let data10 = "Ze".bytes
        let data11 = "wo".bytes

        parser.parse(data1)
        parser.parse(data2)
        parser.parse(data3)
        parser.parse(data4)
        parser.parse(data5)
        parser.parse(data6)
        parser.parse(data7)
        parser.parse(data8)
        parser.parse(data9)
        parser.parse(data10)
        parser.parse(data11)
    }

    func testMultipleShortRequestsInTheSameStream() {
        var requestCount = 0

        let parser = HTTPRequestParser { result in
            result.success { request in
                ++requestCount
                if requestCount == 1 {
                    XCTAssert(request.method == "GET")
                    XCTAssert(request.uri.path == "/")
                } else {
                    XCTAssert(request.method == "HEAD")
                    XCTAssert(request.uri.path == "/profile")
                }
                XCTAssert(request.majorVersion == 1)
                XCTAssert(request.minorVersion == 1)
                XCTAssert(request.headers == [:])
                XCTAssert(request.body == [])
            }
            result.failure { error in
                XCTAssert(false)
            }
        }

        let data1 = "GET / HT".bytes
        let data2 = "TP/1.".bytes
        let data3 = "1\r\n".bytes
        let data4 = "\r\n".bytes

        let data5 = "HEAD /profile HT".bytes
        let data6 = "TP/1.".bytes
        let data7 = "1\r\n".bytes
        let data8 = "\r\n".bytes

        parser.parse(data1)
        parser.parse(data2)
        parser.parse(data3)
        parser.parse(data4)
        parser.parse(data5)
        parser.parse(data6)
        parser.parse(data7)
        parser.parse(data8)
    }

    func testManyRequests() {
        let data = ("POST / HTTP/1.1\r\n" +
                    "Content-Length: 4\r\n" +
                    "\r\n" +
                    "Zewo").bytes

        self.measureBlock {
            for _ in 0 ..< 10000 {
                let parser = HTTPRequestParser { result in
                    result.failure { _ in
                        XCTAssert(false)
                    }
                }
                parser.parse(data)
            }
        }
    }

    func testUpgradeRequests() {
        let parser = HTTPRequestParser { result in
            result.failure { _ in
                XCTAssert(true)
            }
        }

        let data = ("GET / HTTP/1.1\r\n" +
                    "Upgrade: WebSocket\r\n" +
                    "Connection: Upgrade\r\n" +
                    "\r\n").bytes

        parser.parse(data)
    }

    func testChunkedEncoding() {
        let parser = HTTPRequestParser { result in
            result.success { request in
                XCTAssert(request.method == "GET")
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.majorVersion == 1)
                XCTAssert(request.minorVersion == 1)
                XCTAssert(request.headers["Transfer-Encoding"] == "chunked")
                XCTAssert(request.body == "Zewo".bytes)
            }
            result.failure { error in
                XCTAssert(false)
            }
        }

        let data = ("GET / HTTP/1.1\r\n" +
                    "Transfer-Encoding: chunked\r\n" +
                    "\r\n" +
                    "4\r\n" +
                    "Zewo\r\n").bytes

        parser.parse(data)
    }

    func testIncorrectContentLength() {
        let parser = HTTPRequestParser { result in
            result.success { request in
                XCTAssert(false)
            }
            result.failure { error in
                XCTAssert(true)
            }
        }

        let data = ("POST / HTTP/1.1\r\n" +
                    "Content-Length: 5\r\n" +
                    "\r\n" +
                    "Zewo").bytes

        parser.parse(data)
    }

    func testIncorrectChunkSize() {
        let parser = HTTPRequestParser { result in
            result.success { request in
                XCTAssert(false)
            }
            result.failure { error in
                XCTAssert(true)
            }
        }

        let data = ("GET / HTTP/1.1\r\n" +
                    "Transfer-Encoding: chunked\r\n" +
                    "\r\n" +
                    "5\r\n" +
                    "Zewo\r\n").bytes

        parser.parse(data)
    }

    func testInvalidChunkSize() {
        let parser = HTTPRequestParser { result in
            result.success { request in
                XCTAssert(false)
            }
            result.failure { error in
                XCTAssert(true)
            }
        }

        let data = ("GET / HTTP/1.1\r\n" +
                    "Transfer-Encoding: chunked\r\n" +
                    "\r\n" +
                    "x\r\n" +
                    "Zewo\r\n").bytes

        parser.parse(data)
    }

    func testConnectionKeepAlive() {
        let parser = HTTPRequestParser { result in
            result.success { request in
                XCTAssert(request.method == "GET")
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.majorVersion == 1)
                XCTAssert(request.minorVersion == 1)
                XCTAssert(request.headers["Connection"] == "keep-alive")
            }
            result.failure { error in
                XCTAssert(false)
            }
        }

        let data = ("GET / HTTP/1.1\r\n" +
                    "Connection: keep-alive\r\n" +
                    "\r\n").bytes

        parser.parse(data)
    }

    func testConnectionClose() {
        let parser = HTTPRequestParser { result in
            result.success { request in
                XCTAssert(request.method == "GET")
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.majorVersion == 1)
                XCTAssert(request.minorVersion == 1)
                XCTAssert(request.headers["Connection"] == "close")
            }
            result.failure { error in
                XCTAssert(false)
            }
        }

        let data = ("GET / HTTP/1.1\r\n" +
            "Connection: close\r\n" +
            "\r\n").bytes

        parser.parse(data)
    }

    func testRequestHTTP1_0() {
        let parser = HTTPRequestParser { result in
            result.success { request in
                XCTAssert(request.method == "GET")
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.majorVersion == 1)
                XCTAssert(request.minorVersion == 0)
            }
            result.failure { error in
                XCTAssert(false)
            }
        }

        let data = ("GET / HTTP/1.0\r\n" +
                    "\r\n").bytes

        parser.parse(data)
    }

    func testRawURI() {
        let URIString = "http://username:password@www.google.com:777/foo/bar?foo=bar&for=baz#yeah"
        let URI = RawURI(string: URIString)
        XCTAssert(URI.scheme == "http")
        XCTAssert(URI.userInfo == "username:password")
        XCTAssert(URI.host == "www.google.com")
        XCTAssert(URI.port == 777)
        XCTAssert(URI.path == "/foo/bar")
        XCTAssert(URI.query == "foo=bar&for=baz")
        XCTAssert(URI.fragment == "yeah")
    }

    func testRawURIIPv6() {
        let URIString = "http://username:password@[2001:db8:1f70::999:de8:7648:6e8]:100/foo/bar?foo=bar&for=baz#yeah"
        let URI = RawURI(string: URIString)
        XCTAssert(URI.scheme == "http")
        XCTAssert(URI.userInfo == "username:password")
        XCTAssert(URI.host == "2001:db8:1f70::999:de8:7648:6e8")
        XCTAssert(URI.port == 100)
        XCTAssert(URI.path == "/foo/bar")
        XCTAssert(URI.query == "foo=bar&for=baz")
        XCTAssert(URI.fragment == "yeah")
    }

    func testRawURIIPv6WithZone() {
        let URIString = "http://username:password@[2001:db8:a0b:12f0::1%eth0]:100/foo/bar?foo=bar&for=baz#yeah"
        let URI = RawURI(string: URIString)
        XCTAssert(URI.scheme == "http")
        XCTAssert(URI.userInfo == "username:password")
        XCTAssert(URI.host == "2001:db8:a0b:12f0::1%eth0")
        XCTAssert(URI.port == 100)
        XCTAssert(URI.path == "/foo/bar")
        XCTAssert(URI.query == "foo=bar&for=baz")
        XCTAssert(URI.fragment == "yeah")
    }
}