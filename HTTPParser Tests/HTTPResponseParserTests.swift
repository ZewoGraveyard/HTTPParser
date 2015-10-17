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

    func testShortResponse() {
        struct HTTPStreamMock : HTTPStream {
            let data = ("HTTP/1.1 204 No Content\r\n" +
                        "\r\n").bytes

            func readData(read: [Int8] -> Void) throws {
                read(data)
            }
        }
        
        parseResponse(stream: HTTPStreamMock()) { result in
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
    }

    func testDiscontinuousShortResponse() {
        struct HTTPStreamMock : HTTPStream {
            let data1 = "HTTP/".bytes
            let data2 = "1.1 2".bytes
            let data3 = "04 No Co".bytes
            let data4 = "ntent\r".bytes
            let data5 = "\n".bytes
            let data6 = "\r\n".bytes

            func readData(read: [Int8] -> Void) throws {
                read(data1)
                read(data2)
                read(data3)
                read(data4)
                read(data5)
                read(data6)
            }
        }

        parseResponse(stream: HTTPStreamMock()) { result in
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
    }

    func testMediumResponse() {
        struct HTTPStreamMock : HTTPStream {
            let data = ("HTTP/1.1 204 No Content\r\n" +
                        "Server: Zewo/0.1\r\n" +
                        "\r\n").bytes

            func readData(read: [Int8] -> Void) throws {
                read(data)
            }
        }

        parseResponse(stream: HTTPStreamMock()) { result in
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
    }

    func testDiscontinuousMediumResponse() {
        struct HTTPStreamMock : HTTPStream {
            let data1 = "HTTP/1.".bytes
            let data2 = "1 204 No Content\r\nServer: Ze".bytes
            let data3 = "wo/0.1\r\n\r".bytes
            let data4 = "\n".bytes

            func readData(read: [Int8] -> Void) throws {
                read(data1)
                read(data2)
                read(data3)
                read(data4)
            }
        }

        parseResponse(stream: HTTPStreamMock()) { result in
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
    }

    func testCompleteResponse() {
        struct HTTPStreamMock : HTTPStream {
            let data = ("HTTP/1.1 204 No Content\r\n" +
                        "Content-Length: 4\r\n" +
                        "\r\n" +
                        "Zewo").bytes

            func readData(read: [Int8] -> Void) throws {
                read(data)
            }
        }

        parseResponse(stream: HTTPStreamMock()) { result in
            result.success { response in
                print(response)
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
    }

    func testDiscontinuousCompleteResponse() {
        struct HTTPStreamMock : HTTPStream {
            let data1 = "HTT".bytes
            let data2 = "P/1.1 204 No C".bytes
            let data3 = "ontent\r\nContent-".bytes
            let data4 = "Length: 4\r\n\r\nZewo".bytes

            func readData(read: [Int8] -> Void) throws {
                read(data1)
                read(data2)
                read(data3)
                read(data4)
            }
        }

        parseResponse(stream: HTTPStreamMock()) { result in
            result.success { response in
                print(response)
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
    }

}
