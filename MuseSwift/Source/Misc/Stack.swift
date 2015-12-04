import Foundation

public class Stack<T> {
  private var buf = [T]()

  public init() {
  }

  public init(x: T) {
    
  }

  public init(xs: T...) {
    buf += xs
  }

  public init(xs: [T]) {
    buf += xs
  }

  public func push(x: T) -> Void {
    buf.insert(x, atIndex: 0)
  }

  public func pop() -> T? {
    return tap(buf.first)(f: {$0.foreach({_ in self.buf.removeFirst()})})
  }

  public func clear() -> Void {
    buf = []
  }

  public var isEmpty: Bool {
    return buf.isEmpty
  }

  public var nonEmpty: Bool {
    return buf.nonEmpty
  }
}