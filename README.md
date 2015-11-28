HTTPParser
==========

[![Swift 2.0](https://img.shields.io/badge/Swift-2.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms OS X | iOS](https://img.shields.io/badge/Platforms-OS%20X%20%7C%20iOS-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![Cocoapods Compatible](https://img.shields.io/badge/Cocoapods-Compatible-4BC51D.svg?style=flat)](https://cocoapods.org/pods/HTTPParser)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-Compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Travis](https://img.shields.io/badge/Build-Passing-4BC51D.svg?style=flat)](https://travis-ci.org/Zewo/HTTPParser)
[![codecov.io](http://codecov.io/github/Zewo/HTTPParser/coverage.svg?branch=master)](http://codecov.io/github/Zewo/HTTPParser?branch=master)

**HTTPParser** is an HTTP [(RFC 2616)](https://tools.ietf.org/html/rfc2616) parser for **Swift 2**.

## Features

- [x] No `Foundation` dependency (**Linux ready**)
- [x] Asynchronous parsing
- [x] Handles persistent streams (keep-alive)
- [x] Decodes chunked encoding
- [x] Defends against buffer overflow attacks

**HTTPParser** wraps the C library [http_parser](https://github.com/nodejs/http-parser) used in [node.js](https://github.com/nodejs/node).

## Products

**HTTPParser** is the base for the HTTP servers

- [Aeon](https://github.com/Zewo/Aeon) - GCD based HTTP server
- [Epoch](https://github.com/Zewo/Epoch) - HTTPParser based HTTP server

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

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build HTTPParser.

To integrate **HTTPParser** into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
```ruby
source 'https://github.com/Zewo/Specs.git'
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

pod 'HTTPParser', '0.1'
```
> Don't forget  `source 'https://github.com/Zewo/Specs.git'`. This is very important. It should always come before the official CocoaPods repo.

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate **HTTPParser** into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "Zewo/HTTPParser" == 0.1
```

### Command Line Application

To use **HTTPParser** in a command line application:

- Install the [Swift Command Line Application](https://github.com/Zewo/Swift-Command-Line-Application-Template) Xcode template
- Follow [Cocoa Pods](#cocoapods) or [Carthage](#carthage) instructions.

License
-------

**HTTPParser** is released under the MIT license. See LICENSE for details.
