import PackageDescription

let package = Package(
	name: "HTTPParser",
	dependencies: [
        .Package(url: "https://github.com/Zewo/CHTTPParser.git", majorVersion: 0, minor: 6),
        .Package(url: "https://github.com/Zewo/URI.git", majorVersion: 0, minor: 9),
        .Package(url: "https://github.com/open-swift/S4.git", majorVersion: 0, minor: 10),
    ]
)
