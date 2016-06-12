// Cookie.swift
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

public struct Cookies {
    private var cookies = Set<Cookie>()

    public init() { }

    public init<Cookies: Sequence where Cookies.Iterator.Element == Cookie>(cookies: Cookies) {
        for cookie in cookies {
            self.cookies.insert(cookie)
        }
    }

    public mutating func insert(_ cookie: Cookie) {
        cookies.insert(cookie)
    }

    public mutating func remove(_ cookie: Cookie) {
        cookies.remove(cookie)
    }

    public mutating func removeAll() {
        cookies.removeAll()
    }

    public func contains(_ cookie: Cookie) -> Bool {
        return cookies.contains(cookie)
    }

    public subscript(name: String) -> String? {
        get {
            guard let index = index(ofCookieNamed: name) else {
                return nil
            }

            return cookies[index].value
        }

        set {
            guard let value = newValue else {
                if let index = index(ofCookieNamed: name) {
                    cookies.remove(at: index)
                }

                return
            }

            cookies.insert(Cookie(name: name, value: value))
        }
    }

    private func index(ofCookieNamed name: String) -> SetIndex<Cookie>? {
        return cookies.index(where: { $0.name == name })
    }
}

extension Cookies: ArrayLiteralConvertible {
    public init(arrayLiteral cookies: Cookie...) {
        self.init(cookies: cookies)
    }
}

extension Cookies: Sequence {
    public typealias Iterator = SetIterator<Cookie>

    public func makeIterator() -> Iterator {
        return cookies.makeIterator()
    }
}