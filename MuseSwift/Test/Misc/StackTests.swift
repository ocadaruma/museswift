import XCTest
import MuseSwift

class StackTests: XCTestCase {
  func testPushPop() {
    let stack = Stack<Int>()

    stack.push(1)
    stack.push(2)
    stack.push(3)

    XCTAssertEqual(stack.pop(), 3)
    XCTAssertEqual(stack.pop(), 2)
    XCTAssertEqual(stack.pop(), 1)
    XCTAssertEqual(stack.pop(), nil)
  }

  func testClear() {
    let stack = Stack(xs: 1, 2, 3)

    stack.clear()

    XCTAssertEqual(stack.pop(), nil)
  }
}
