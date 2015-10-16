// HTTPParserTests.swift
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
    func sendToHandler(handler: (UnsafePointer<Int8>, Int) -> Void) {
        self.withCString { stringPointer in
            handler(stringPointer, self.utf8.count)
        }
    }

    func mapToBody() -> [Int8] {
        return ([] + self.utf8).map { Int8($0) }
    }
}

class HTTPParserTests: XCTestCase {

    func testShortRequest() {
        struct HTTPStreamMock : HTTPStream {
            private func readData(handler: (UnsafePointer<Int8>, Int) -> Void) throws {
                let data =
                "GET / HTTP/1.1\r\n" +
                "\r\n"
                data.sendToHandler(handler)
            }
        }
        parseRequest(stream: HTTPStreamMock()) { result in
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
            private func readData(handler: (UnsafePointer<Int8>, Int) -> Void) throws {
                "GET / HT".sendToHandler(handler)
                "TP/1.".sendToHandler(handler)
                "1\r\n".sendToHandler(handler)
                "\r\n".sendToHandler(handler)
            }
        }
        parseRequest(stream: HTTPStreamMock()) { result in
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
            private func readData(handler: (UnsafePointer<Int8>, Int) -> Void) throws {
                let data =
                "GET / HTTP/1.1\r\n" +
                "Host: zewo.co\r\n" +
                "\r\n"
                data.sendToHandler(handler)
            }
        }
        parseRequest(stream: HTTPStreamMock()) { result in
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
            private func readData(handler: (UnsafePointer<Int8>, Int) -> Void) throws {
                "GET / HTT".sendToHandler(handler)
                "P/1.1\r\n".sendToHandler(handler)
                "Hos".sendToHandler(handler)
                "t: zewo.c".sendToHandler(handler)
                "o\r\n".sendToHandler(handler)
                "\r".sendToHandler(handler)
                "\n".sendToHandler(handler)
            }
        }
        parseRequest(stream: HTTPStreamMock()) { result in
            result.success { request in
                print(request)
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
            private func readData(handler: (UnsafePointer<Int8>, Int) -> Void) throws {
                let data =
                "POST / HTTP/1.1\r\n" +
                "Content-Length: 4\r\n" +
                "\r\n" +
                "Zewo"
                data.sendToHandler(handler)
            }
        }
        parseRequest(stream: HTTPStreamMock()) { result in
            result.success { request in
                XCTAssert(request.method == "POST")
                XCTAssert(request.uri == "/")
                XCTAssert(request.version == "HTTP/1.1")
                XCTAssert(request.headers["Content-Length"] == "4")
                XCTAssert(request.body == "Zewo".mapToBody())
            }
            result.failure { error in
                XCTAssert(false)
            }
        }
    }

}
