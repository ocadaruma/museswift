import XCTest
@testable import MuseSwift

class CollectionTests: XCTestCase {
  func testGrouped() {
    let xs1 = [1, 2, 3, 4, 5]
    XCTAssertEqual(xs1.grouped(2), [[1, 2], [3, 4], [5]])
    XCTAssertEqual(xs1.grouped(6), [[1, 2, 3, 4, 5]])
    XCTAssertEqual(xs1.grouped(1), [[1], [2], [3], [4], [5]])

    let xs2 = [Int]()
    XCTAssertEqual(xs2.grouped(1), [])
  }

  func testGroupBy() {
    let xs1 = [1, 2, 3, 4, 5]

    XCTAssert(xs1.groupBy { $0 % 2 } == [0: [2, 4], 1: [1, 3, 5]])
    XCTAssert(xs1.groupBy(identity) == [1: [1], 2: [2], 3: [3], 4: [4], 5: [5]])

    XCTAssert([Int]().groupBy { $0 }.isEmpty)
  }

  func testGroupAdjacentBy() {
    let xs1 = [1, 2, 6, 3, 4, 5, 7]

    XCTAssert(xs1.spanBy { $0 % 2 } == [[1], [2, 6], [3], [4], [5, 7]])
    XCTAssert(xs1.spanBy(identity) == [[1], [2], [6], [3], [4], [5], [7]])
    XCTAssert([Int]().spanBy(identity) == [])
  }

  func testMinBy() {
    XCTAssertEqual(["zero", "two", "three", "four"].minBy { $0.characters.count }, "two")
    XCTAssertEqual(["zero", "two", "three", "four"].maxBy { $0.characters.count }, "three")
    XCTAssertEqual([String]().minBy(identity), nil)
  }

  func testMaxBy() {

  }
}
