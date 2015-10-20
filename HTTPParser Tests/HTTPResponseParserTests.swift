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
        let parser = HTTPResponseParser { _ in
            XCTAssert(false)
        }

        do {
            let data = ("howdy ho!")
            try parser.parse(data)
        } catch {
            XCTAssert(true)
        }
    }

    func testShortResponse() {
        let parser = HTTPResponseParser { response in
            XCTAssert(response.statusCode == 204)
            XCTAssert(response.reasonPhrase == "No Content")
            XCTAssert(response.majorVersion == 1)
            XCTAssert(response.minorVersion == 1)
            XCTAssert(response.headers == [:])
            XCTAssert(response.body == [])
        }

        do {
            let data = ("HTTP/1.1 204 No Content\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }

    func testDiscontinuousShortResponse() {
        let parser = HTTPResponseParser { response in
            XCTAssert(response.statusCode == 204)
            XCTAssert(response.reasonPhrase == "No Content")
            XCTAssert(response.majorVersion == 1)
            XCTAssert(response.minorVersion == 1)
            XCTAssert(response.headers == [:])
            XCTAssert(response.body == [])
        }

        do {
            let data1 = "HTTP/"
            let data2 = "1.1 2"
            let data3 = "04 No Co"
            let data4 = "ntent\r"
            let data5 = "\n"
            let data6 = "\r\n"

            try parser.parse(data1)
            try parser.parse(data2)
            try parser.parse(data3)
            try parser.parse(data4)
            try parser.parse(data5)
            try parser.parse(data6)
        } catch {
            XCTAssert(false)
        }
    }

    func testMediumResponse() {
        let parser = HTTPResponseParser { response in
            XCTAssert(response.statusCode == 204)
            XCTAssert(response.reasonPhrase == "No Content")
            XCTAssert(response.majorVersion == 1)
            XCTAssert(response.minorVersion == 1)
            XCTAssert(response.headers["Server"] == "Zewo/0.1")
            XCTAssert(response.body == [])
        }

        do {
            let data = ("HTTP/1.1 204 No Content\r\n" +
                        "Server: Zewo/0.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }

    func testDiscontinuousMediumResponse() {
        let parser = HTTPResponseParser { response in
            XCTAssert(response.statusCode == 204)
            XCTAssert(response.reasonPhrase == "No Content")
            XCTAssert(response.majorVersion == 1)
            XCTAssert(response.minorVersion == 1)
            XCTAssert(response.headers["Server"] == "Zewo/0.1")
            XCTAssert(response.body == [])
        }

        do {
            let data1 = "HTTP/1."
            let data2 = "1 204 No Content\r\nServer: Ze"
            let data3 = "wo/0.1\r\n\r"
            let data4 = "\n"

            try parser.parse(data1)
            try parser.parse(data2)
            try parser.parse(data3)
            try parser.parse(data4)
        } catch {
            XCTAssert(false)
        }
    }

    func testCompleteResponse() {
        let parser = HTTPResponseParser { response in
            XCTAssert(response.statusCode == 200)
            XCTAssert(response.reasonPhrase == "OK")
            XCTAssert(response.majorVersion == 1)
            XCTAssert(response.minorVersion == 1)
            XCTAssert(response.headers["Content-Length"] == "4")
            XCTAssert(response.body == "Zewo".bytes)
        }

        do {
            let data = ("HTTP/1.1 200 OK\r\n" +
                        "Content-Length: 4\r\n" +
                        "\r\n" +
                        "Zewo")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }

    func testDiscontinuousCompleteResponse() {
        let parser = HTTPResponseParser { response in
            XCTAssert(response.statusCode == 200)
            XCTAssert(response.reasonPhrase == "OK")
            XCTAssert(response.majorVersion == 1)
            XCTAssert(response.minorVersion == 1)
            XCTAssert(response.headers["Content-Length"] == "4")
            XCTAssert(response.body == "Zewo".bytes)
        }
        
        do {
            let data1 = "HTT"
            let data2 = "P/1.1 200 O"
            let data3 = "K\r\nContent-"
            let data4 = "Length: 4\r\n\r\nZewo"

            try parser.parse(data1)
            try parser.parse(data2)
            try parser.parse(data3)
            try parser.parse(data4)
        } catch {
            XCTAssert(false)
        }
    }

    func testManyResponses() {
        let data = ("HTTP/1.1 200 OK\r\n" +
                    "Content-Length: 4\r\n" +
                    "\r\n" +
                    "Zewo").bytes

        self.measureBlock {
            for _ in 0 ..< 10000 {
                let parser = HTTPResponseParser { _ in }
                do {
                    try parser.parse(data)
                } catch {
                    XCTAssert(false)
                }
            }
        }
    }

    func testUpgradeResponse() {
        let parser = HTTPResponseParser { _ in
            XCTAssert(true)
        }

        do {
            let data = ("HTTP/1.1 204 No Content\r\n" +
                        "Upgrade: WebSocket\r\n" +
                        "Connection: Upgrade\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(true)
        }
    }

    func testChunkedEncoding() {
        let parser = HTTPResponseParser { response in
            XCTAssert(response.statusCode == 200)
            XCTAssert(response.reasonPhrase == "OK")
            XCTAssert(response.majorVersion == 1)
            XCTAssert(response.minorVersion == 1)
            XCTAssert(response.headers["Transfer-Encoding"] == "chunked")
            XCTAssert(response.body == "Zewo".bytes)
        }

        do {
            let data = ("HTTP/1.1 200 OK\r\n" +
                        "Transfer-Encoding: chunked\r\n" +
                        "\r\n" +
                        "4\r\n" +
                        "Zewo\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }

    func testIncorrectContentLength() {
        let parser = HTTPResponseParser { _ in
            XCTAssert(false)
        }

        do {
            let data = ("HTTP/1.1 200 OK\r\n" +
                        "Content-Length: 5\r\n" +
                        "\r\n" +
                        "Zewo")
            try parser.parse(data)
        } catch {
            XCTAssert(true)
        }
    }

    func testIncorrectChunkSize() {
        let parser = HTTPResponseParser { _ in
            XCTAssert(false)
        }

        do {
            let data = ("HTTP/1.1 200 OK\r\n" +
                        "Transfer-Encoding: chunked\r\n" +
                        "\r\n" +
                        "5\r\n" +
                        "Zewo\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(true)
        }
    }

    func testInvalidChunkSize() {
        let parser = HTTPResponseParser { _ in
            XCTAssert(false)
        }

        do {
            let data = ("HTTP/1.1 200 OK\r\n" +
                        "Transfer-Encoding: chunked\r\n" +
                        "\r\n" +
                        "x\r\n" +
                        "Zewo\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(true)
        }
    }
    
    func testEOF() {
        let parser = HTTPResponseParser { response in
            XCTAssert(response.statusCode == 200)
            XCTAssert(response.reasonPhrase == "OK")
            XCTAssert(response.majorVersion == 1)
            XCTAssert(response.minorVersion == 1)
            XCTAssert(response.body == "Zewo".bytes)
        }

        do {
            let data = ("HTTP/1.1 200 OK\r\n" +
                        "\r\n" +
                        "Zewo")
            try parser.parse(data)
            try parser.eof()
        } catch {
            XCTAssert(false)
        }
    }
}
