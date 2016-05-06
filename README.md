# HTTPParser

[![Swift][swift-badge]][swift-url]
[![Zewo][zewo-badge]][zewo-url]
[![Platform][platform-badge]][platform-url]
[![License][mit-badge]][mit-url]
[![Slack][slack-badge]][slack-url]
[![Travis][travis-badge]][travis-url]
[![Codebeat][codebeat-badge]][codebeat-url]

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
		.Package(url: "https://github.com/Zewo/HTTPParser.git", majorVersion: 0, minor: 7),
	]
)
```

## Support

If you need any help you can join our [Slack](http://slack.zewo.io) and go to the **#help** channel. Or you can create a Github [issue](https://github.com/Zewo/Zewo/issues/new) in our main repository. When stating your issue be sure to add enough details, specify what module is causing the problem and reproduction steps.

## Community

[![Slack][slack-image]][slack-url]

The entire Zewo code base is licensed under MIT. By contributing to Zewo you are contributing to an open and engaged community of brilliant Swift programmers. Join us on [Slack](http://slack.zewo.io) to get to know us!

## License

This project is released under the MIT license. See [LICENSE](LICENSE) for details.

[swift-badge]: https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat
[swift-url]: https://swift.org
[zewo-badge]: https://img.shields.io/badge/Zewo-0.5-FF7565.svg?style=flat
[zewo-url]: http://zewo.io
[platform-badge]: https://img.shields.io/badge/Platforms-OS%20X%20--%20Linux-lightgray.svg?style=flat
[platform-url]: https://swift.org
[mit-badge]: https://img.shields.io/badge/License-MIT-blue.svg?style=flat
[mit-url]: https://tldrlegal.com/license/mit-license
[slack-image]: http://s13.postimg.org/ybwy92ktf/Slack.png
[slack-badge]: https://zewo-slackin.herokuapp.com/badge.svg
[slack-url]: http://slack.zewo.io
[travis-badge]: https://travis-ci.org/Zewo/HTTPParser.svg?branch=master
[travis-url]: https://travis-ci.org/Zewo/HTTPParser
[codebeat-badge]: https://codebeat.co/badges/028459db-efe8-4e1a-9681-168868b7a675
[codebeat-url]: https://codebeat.co/projects/github-com-zewo-httpparser
