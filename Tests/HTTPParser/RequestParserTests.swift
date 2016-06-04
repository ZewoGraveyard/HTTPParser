import XCTest
@testable import HTTPParser

class RequestParserTests: XCTestCase {
    func testInvalidMethod() {
        let parser = RequestParser()
        do {
            let data = ("INVALID / HTTP/1.1\r\n" +
                        "\r\n")
            try parser.parse(data)
        } catch {
            XCTAssert(true)
        }
    }

    func testShortDELETERequest() {
        let parser = RequestParser()
        do {
            let data = ("DELETE / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .delete)
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortGETRequest() {
        let parser = RequestParser()
        do {
            let data = ("GET / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .get)
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortHEADRequest() {
        let parser = RequestParser()
        do {
            let data = ("HEAD / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .head)
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortPOSTRequest() {
        let parser = RequestParser()
        do {
            let data = ("POST / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .post)
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortPUTRequest() {
        let parser = RequestParser()
        do {
            let data = ("PUT / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .put)
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortCONNECTRequest() {
        let parser = RequestParser()
        do {
            let data = ("CONNECT / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .connect)
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortOPTIONSRequest() {
        let parser = RequestParser()
        do {
            let data = ("OPTIONS / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .options)
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortTRACERequest() {
        let parser = RequestParser()
        do {
            let data = ("TRACE / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .trace)
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortCOPYRequest() {
        let parser = RequestParser()
        do {
            let data = ("COPY / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .other(method: "COPY"))
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortLOCKRequest() {
        let parser = RequestParser()
        do {
            let data = ("LOCK / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .other(method: "LOCK"))
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortMKCOLRequest() {
        let parser = RequestParser()
        do {
            let data = ("MKCOL / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .other(method: "MKCOL"))
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortMOVERequest() {
        let parser = RequestParser()
        do {
            let data = ("MOVE / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .other(method: "MOVE"))
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortPROPFINDRequest() {
        let parser = RequestParser()
        do {
            let data = ("PROPFIND / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .other(method: "PROPFIND"))
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortPROPPATCHRequest() {
        let parser = RequestParser()
        do {
            let data = ("PROPPATCH / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .other(method: "PROPPATCH"))
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortSEARCHRequest() {
        let parser = RequestParser()
        do {
            let data = ("SEARCH / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .other(method: "SEARCH"))
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortUNLOCKRequest() {
        let parser = RequestParser()
        do {
            let data = ("UNLOCK / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .other(method: "UNLOCK"))
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortBINDRequest() {
        let parser = RequestParser()
        do {
            let data = ("BIND / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .other(method: "BIND"))
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortREBINDRequest() {
        let parser = RequestParser()
        do {
            let data = ("REBIND / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .other(method: "REBIND"))
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortUNBINDRequest() {
        let parser = RequestParser()
        do {
            let data = ("UNBIND / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .other(method: "UNBIND"))
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortACLRequest() {
        let parser = RequestParser()
        do {
            let data = ("ACL / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .other(method: "ACL"))
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortREPORTRequest() {
        let parser = RequestParser()
        do {
            let data = ("REPORT / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .other(method: "REPORT"))
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortMKACTIVITYRequest() {
        let parser = RequestParser()
        do {
            let data = ("MKACTIVITY / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .other(method: "MKACTIVITY"))
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortCHECKOUTRequest() {
        let parser = RequestParser()
        do {
            let data = ("CHECKOUT / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .other(method: "CHECKOUT"))
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortMERGERequest() {
        let parser = RequestParser()
        do {
            let data = ("MERGE / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .other(method: "MERGE"))
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortNOTIFYRequest() {
        let parser = RequestParser()
        do {
            let data = ("NOTIFY / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .other(method: "NOTIFY"))
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortSUBSCRIBERequest() {
        let parser = RequestParser()
        do {
            let data = ("SUBSCRIBE / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .other(method: "SUBSCRIBE"))
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortUNSUBSCRIBERequest() {
        let parser = RequestParser()
        do {
            let data = ("UNSUBSCRIBE / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .other(method: "UNSUBSCRIBE"))
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortPATCHRequest() {
        let parser = RequestParser()
        do {
            let data = ("PATCH / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .patch)
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortPURGERequest() {
        let parser = RequestParser()
        do {
            let data = ("PURGE / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .other(method: "PURGE"))
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testShortMKCALENDARRequest() {
        let parser = RequestParser()
        do {
            let data = ("MKCALENDAR / HTTP/1.1\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .other(method: "MKCALENDAR"))
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testDiscontinuousShortRequest() {
        let parser = RequestParser()
        do {
            let data1 = "GET / HT"
            let data2 = "TP/1."
            let data3 = "1\r\n"
            let data4 = "\r\n"

            var request = try parser.parse(data1)
            XCTAssert(request == nil)
            request = try parser.parse(data2)
            XCTAssert(request == nil)
            request = try parser.parse(data3)
            XCTAssert(request == nil)
            if let request = try parser.parse(data4) {
                XCTAssert(request.method == .get)
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testMediumRequest() {
        let parser = RequestParser()
        do {
            let data = ("GET / HTTP/1.1\r\n" +
                        "Host: zewo.co\r\n" +
                        "\r\n")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .get)
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers["Host"] == "zewo.co")
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testDiscontinuousMediumRequest() {
        let parser = RequestParser()
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

            var request = try parser.parse(data1)
            XCTAssert(request == nil)
            request = try parser.parse(data2)
            XCTAssert(request == nil)
            request = try parser.parse(data3)
            XCTAssert(request == nil)
            request = try parser.parse(data4)
            XCTAssert(request == nil)
            request = try parser.parse(data5)
            XCTAssert(request == nil)
            request = try parser.parse(data6)
            XCTAssert(request == nil)
            request = try parser.parse(data7)
            XCTAssert(request == nil)
            request = try parser.parse(data8)
            XCTAssert(request == nil)
            request = try parser.parse(data9)
            XCTAssert(request == nil)
            if let request = try parser.parse(data10) {
                XCTAssert(request.method == .get)
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers["Host"] == "zewo.co")
                XCTAssert(request.headers["Content-Type"] == "application/json")
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }


    func testDiscontinuousMediumRequestMultipleCookie() {
        let parser = RequestParser()

        do {
            let data1 = "GET / HTT"
            let data2 = "P/1.1\r\n"
            let data3 = "Hos"
            let data4 = "t: zewo.c"
            let data5 = "o\r\n"
            let data6 = "C"
            let data7 = "ookie: serv"
            let data8 = "er=zewo\r\n"
            let data9 = "C"
            let data10 = "ookie: lan"
            let data11 = "g=swift\r\n"
            let data12 = "\r"
            let data13 = "\n"

            var request = try parser.parse(data1)
            XCTAssert(request == nil)
            request = try parser.parse(data2)
            XCTAssert(request == nil)
            request = try parser.parse(data3)
            XCTAssert(request == nil)
            request = try parser.parse(data4)
            XCTAssert(request == nil)
            request = try parser.parse(data5)
            XCTAssert(request == nil)
            request = try parser.parse(data6)
            XCTAssert(request == nil)
            request = try parser.parse(data7)
            XCTAssert(request == nil)
            request = try parser.parse(data8)
            XCTAssert(request == nil)
            request = try parser.parse(data9)
            XCTAssert(request == nil)
            request = try parser.parse(data10)
            XCTAssert(request == nil)
            request = try parser.parse(data11)
            XCTAssert(request == nil)
            request = try parser.parse(data12)
            XCTAssert(request == nil)
            if let request = try parser.parse(data13) {
                XCTAssert(request.method == .get)
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers["Host"] == "zewo.co")
                XCTAssert(request.headers["Cookie"] == "server=zewo, lang=swift")
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testCompleteRequest() {
        let parser = RequestParser()
        do {
            let data = ("POST / HTTP/1.1\r\n" +
                    "Content-Length: 4\r\n" +
                    "\r\n" +
                    "Zewo")
            if let request = try parser.parse(data) {
                XCTAssert(request.method == .post)
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers["Content-Length"] == "4")
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testDiscontinuousCompleteRequest() {
        let parser = RequestParser()
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

            var request = try parser.parse(data1)
            XCTAssert(request == nil)
            request = try parser.parse(data2)
            XCTAssert(request == nil)
            request = try parser.parse(data3)
            XCTAssert(request == nil)
            request = try parser.parse(data4)
            XCTAssert(request == nil)
            request = try parser.parse(data5)
            XCTAssert(request == nil)
            request = try parser.parse(data6)
            XCTAssert(request == nil)
            request = try parser.parse(data7)
            XCTAssert(request == nil)
            request = try parser.parse(data8)
            XCTAssert(request == nil)
            request = try parser.parse(data9)
            XCTAssert(request == nil)
            request = try parser.parse(data10)
            XCTAssert(request == nil)
            if let request = try parser.parse(data11) {
                XCTAssert(request.method == .post)
                XCTAssert(request.uri.path == "/profile")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers["Content-Length"] == "4")
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testMultipleShortRequestsInTheSameStream() {
        let parser = RequestParser()
        do {
            let data1 = "GET / HT"
            let data2 = "TP/1."
            let data3 = "1\r\n"
            let data4 = "\r\n"

            var request = try parser.parse(data1)
            XCTAssert(request == nil)
            request = try parser.parse(data2)
            XCTAssert(request == nil)
            request = try parser.parse(data3)
            XCTAssert(request == nil)
            if let request = try parser.parse(data4) {
                XCTAssert(request.method == .get)
                XCTAssert(request.uri.path == "/")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }

            let data5 = "HEAD /profile HT"
            let data6 = "TP/1."
            let data7 = "1\r\n"
            let data8 = "\r\n"

            request = try parser.parse(data5)
            XCTAssert(request == nil)
            request = try parser.parse(data6)
            XCTAssert(request == nil)
            request = try parser.parse(data7)
            XCTAssert(request == nil)
            if let request = try parser.parse(data8) {
                XCTAssert(request.method == .head)
                XCTAssert(request.uri.path == "/profile")
                XCTAssert(request.version.major == 1)
                XCTAssert(request.version.minor == 1)
                XCTAssert(request.headers.count == 0)
            } else {
                XCTAssert(false)
            }
        } catch {
            XCTAssert(false)
        }
    }

    func testManyRequests() {
        #if os(OSX)
            let data = ("POST / HTTP/1.1\r\n" +
                        "Content-Length: 4\r\n" +
                        "\r\n" +
                        "Zewo")

            self.measure {
                for _ in 0 ..< 10000 {
                    let parser = RequestParser()
                    do {
                        if let request = try parser.parse(data) {
                            XCTAssert(request.method == .post)
                        } else {
                            XCTAssert(false)
                        }
                    } catch {
                        XCTAssert(false)
                    }
                }
            }
        #endif
    }
//
//    func testUpgradeRequests() {
//        let parser = HTTPRequestParser { _ in
//            XCTAssert(true)
//        }
//
//        do {
//            let data = ("GET / HTTP/1.1\r\n" +
//                "Upgrade: WebSocket\r\n" +
//                "Connection: Upgrade\r\n" +
//                "\r\n")
//            try parser.parse(data)
//        } catch {
//            XCTAssert(true)
//        }
//    }
//
//    func testChunkedEncoding() {
//        let parser = HTTPRequestParser { request in
//            XCTAssert(request.method == .GET)
//            XCTAssert(request.uri.path == "/")
//            XCTAssert(request.majorVersion == 1)
//            XCTAssert(request.minorVersion == 1)
//            XCTAssert(request.headers["Transfer-Encoding"] == "chunked")
//            XCTAssert(request.body == "Zewo".bytes)
//        }
//
//        do {
//            let data = ("GET / HTTP/1.1\r\n" +
//                "Transfer-Encoding: chunked\r\n" +
//                "\r\n" +
//                "4\r\n" +
//                "Zewo\r\n")
//            try parser.parse(data)
//        } catch {
//            XCTAssert(false)
//        }
//    }
//
//    func testIncorrectContentLength() {
//        let parser = HTTPRequestParser { _ in
//            XCTAssert(false)
//        }
//
//        do {
//            let data = ("POST / HTTP/1.1\r\n" +
//                "Content-Length: 5\r\n" +
//                "\r\n" +
//                "Zewo")
//            try parser.parse(data)
//        } catch {
//            XCTAssert(true)
//        }
//    }
//
//    func testIncorrectChunkSize() {
//        let parser = HTTPRequestParser { _ in
//            XCTAssert(false)
//        }
//
//        do {
//            let data = ("GET / HTTP/1.1\r\n" +
//                "Transfer-Encoding: chunked\r\n" +
//                "\r\n" +
//                "5\r\n" +
//                "Zewo\r\n")
//            try parser.parse(data)
//        } catch {
//            XCTAssert(true)
//        }
//    }
//
//    func testInvalidChunkSize() {
//        let parser = HTTPRequestParser { _ in
//            XCTAssert(false)
//        }
//
//        do {
//            let data = ("GET / HTTP/1.1\r\n" +
//                "Transfer-Encoding: chunked\r\n" +
//                "\r\n" +
//                "x\r\n" +
//                "Zewo\r\n")
//            try parser.parse(data)
//        } catch {
//            XCTAssert(true)
//        }
//    }
//
//    func testConnectionKeepAlive() {
//        let parser = HTTPRequestParser { request in
//            XCTAssert(request.method == .GET)
//            XCTAssert(request.uri.path == "/")
//            XCTAssert(request.majorVersion == 1)
//            XCTAssert(request.minorVersion == 1)
//            XCTAssert(request.headers["Connection"] == "keep-alive")
//        }
//
//        do {
//            let data = ("GET / HTTP/1.1\r\n" +
//                "Connection: keep-alive\r\n" +
//                "\r\n")
//            try parser.parse(data)
//        } catch {
//            XCTAssert(false)
//        }
//    }
//
//    func testConnectionClose() {
//        let parser = HTTPRequestParser { request in
//            XCTAssert(request.method == .GET)
//            XCTAssert(request.uri.path == "/")
//            XCTAssert(request.majorVersion == 1)
//            XCTAssert(request.minorVersion == 1)
//            XCTAssert(request.headers["Connection"] == "close")
//        }
//
//        do {
//            let data = ("GET / HTTP/1.1\r\n" +
//                "Connection: close\r\n" +
//                "\r\n")
//            try parser.parse(data)
//        } catch {
//            XCTAssert(false)
//        }
//    }
//
//    func testRequestHTTP1_0() {
//        let parser = HTTPRequestParser { request in
//            XCTAssert(request.method == .GET)
//            XCTAssert(request.uri.path == "/")
//            XCTAssert(request.majorVersion == 1)
//            XCTAssert(request.minorVersion == 0)
//        }
//
//        do {
//            let data = ("GET / HTTP/1.0\r\n" +
//                "\r\n")
//            try parser.parse(data)
//        } catch {
//            XCTAssert(false)
//        }
//    }
//
//    func testURI() {
//        let URIString = "http://username:password@www.google.com:777/foo/bar?foo=bar&for=baz#yeah"
//        let uri = URI(string: URIString)
//        XCTAssert(uri.scheme == "http")
//        XCTAssert(uri.userInfo?.username == "username")
//        XCTAssert(uri.userInfo?.password == "password")
//        XCTAssert(uri.host == "www.google.com")
//        XCTAssert(uri.port == 777)
//        XCTAssert(uri.path == "/foo/bar")
//        XCTAssert(uri.query["foo"] == "bar")
//        XCTAssert(uri.query["for"] == "baz")
//        XCTAssert(uri.fragment == "yeah")
//    }
//
//    func testURIIPv6() {
//        let URIString = "http://username:password@[2001:db8:1f70::999:de8:7648:6e8]:100/foo/bar?foo=bar&for=baz#yeah"
//        let uri = URI(string: URIString)
//        XCTAssert(uri.scheme == "http")
//        XCTAssert(uri.userInfo?.username == "username")
//        XCTAssert(uri.userInfo?.password == "password")
//        XCTAssert(uri.host == "2001:db8:1f70::999:de8:7648:6e8")
//        XCTAssert(uri.port == 100)
//        XCTAssert(uri.path == "/foo/bar")
//        XCTAssert(uri.query["foo"] == "bar")
//        XCTAssert(uri.query["for"] == "baz")
//        XCTAssert(uri.fragment == "yeah")
//    }
//
//    func testURIIPv6WithZone() {
//        let URIString = "http://username:password@[2001:db8:a0b:12f0::1%eth0]:100/foo/bar?foo=bar&for=baz#yeah"
//        let uri = URI(string: URIString)
//        XCTAssert(uri.scheme == "http")
//        XCTAssert(uri.userInfo?.username == "username")
//        XCTAssert(uri.userInfo?.password == "password")
//        XCTAssert(uri.host == "2001:db8:a0b:12f0::1%eth0")
//        XCTAssert(uri.port == 100)
//        XCTAssert(uri.path == "/foo/bar")
//        XCTAssert(uri.query["foo"] == "bar")
//        XCTAssert(uri.query["for"] == "baz")
//        XCTAssert(uri.fragment == "yeah")
//    }
//
//    func testQueryElementWitoutValue() {
//        let URIString = "http://username:password@[2001:db8:a0b:12f0::1%eth0]:100/foo/bar?foo=&for#yeah"
//        let uri = URI(string: URIString)
//        XCTAssert(uri.scheme == "http")
//        XCTAssert(uri.userInfo?.username == "username")
//        XCTAssert(uri.userInfo?.password == "password")
//        XCTAssert(uri.host == "2001:db8:a0b:12f0::1%eth0")
//        XCTAssert(uri.port == 100)
//        XCTAssert(uri.path == "/foo/bar")
//        XCTAssert(uri.query["foo"] == "")
//        XCTAssert(uri.query["for"] == "")
//        XCTAssert(uri.fragment == "yeah")
//    }
}



extension RequestParserTests {
    static var allTests: [(String, (RequestParserTests) -> () throws -> Void)] {
        return [
            ("testInvalidMethod", testInvalidMethod),
            ("testShortDELETERequest", testShortDELETERequest),
            ("testShortGETRequest", testShortGETRequest),
            ("testShortHEADRequest", testShortHEADRequest),
            ("testShortPOSTRequest", testShortPOSTRequest),
            ("testShortPUTRequest", testShortPUTRequest),
            ("testShortCONNECTRequest", testShortCONNECTRequest),
            ("testShortOPTIONSRequest", testShortOPTIONSRequest),
            ("testShortTRACERequest", testShortTRACERequest),
            ("testShortCOPYRequest", testShortCOPYRequest),
            ("testShortLOCKRequest", testShortLOCKRequest),
            ("testShortMKCOLRequest", testShortMKCOLRequest),
            ("testShortMOVERequest", testShortMOVERequest),
            ("testShortPROPFINDRequest", testShortPROPFINDRequest),
            ("testShortPROPPATCHRequest", testShortPROPPATCHRequest),
            ("testShortSEARCHRequest", testShortSEARCHRequest),
            ("testShortUNLOCKRequest", testShortUNLOCKRequest),
            ("testShortBINDRequest", testShortBINDRequest),
            ("testShortREBINDRequest", testShortREBINDRequest),
            ("testShortUNBINDRequest", testShortUNBINDRequest),
            ("testShortACLRequest", testShortACLRequest),
            ("testShortREPORTRequest", testShortREPORTRequest),
            ("testShortMKACTIVITYRequest", testShortMKACTIVITYRequest),
            ("testShortCHECKOUTRequest", testShortCHECKOUTRequest),
            ("testShortMERGERequest", testShortMERGERequest),
            ("testShortNOTIFYRequest", testShortNOTIFYRequest),
            ("testShortSUBSCRIBERequest", testShortSUBSCRIBERequest),
            ("testShortUNSUBSCRIBERequest", testShortUNSUBSCRIBERequest),
            ("testShortPATCHRequest", testShortPATCHRequest),
            ("testShortPURGERequest", testShortPURGERequest),
            ("testShortMKCALENDARRequest", testShortMKCALENDARRequest),
            ("testDiscontinuousShortRequest", testDiscontinuousShortRequest),
            ("testMediumRequest", testMediumRequest),
            ("testDiscontinuousMediumRequest", testDiscontinuousMediumRequest),
            ("testDiscontinuousMediumRequestMultipleCookie", testDiscontinuousMediumRequestMultipleCookie),
            ("testCompleteRequest", testCompleteRequest),
            ("testDiscontinuousCompleteRequest", testDiscontinuousCompleteRequest),
            ("testMultipleShortRequestsInTheSameStream", testMultipleShortRequestsInTheSameStream),
            ("testManyRequests", testManyRequests),
        ]
    }
}
