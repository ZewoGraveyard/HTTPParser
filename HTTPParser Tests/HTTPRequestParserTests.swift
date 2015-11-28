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
import URI
import HTTP
import HTTPParser

extension String {
    var bytes: [Int8] {
        return self.utf8.map { Int8($0) }
    }
}

class HTTPRequestParserTests: XCTestCase {

    func testInvalidMethod() {
        let parser = HTTPRequestParser { request in
            XCTAssert(false)
        }

        do {
            let data = ("INVALID / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(true)
        }
    }

    func testShortDELETERequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .DELETE)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }

        do {
            let data = ("DELETE / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }

    func testShortGETRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .GET)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }

        do {
            let data = ("GET / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }

    func testShortHEADRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .HEAD)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }

        do {
            let data = ("HEAD / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }

    func testShortPOSTRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .POST)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }

        do {
            let data = ("POST / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }

    func testShortPUTRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .PUT)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }

        do {
            let data = ("PUT / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }

    func testShortCONNECTRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .CONNECT)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }

        do {
            let data = ("CONNECT / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(true) // Upgrade related
        }
    }

    func testShortOPTIONSRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .OPTIONS)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }

        do {
            let data = ("OPTIONS / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(true) // Upgrade related
        }
    }

    func testShortTRACERequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .TRACE)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }

        do {
            let data = ("TRACE / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testShortCOPYRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .COPY)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data = ("COPY / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testShortLOCKRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .LOCK)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data = ("LOCK / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testShortMKCOLRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .MKCOL)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data = ("MKCOL / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testShortMOVERequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .MOVE)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data = ("MOVE / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testShortPROPFINDRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .PROPFIND)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data = ("PROPFIND / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testShortPROPPATCHRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .PROPPATCH)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data = ("PROPPATCH / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testShortSEARCHRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .SEARCH)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data = ("SEARCH / HTTP/1.1\r\n" +
                "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testShortUNLOCKRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .UNLOCK)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data = ("UNLOCK / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testShortBINDRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .BIND)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data = ("BIND / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testShortREBINDRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .REBIND)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data = ("REBIND / HTTP/1.1\r\n" +
                "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testShortUNBINDRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .UNBIND)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data = ("UNBIND / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testShortACLRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .ACL)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data = ("ACL / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testShortREPORTRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .REPORT)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data = ("REPORT / HTTP/1.1\r\n" +
                "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testShortMKACTIVITYRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .MKACTIVITY)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data = ("MKACTIVITY / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testShortCHECKOUTRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .CHECKOUT)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data = ("CHECKOUT / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testShortMERGERequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .MERGE)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data = ("MERGE / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testShortMSEARCHRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .MSEARCH)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data = ("M-SEARCH / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testShortNOTIFYRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .NOTIFY)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data = ("NOTIFY / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testShortSUBSCRIBERequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .SUBSCRIBE)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data = ("SUBSCRIBE / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testShortUNSUBSCRIBERequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .UNSUBSCRIBE)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data = ("UNSUBSCRIBE / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testShortPATCHRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .PATCH)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data = ("PATCH / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testShortPURGERequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .PURGE)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data = ("PURGE / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }
    
    func testShortMKCALENDARRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .MKCALENDAR)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data = ("MKCALENDAR / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }

    func testDiscontinuousShortRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .GET)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }

        do {
            let data1 = "GET / HT"
            let data2 = "TP/1."
            let data3 = "1\r\n"
            let data4 = "\r\n"

            try parser.parse(data1)
            try parser.parse(data2)
            try parser.parse(data3)
            try parser.parse(data4)
        } catch {
            XCTAssert(false)
        }
    }

    func testMediumRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .GET)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers["Host"] == "zewo.co")
            XCTAssert(request.body == [])
        }

        do {
            let data = ("GET / HTTP/1.1\r\n" +
                        "Host: zewo.co\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }

    func testDiscontinuousMediumRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .GET)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers["Host"] == "zewo.co")
            XCTAssert(request.headers["Content-Type"] == "application/json")
            XCTAssert(request.body == [])
        }

        do {
            let data1 = "GET / HTT"
            let data2 = "P/1.1\r\n"
            let data3 = "Hos"
            let data4 = "t: zewo.c"
            let data5 = "o\r\n"
            let data6 = "Conten"
            let data7 = "t-Type: appl"
            let data8 = "ication/json\r\n"
            let data9 = "\r"
            let data10 = "\n"

            try parser.parse(data1)
            try parser.parse(data2)
            try parser.parse(data3)
            try parser.parse(data4)
            try parser.parse(data5)
            try parser.parse(data6)
            try parser.parse(data7)
            try parser.parse(data8)
            try parser.parse(data9)
            try parser.parse(data10)
        } catch {
            XCTAssert(false)
        }
    }

    func testCompleteRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .POST)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers["Content-Length"] == "4")
            XCTAssert(request.body == "Zewo".bytes)
        }

        do {
            let data = ("POST / HTTP/1.1\r\n" +
                        "Content-Length: 4\r\n" +
                        "\r\n" +
                        "Zewo")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }

    func testDiscontinuousCompleteRequest() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .POST)
            XCTAssert(request.uri.path == "/profile")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers["Content-Length"] == "4")
            XCTAssert(request.body == "Zewo".bytes)
        }

        do {
            let data1 = "PO"
            let data2 = "ST /pro"
            let data3 = "file HTT"
            let data4 = "P/1.1\r\n"
            let data5 = "Cont"
            let data6 = "ent-Length: 4"
            let data7 = "\r\n"
            let data8 = "\r"
            let data9 = "\n"
            let data10 = "Ze"
            let data11 = "wo"

            try parser.parse(data1)
            try parser.parse(data2)
            try parser.parse(data3)
            try parser.parse(data4)
            try parser.parse(data5)
            try parser.parse(data6)
            try parser.parse(data7)
            try parser.parse(data8)
            try parser.parse(data9)
            try parser.parse(data10)
            try parser.parse(data11)
        } catch {
            XCTAssert(false)
        }
    }

    func testMultipleShortRequestsInTheSameStream() {
        var requestCount = 0

        let parser = HTTPRequestParser { request in
            ++requestCount
            if requestCount == 1 {
                XCTAssert(request.method == .GET)
                XCTAssert(request.uri.path == "/")
            } else {
                XCTAssert(request.method == .HEAD)
                XCTAssert(request.uri.path == "/profile")
            }
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers == [:])
            XCTAssert(request.body == [])
        }
        
        do {
            let data1 = "GET / HT"
            let data2 = "TP/1."
            let data3 = "1\r\n"
            let data4 = "\r\n"

            let data5 = "HEAD /profile HT"
            let data6 = "TP/1."
            let data7 = "1\r\n"
            let data8 = "\r\n"

            try parser.parse(data1)
            try parser.parse(data2)
            try parser.parse(data3)
            try parser.parse(data4)
            try parser.parse(data5)
            try parser.parse(data6)
            try parser.parse(data7)
            try parser.parse(data8)
        } catch {
            XCTAssert(false)
        }
    }

    func testManyRequests() {
        let data = ("POST / HTTP/1.1\r\n" +
                    "Content-Length: 4\r\n" +
                    "\r\n" +
                    "Zewo").bytes

        self.measureBlock {
            for _ in 0 ..< 10000 {
                let parser = HTTPRequestParser { _ in }
                do {
                    try parser.parse(data)
                } catch {
                    XCTAssert(false)
                }
            }
        }
    }

    func testUpgradeRequests() {
        let parser = HTTPRequestParser { _ in
            XCTAssert(true)
        }

        do {
            let data = ("GET / HTTP/1.1\r\n" +
                        "Upgrade: WebSocket\r\n" +
                        "Connection: Upgrade\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(true)
        }
    }

    func testChunkedEncoding() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .GET)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers["Transfer-Encoding"] == "chunked")
            XCTAssert(request.body == "Zewo".bytes)
        }

        do {
            let data = ("GET / HTTP/1.1\r\n" +
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
        let parser = HTTPRequestParser { _ in
            XCTAssert(false)
        }

        do {
            let data = ("POST / HTTP/1.1\r\n" +
                        "Content-Length: 5\r\n" +
                        "\r\n" +
                        "Zewo")
            try parser.parse(data)
        } catch {
            XCTAssert(true)
        }
    }

    func testIncorrectChunkSize() {
        let parser = HTTPRequestParser { _ in
            XCTAssert(false)
        }

        do {
            let data = ("GET / HTTP/1.1\r\n" +
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
        let parser = HTTPRequestParser { _ in
            XCTAssert(false)
        }

        do {
            let data = ("GET / HTTP/1.1\r\n" +
                        "Transfer-Encoding: chunked\r\n" +
                        "\r\n" +
                        "x\r\n" +
                        "Zewo\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(true)
        }
    }

    func testConnectionKeepAlive() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .GET)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers["Connection"] == "keep-alive")
        }

        do {
            let data = ("GET / HTTP/1.1\r\n" +
                        "Connection: keep-alive\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }

    func testConnectionClose() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .GET)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 1)
            XCTAssert(request.headers["Connection"] == "close")
        }

        do {
            let data = ("GET / HTTP/1.1\r\n" +
                        "Connection: close\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }

    func testRequestHTTP1_0() {
        let parser = HTTPRequestParser { request in
            XCTAssert(request.method == .GET)
            XCTAssert(request.uri.path == "/")
            XCTAssert(request.majorVersion == 1)
            XCTAssert(request.minorVersion == 0)
        }

        do {
            let data = ("GET / HTTP/1.0\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(false)
        }
    }

    func testURI() {
        let URIString = "http://username:password@www.google.com:777/foo/bar?foo=bar&for=baz#yeah"
        let uri = URI(string: URIString)
        XCTAssert(uri.scheme == "http")
        XCTAssert(uri.userInfo?.username == "username")
        XCTAssert(uri.userInfo?.password == "password")
        XCTAssert(uri.host == "www.google.com")
        XCTAssert(uri.port == 777)
        XCTAssert(uri.path == "/foo/bar")
        XCTAssert(uri.query["foo"] == "bar")
        XCTAssert(uri.query["for"] == "baz")
        XCTAssert(uri.fragment == "yeah")
    }

    func testURIIPv6() {
        let URIString = "http://username:password@[2001:db8:1f70::999:de8:7648:6e8]:100/foo/bar?foo=bar&for=baz#yeah"
        let uri = URI(string: URIString)
        XCTAssert(uri.scheme == "http")
        XCTAssert(uri.userInfo?.username == "username")
        XCTAssert(uri.userInfo?.password == "password")
        XCTAssert(uri.host == "2001:db8:1f70::999:de8:7648:6e8")
        XCTAssert(uri.port == 100)
        XCTAssert(uri.path == "/foo/bar")
        XCTAssert(uri.query["foo"] == "bar")
        XCTAssert(uri.query["for"] == "baz")
        XCTAssert(uri.fragment == "yeah")
    }
    
    func testURIIPv6WithZone() {
        let URIString = "http://username:password@[2001:db8:a0b:12f0::1%eth0]:100/foo/bar?foo=bar&for=baz#yeah"
        let uri = URI(string: URIString)
        XCTAssert(uri.scheme == "http")
        XCTAssert(uri.userInfo?.username == "username")
        XCTAssert(uri.userInfo?.password == "password")
        XCTAssert(uri.host == "2001:db8:a0b:12f0::1%eth0")
        XCTAssert(uri.port == 100)
        XCTAssert(uri.path == "/foo/bar")
        XCTAssert(uri.query["foo"] == "bar")
        XCTAssert(uri.query["for"] == "baz")
        XCTAssert(uri.fragment == "yeah")
    }
    
    func testQueryElementWitoutValue() {
        let URIString = "http://username:password@[2001:db8:a0b:12f0::1%eth0]:100/foo/bar?foo=&for#yeah"
        let uri = URI(string: URIString)
        XCTAssert(uri.scheme == "http")
        XCTAssert(uri.userInfo?.username == "username")
        XCTAssert(uri.userInfo?.password == "password")
        XCTAssert(uri.host == "2001:db8:a0b:12f0::1%eth0")
        XCTAssert(uri.port == 100)
        XCTAssert(uri.path == "/foo/bar")
        XCTAssert(uri.query["foo"] == "")
        XCTAssert(uri.query["for"] == "")
        XCTAssert(uri.fragment == "yeah")
    }
}
