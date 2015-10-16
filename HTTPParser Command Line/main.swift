// main.swift
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

import Darwin

var timebaseInfo = mach_timebase_info_data_t()
mach_timebase_info(&timebaseInfo)

func now() -> Double {
    let ticks = Double(mach_absolute_time())
    return Double(ticks * Double(timebaseInfo.numer) / Double(timebaseInfo.denom) / 1000000000)
}

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

public struct HTTPStreamMock : HTTPStream {
    public func readData(handler: (UnsafePointer<Int8>, Int) -> Void) throws {
        let data =
        "POST / HTTP/1.1\r\n" +
        "Content-Length: 4\r\n" +
        "\r\n" +
        "Zewo"
        data.sendToHandler(handler)
    }
}

let numberOfRequests = 100000
let startTime = now()
for _ in 0 ..< numberOfRequests {
    parseRequest(stream: HTTPStreamMock()) { result in
        result.success { _ in }
        result.failure { error in fatalError("\(error)") }
    }
}
let timeElapsed = now() - startTime

print("Time elapsed: \(timeElapsed) s")
print("Duration per request: \(timeElapsed/Double(numberOfRequests)) s")
print("Requests per second: \(1/(timeElapsed/Double(numberOfRequests))) s")
