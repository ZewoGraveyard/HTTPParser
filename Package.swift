import PackageDescription

let package = Package(
	name: "HTTPParser",
	dependencies: [
        .Package(url: "https://github.com/Zewo/CHTTPParser.git", majorVersion: 0, minor: 4),
        .Package(url: "https://github.com/Zewo/Data.git", majorVersion: 0, minor: 4),
        .Package(url: "https://github.com/Zewo/URI.git", majorVersion: 0, minor: 4),
        .Package(url: "https://github.com/swiftx/s4.git", majorVersion: 0, minor: 1),
    ]
)
