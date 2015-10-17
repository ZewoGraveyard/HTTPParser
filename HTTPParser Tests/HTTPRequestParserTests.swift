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

let performanceTestData = ("POST / HTTP/1.1\r\n" +
                           "Content-Length: 4\r\n" +
                           "\r\n" +
                           "Zewo").bytes

class HTTPRequestParserTests: XCTestCase {

    func testShortRequest() {
        struct HTTPStreamMock : HTTPStream {
            let data = ("GET / HTTP/1.1\r\n" +
                        "\r\n").bytes

            func readData(read: [Int8] -> Void, close: Void -> Void) throws {
                read(data)
                close()
            }
        }

        HTTPRequestParser.parse(HTTPStreamMock()) { result in
            result.success { request in
                XCTAssert(request.method == "GET")
                XCTAssert(request.uri == "/")
                XCTAssert(request.version == "HTTP/1.1")
                XCTAssert(request.headers == [:])
                XCTAssert(request.body == [])
            }
            result.failure { error in
                XCTAssert(false)
            }
        }
    }

    func testDiscontinuousShortRequest() {
        struct HTTPStreamMock : HTTPStream {
            let data1 = "GET / HT".bytes
            let data2 = "TP/1.".bytes
            let data3 = "1\r\n".bytes
            let data4 = "\r\n".bytes

            func readData(read: [Int8] -> Void, close: Void -> Void) throws {
                read(data1)
                read(data2)
                read(data3)
                read(data4)
                close()
            }
        }
        
        HTTPRequestParser.parse(HTTPStreamMock()) { result in
            result.success { request in
                XCTAssert(request.method == "GET")
                XCTAssert(request.uri == "/")
                XCTAssert(request.version == "HTTP/1.1")
                XCTAssert(request.headers == [:])
                XCTAssert(request.body == [])
            }
            result.failure { error in
                XCTAssert(false)
            }
        }
    }

    func testMediumRequest() {
        struct HTTPStreamMock : HTTPStream {
            let data = ("GET / HTTP/1.1\r\n" +
                        "Host: zewo.co\r\n" +
                        "\r\n").bytes

            func readData(read: [Int8] -> Void, close: Void -> Void) throws {
                read(data)
                close()
            }
        }

        HTTPRequestParser.parse(HTTPStreamMock()) { result in
            result.success { request in
                XCTAssert(request.method == "GET")
                XCTAssert(request.uri == "/")
                XCTAssert(request.version == "HTTP/1.1")
                XCTAssert(request.headers["Host"] == "zewo.co")
                XCTAssert(request.body == [])
            }
            result.failure { error in
                XCTAssert(false)
            }
        }
    }

    func testDiscontinuousMediumRequest() {
        struct HTTPStreamMock : HTTPStream {
            let data1 = "GET / HTT".bytes
            let data2 = "P/1.1\r\n".bytes
            let data3 = "Hos".bytes
            let data4 = "t: zewo.c".bytes
            let data5 = "o\r\n".bytes
            let data6 = "\r".bytes
            let data7 = "\n".bytes

            func readData(read: [Int8] -> Void, close: Void -> Void) throws {
                read(data1)
                read(data2)
                read(data3)
                read(data4)
                read(data5)
                read(data6)
                read(data7)
                close()
            }
        }

        HTTPRequestParser.parse(HTTPStreamMock()) { result in
            result.success { request in
                XCTAssert(request.method == "GET")
                XCTAssert(request.uri == "/")
                XCTAssert(request.version == "HTTP/1.1")
                XCTAssert(request.headers["Host"] == "zewo.co")
                XCTAssert(request.body == [])
            }
            result.failure { error in
                XCTAssert(false)
            }
        }
    }

    func testCompleteRequest() {
        struct HTTPStreamMock : HTTPStream {
            let data = ("POST / HTTP/1.1\r\n" +
                        "Content-Length: 4\r\n" +
                        "\r\n" +
                        "Zewo").bytes
            func readData(read: [Int8] -> Void, close: Void -> Void) throws {
                read(data)
                close()
            }
        }

        HTTPRequestParser.parse(HTTPStreamMock()) { result in
            result.success { request in
                XCTAssert(request.method == "POST")
                XCTAssert(request.uri == "/")
                XCTAssert(request.version == "HTTP/1.1")
                XCTAssert(request.headers["Content-Length"] == "4")
                XCTAssert(request.body == "Zewo".bytes)
            }
            result.failure { error in
                XCTAssert(false)
            }
        }
    }
    
    func testManyRequests() {
        struct HTTPStreamMock : HTTPStream {
            func readData(read: [Int8] -> Void, close: Void -> Void) throws {
                read(performanceTestData)
                close()
            }
        }

        let streamMock = HTTPStreamMock()

        self.measureBlock {
            for _ in 0 ..< 10000 {
                HTTPRequestParser.parse(streamMock) { result in
                    result.success { _ in }
                    result.failure { error in
                        XCTAssert(false)
                    }
                }
            }
        }
    }

    func testMultipleShortRequestsInTheSameStream() {
        struct HTTPStreamMock : HTTPStream {
            let data1 = "GET / HT".bytes
            let data2 = "TP/1.".bytes
            let data3 = "1\r\n".bytes
            let data4 = "\r\n".bytes

            let data5 = "HEAD /profile HT".bytes
            let data6 = "TP/1.".bytes
            let data7 = "1\r\n".bytes
            let data8 = "\r\n".bytes

            func readData(read: [Int8] -> Void, close: Void -> Void) throws {
                read(data1)
                read(data2)
                read(data3)
                read(data4)
                read(data5)
                read(data6)
                read(data7)
                read(data8)
                close()
            }
        }

        var requestCount = 0

        HTTPRequestParser.parse(HTTPStreamMock()) { result in
            result.success { request in
                ++requestCount
                if requestCount == 1 {
                    XCTAssert(request.method == "GET")
                    XCTAssert(request.uri == "/")
                } else {
                    XCTAssert(request.method == "HEAD")
                    XCTAssert(request.uri == "/profile")
                }
                XCTAssert(request.version == "HTTP/1.1")
                XCTAssert(request.headers == [:])
                XCTAssert(request.body == [])
            }
            result.failure { error in
                XCTAssert(false)
            }
        }
    }

}
