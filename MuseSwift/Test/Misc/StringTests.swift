import XCTest
@testable import MuseSwift

class StringTests: XCTestCase {
  func testWholeMatch() {
    let matches = "abcDEFghi".matchesWithPattern("abc[DXY]")
    XCTAssertEqual(matches.count, 1)
    XCTAssertEqual(matches[0].match, "abcD")
    XCTAssertEqual(matches[0].range.startIndex, "abcD".startIndex)
    XCTAssertEqual(matches[0].range.endIndex, "abcD".endIndex)
  }

  func testCapture() {
    let matches = "abcDEFghi".matchesWithPattern("abc([DXY][EXY]Fg)(.*)")
    XCTAssertEqual(matches.count, 3)
    XCTAssertEqual(matches[0].match, "abcDEFghi")
    XCTAssertEqual(matches[1].match, "DEFg")
    XCTAssertEqual(matches[2].match, "hi")
  }

  func testEmpty() {
    let matches = "abcDEFghi".matchesWithPattern("ghi")
    XCTAssertEqual(matches.count, 0)
  }

  func testCaptureEmptyString() {
    let matches = "abcDEFghi".matchesWithPattern("abcDEFghi(.*)")
    XCTAssertEqual(matches.count, 2)
    XCTAssertEqual(matches[0].match, "abcDEFghi")
    XCTAssertEqual(matches[1].match, "")
  }
}
