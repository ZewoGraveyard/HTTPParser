HTTPParser
=======

[![Swift 2.0](https://img.shields.io/badge/Swift-2.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms OS X | iOS](https://img.shields.io/badge/Platforms-OS%20X%20%7C%20iOS-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-Compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Travis](https://img.shields.io/badge/Build-Passing-4BC51D.svg?style=flat)](https://travis-ci.org/Zewo/HTTPParser)
[![codecov.io](http://codecov.io/github/Zewo/HTTPParser/coverage.svg?branch=master)](http://codecov.io/github/Zewo/HTTPParser?branch=master)

**HTTPParser** is an HTTP parser for **Swift 2**.

## Features

- [x] No `Foundation` depency (**Linux ready**)
- [x] Asynchronous parsing
- [x] Handles persistent streams (keep-alive)
- [x] Decodes chunked encoding
- [x] Defends against buffer overflow attacks

**HTTPParser** wraps the C library [http_parser](https://github.com/nodejs/http-parser) used in [node.js](https://github.com/nodejs/node).

##Usage

```swift
import HTTPParser

struct FakeHTTPStream : HTTPStream {
    private func readData(handler: (UnsafePointer<Int8>, Int) -> Void) throws {
        // Here you'll probably get the real data from a socket, right?
        let data =
        "GET / HTTP/1.1\r\n" +
        "\r\n"

        data.withCString { dataPointer in
            handler(dataPointer, data.utf8.count)
        }
    }
}

HTTPParser.parseRequest(stream: FakeHTTPStream()) { result in
    result.success { request in
        // here's your parsed request
    }
    result.failure { error in
        // something bad happened
    }
}

```

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate **HTTPParser** into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "Zewo/HTTPParser"
```

### Manually

If you prefer not to use a dependency manager, you can integrate **HTTPParser** into your project manually.

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

```bash
$ git init
```

- Add **HTTPParser** as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

```bash
$ git submodule add https://github.com/Zewo/HTTPParser.git
```

- Open the new `HTTPParser` folder, and drag the `HTTPParser.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `HTTPParser.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `HTTPParser.xcodeproj` folders each with two different versions of the `HTTPParser.framework` nested inside a `Products` folder.

    > It does not matter which `Products` folder you choose from, but it does matter whether you choose the top or bottom `HTTPParser.framework`.

- Select the top `HTTPParser.framework` for OS X and the bottom one for iOS.

    > You can verify which one you selected by inspecting the build log for your project. The build target for `HTTPParser` will be listed as either `HTTPParser iOS` or `HTTPParser OSX`.

- And that's it!

> The `HTTPParser.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

License
-------

**HTTPParser** is released under the MIT license. See LICENSE for details.