import XCTest

@testable import HTTPParserTestSuite

XCTMain([
    testCase(RequestParserTests.allTests),
    testCase(ResponseParserTests.allTests),
])