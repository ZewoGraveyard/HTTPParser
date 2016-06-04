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

extension Cookie {
    init(name: String, value: String, attributes: [CaseInsensitiveString: String]) {
        let expires = attributes["Path"]
        let maxAge = attributes["Max-Age"].flatMap({Int($0)})
        let domain = attributes["Domain"]
        let path = attributes["Path"]
        let secure = attributes["Secure"] != nil
        let HTTPOnly = attributes["HttpOnly"] != nil

        self.init(
            name: name,
            value: value,
            domain: domain,
            path: path,
            expires: expires,
            maxAge: maxAge,
            secure: secure,
            HTTPOnly:  HTTPOnly
        )
    }

    init?(_ string: String) {
        let cookieStringTokens = string.split(separator: ";")

        guard let cookieTokens = cookieStringTokens.first?.split(separator: "=") where cookieTokens.count == 2 else {
            return nil
        }

        let name = cookieTokens[0]
        let value = cookieTokens[1]

        var attributes: [CaseInsensitiveString: String] = [:]

        for i in 1 ..< cookieStringTokens.count {
            let attributeTokens = cookieStringTokens[i].split(separator: "=")

            switch attributeTokens.count {
                case 1:
                    attributes[CaseInsensitiveString(attributeTokens[0].trim())] = ""
                case 2:
                    attributes[CaseInsensitiveString(attributeTokens[0].trim())] = attributeTokens[1].trim()
                default:
                    return nil
            }
        }

        self.init(name: name, value: value, attributes: attributes)
    }
}
