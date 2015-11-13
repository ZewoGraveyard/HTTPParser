Luminescence
============

[![Swift 2.0](https://img.shields.io/badge/Swift-2.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms OS X | iOS](https://img.shields.io/badge/Platforms-OS%20X%20%7C%20iOS-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![Cocoapods Compatible](https://img.shields.io/badge/Cocoapods-Compatible-4BC51D.svg?style=flat)](https://cocoapods.org/pods/Luminescence)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-Compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Travis](https://img.shields.io/badge/Build-Passing-4BC51D.svg?style=flat)](https://travis-ci.org/Zewo/Luminescence)
[![codecov.io](http://codecov.io/github/Zewo/Luminescence/coverage.svg?branch=master)](http://codecov.io/github/Zewo/Luminescence?branch=master)

**Luminescence** is an HTTP parser for **Swift 2**.

## Features

- [x] No `Foundation` dependency (**Linux ready**)
- [x] Asynchronous parsing
- [x] Handles persistent streams (keep-alive)
- [x] Decodes chunked encoding
- [x] Defends against buffer overflow attacks

**Luminescence** wraps the C library [http_parser](https://github.com/nodejs/http-parser) used in [node.js](https://github.com/nodejs/node).

## Products

**Luminescence** is the base for the HTTP servers
- [Aeon](https://github.com/Zewo/Aeon) - GCD based HTTP server
- [Epoch](https://github.com/Zewo/Epoch) - Luminescence based HTTP server

##Usage

`HTTPRequestParser`
-------------------

```swift
import Luminescence

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

`HTTPRequest`
----------------

```swift
struct HTTPRequest {
    let method: HTTPMethod
    let uri: URI
    let majorVersion: Int
    let minorVersion: Int
    let headers: [String: String]
    let body: [Int8]
}
```

`HTTPMethod`
---------------

```swift
enum HTTPMethod {
    case DELETE
    case GET
    case HEAD
    case POST
    case PUT
    case CONNECT
    case OPTIONS
    case TRACE
    ...
}
```

`URI`
--------

```swift
struct URI {
    let scheme: String?
    let userInfo: URIUserInfo?
    let host: String?
    let port: Int?
    let path: String?
    let query: [String: String]
    let fragment: String?
}
```

`URIUserInfo`
--------

```swift
struct URI {
    let username: String
    let password: String
}
```

`HTTPResponseParser`
--------------------

```swift
import Luminescence

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

`HTTPResponse`
-----------------

```swift
struct HTTPResponse {
    let statusCode: Int
    let reasonPhrase: String
    let majorVersion: Int
    let minorVersion: Int
    let headers: [String: String]
    let body: [Int8]
}
```

Chunked Data and Persistent Streams
-----------------------------------

```swift
import Luminescence

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
import Luminescence

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

> CocoaPods 0.39.0+ is required to build Luminescence.

To integrate Luminescence into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

pod 'Luminescence'
```

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

To integrate **Luminescence** into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "Zewo/Luminescence"
```

### Manually

If you prefer not to use a dependency manager, you can integrate **Luminescence** into your project manually.

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

```bash
$ git init
```

- Add **Luminescence** as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

```bash
$ git submodule add https://github.com/Zewo/Luminescence.git
```

- Open the new `Luminescence` folder, and drag the `Luminescence.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `Luminescence.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `Luminescence.xcodeproj` folders each with two different versions of the `Luminescence.framework` nested inside a `Products` folder.

    > It does not matter which `Products` folder you choose from, but it does matter whether you choose the top or bottom `Luminescence.framework`.

- Select the top `Luminescence.framework` for OS X and the bottom one for iOS.

    > You can verify which one you selected by inspecting the build log for your project. The build target for `Luminescence` will be listed as either `Luminescence iOS` or `Luminescence OSX`.

- And that's it!

> The `Luminescence.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

License
-------

**Luminescence** is released under the MIT license. See LICENSE for details.
