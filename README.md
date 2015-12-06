HTTPParser
==========

[![Swift 2.2](https://img.shields.io/badge/Swift-2.2-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms Linux](https://img.shields.io/badge/Platforms-Linux-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![License MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)](https://tldrlegal.com/license/mit-license)
[![Slack Status](https://zewo-slackin.herokuapp.com/badge.svg)](https://zewo-slackin.herokuapp.com)

**HTTPParser** is an HTTP [(RFC 2616)](https://tools.ietf.org/html/rfc2616) parser for **Swift 2.2**.

## Features

- [x] Asynchronous parsing
- [x] Handles persistent streams (keep-alive)
- [x] Decodes chunked encoding
- [x] Defends against buffer overflow attacks

**HTTPParser** wraps a fork of the C library [http_parser](https://github.com/nodejs/http-parser) used in [node.js](https://github.com/nodejs/node).

## Products

**HTTPParser** is the base for the HTTP servers

- [Aeon](https://github.com/Zewo/Aeon) - GCD based HTTP server
- [Epoch](https://github.com/Zewo/Epoch) - Venice based HTTP server

##Usage

`HTTPRequestParser`
-------------------

```swift
import HTTPParser

let parser = HTTPRequestParser { request in
    // Here you get your parsed requests (HTTPRequest)
}

do {
    // Here you'll probably get the real data from a socket, right?
    let data = "GET / HTTP/1.1\r\n\r\n"
    try parser.parse(data)
} catch {
    // Something bad happened :(
}
```

`HTTPResponseParser`
--------------------

```swift
import HTTPParser

let parser = HTTPResponseParser { response in
    // Here you get your parsed responses (HTTPResponse)
}

do {
    // Here you'll probably get the real data from a socket, right?
    let data = "HTTP/1.1 204 No Content\r\n\r\n"
    try parser.parse(data)
} catch {
    // Something bad happened :(
}
```

Chunked Data and Persistent Streams
-----------------------------------

```swift
import HTTPParser

let parser = HTTPRequestParser { request in
    // Here you get your parsed requests (HTTPRequest)
}

do {
    // You can call parse as many times as you like
    // passing chunks of the request or response.
    // Once the parser completes it will spit the result

    let data1 = "GE"
    let data2 = "T / HTT"
    let data3 = "P/1.1\r\n\r\n")

    try parser.parse(data1)
    try parser.parse(data2)
    try parser.parse(data3)

    // The parser supports persistent streams (keep-alive)
    // so you can keep streaming requests or responses
    // all you want.

    let data4 = "POS"
    let data5 = "T / H"
    let data6 = "TTP/1.1\r\n\r\n")

    try parser.parse(data4)
    try parser.parse(data5)
    try parser.parse(data6)
} catch {
    // Something bad happened :(
}
```

Using EOF
---------

```swift
import HTTPParser

let parser = HTTPResponseParser { response in
    // Here you get your parsed responses (HTTPResponse)
}

do {
	// Sometimes servers return a response without Content-Length
	// to close the stream you can call eof()
    let data = ("HTTP/1.1 200 OK\r\n" +
                "\r\n" +
                "Zewo")
	try parser.parse(data)
	try parser.eof()
} catch {
    // Something bad happened :(
}
```
	
## Installation

- Install [`uri_parser`](https://github.com/Zewo/uri_parser)

```bash
$ git clone https://github.com/Zewo/uri_parser.git
$ cd uri_parser
$ make
$ dpkg -i uri_parser.deb
```

- Install [`http_parser`](https://github.com/Zewo/http_parser)

```bash
$ git clone https://github.com/Zewo/http_parser.git
$ cd http_parser
$ make
$ dpkg -i http_parser.deb
```

- Add `HTTPParser` to your `Package.swift`

```swift
import PackageDescription

let package = Package(
	dependencies: [
		.Package(url: "https://github.com/Zewo/HTTPParser.git", majorVersion: 0, minor: 1)
	]
)

```

## Community

[![Slack](http://s13.postimg.org/ybwy92ktf/Slack.png)](https://zewo-slackin.herokuapp.com)

Join us on [Slack](https://zewo-slackin.herokuapp.com).

License
-------

**HTTPParser** is released under the MIT license. See LICENSE for details.
