// HTTPResponseParserTests.swift
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

class HTTPResponseParserTests: XCTestCase {

    func testMalformedRequest() {
        let parser = HTTPResponseParser { result in
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

    func testShortResponse() {
        let parser = HTTPResponseParser { result in
            result.success { response in
                XCTAssert(response.statusCode == 204)
                XCTAssert(response.reasonPhrase == "No Content")
                XCTAssert(response.version == "HTTP/1.1")
                XCTAssert(response.headers == [:])
                XCTAssert(response.body == [])
            }
            result.failure { error in
                XCTAssert(false)
            }
        }

        let data = ("HTTP/1.1 204 No Content\r\n" +
                    "\r\n").bytes

        parser.parse(data)
    }

    func testDiscontinuousShortResponse() {
        let parser = HTTPResponseParser { result in
            result.success { response in
                XCTAssert(response.statusCode == 204)
                XCTAssert(response.reasonPhrase == "No Content")
                XCTAssert(response.version == "HTTP/1.1")
                XCTAssert(response.headers == [:])
                XCTAssert(response.body == [])
            }
            result.failure { error in
                XCTAssert(false)
            }
        }

        let data1 = "HTTP/".bytes
        let data2 = "1.1 2".bytes
        let data3 = "04 No Co".bytes
        let data4 = "ntent\r".bytes
        let data5 = "\n".bytes
        let data6 = "\r\n".bytes

        parser.parse(data1)
        parser.parse(data2)
        parser.parse(data3)
        parser.parse(data4)
        parser.parse(data5)
        parser.parse(data6)
    }

    func testMediumResponse() {
        let parser = HTTPResponseParser { result in
            result.success { response in
                XCTAssert(response.statusCode == 204)
                XCTAssert(response.reasonPhrase == "No Content")
                XCTAssert(response.version == "HTTP/1.1")
                XCTAssert(response.headers["Server"] == "Zewo/0.1")
                XCTAssert(response.body == [])
            }
            result.failure { error in
                XCTAssert(false)
            }
        }

        let data = ("HTTP/1.1 204 No Content\r\n" +
                    "Server: Zewo/0.1\r\n" +
                    "\r\n").bytes

        parser.parse(data)
    }

    func testDiscontinuousMediumResponse() {
        let parser = HTTPResponseParser { result in
            result.success { response in
                XCTAssert(response.statusCode == 204)
                XCTAssert(response.reasonPhrase == "No Content")
                XCTAssert(response.version == "HTTP/1.1")
                XCTAssert(response.headers["Server"] == "Zewo/0.1")
                XCTAssert(response.body == [])
            }
            result.failure { error in
                XCTAssert(false)
            }
        }

        let data1 = "HTTP/1.".bytes
        let data2 = "1 204 No Content\r\nServer: Ze".bytes
        let data3 = "wo/0.1\r\n\r".bytes
        let data4 = "\n".bytes

        parser.parse(data1)
        parser.parse(data2)
        parser.parse(data3)
        parser.parse(data4)
    }

    func testCompleteResponse() {
        let parser = HTTPResponseParser { result in
            result.success { response in
                XCTAssert(response.statusCode == 204)
                XCTAssert(response.reasonPhrase == "No Content")
                XCTAssert(response.version == "HTTP/1.1")
                XCTAssert(response.headers["Content-Length"] == "4")
                XCTAssert(response.body == "Zewo".bytes)
            }
            result.failure { error in
                XCTAssert(false)
            }
        }

        let data = ("HTTP/1.1 204 No Content\r\n" +
                    "Content-Length: 4\r\n" +
                    "\r\n" +
                    "Zewo").bytes

        parser.parse(data)
    }

    func testDiscontinuousCompleteResponse() {
        let parser = HTTPResponseParser { result in
            result.success { response in
                XCTAssert(response.statusCode == 204)
                XCTAssert(response.reasonPhrase == "No Content")
                XCTAssert(response.version == "HTTP/1.1")
                XCTAssert(response.headers["Content-Length"] == "4")
                XCTAssert(response.body == "Zewo".bytes)
            }
            result.failure { error in
                XCTAssert(false)
            }
        }

        let data1 = "HTT".bytes
        let data2 = "P/1.1 204 No C".bytes
        let data3 = "ontent\r\nContent-".bytes
        let data4 = "Length: 4\r\n\r\nZewo".bytes

        parser.parse(data1)
        parser.parse(data2)
        parser.parse(data3)
        parser.parse(data4)
    }

    func testManyResponses() {
        let data = ("HTTP/1.1 204 No Content\r\n" +
                    "Content-Length: 4\r\n" +
                    "\r\n" +
                    "Zewo").bytes

        self.measureBlock {
            for _ in 0 ..< 10000 {
                let parser = HTTPResponseParser { result in
                    result.failure { _ in
                        XCTAssert(false)
                    }
                }
                parser.parse(data)
            }
        }
    }

    func testUpgradeResponse() {
        let parser = HTTPResponseParser { result in
            result.failure { _ in
                XCTAssert(false)
            }
        }

        let data = ("HTTP/1.1 204 No Content\r\n" +
                    "Upgrade: WebSocket\r\n" +
                    "\r\n").bytes

        parser.parse(data)
    }
}
