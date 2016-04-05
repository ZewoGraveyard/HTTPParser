HTTPParser
==========
[![Swift][swift-badge]][swift-url]
[![Platform][platform-badge]][platform-url]
[![License][mit-badge]][mit-url]
[![Slack][slack-badge]][slack-url]

**HTTPParser** is an HTTP [(RFC 2616)](https://tools.ietf.org/html/rfc2616) parser for **Swift 3.0**.

## Features

- [x] Asynchronous parsing
- [x] Handles persistent streams (keep-alive)
- [x] Decodes chunked encoding
- [x] Defends against buffer overflow attacks

**HTTPParser** wraps the C library [http_parser](https://github.com/nodejs/http-parser) used by [node.js](https://github.com/nodejs/node).

## Usage

The parser works asynchronously so you should keep feeding it data that until it returns a request/response.

```swift
let parser = RequestParser()

while true {
    do {
        let data = getDataFromSomewhere()
        if let request = try parser.parse(data) {
            // do something with request
        }
    } catch {
        // something bad happened :(
        break
    }
}
```

Parser works the same way for requests and responses.

```swift
let parser = ResponseParser()

while true {
    do {
        let data = getDataFromSomewhere()
        if let response = try parser.parse(data) {
            // do something with response
        }
    } catch {
        // something bad happened :(
        break
    }
}
```

## Installation

- Add `HTTPParser` to your `Package.swift`

```swift
import PackageDescription

let package = Package(
	dependencies: [
		.Package(url: "https://github.com/Zewo/HTTPParser.git", majorVersion: 0, minor: 4)
	]
)
```

## Community

[![Slack](http://s13.postimg.org/ybwy92ktf/Slack.png)](https://zewo-slackin.herokuapp.com)

Join us on [Slack](https://zewo-slackin.herokuapp.com).

License
-------

**HTTPParser** is released under the MIT license. See LICENSE for details.

[swift-badge]: https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat
[swift-url]: https://swift.org
[platform-badge]: https://img.shields.io/badge/Platform-Mac%20%26%20Linux-lightgray.svg?style=flat
[platform-url]: https://swift.org
[mit-badge]: https://img.shields.io/badge/License-MIT-blue.svg?style=flat
[mit-url]: https://tldrlegal.com/license/mit-license
[slack-image]: http://s13.postimg.org/ybwy92ktf/Slack.png
[slack-badge]: https://zewo-slackin.herokuapp.com/badge.svg
[slack-url]: http://slack.zewo.io
