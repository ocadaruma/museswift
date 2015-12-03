import Foundation

public func tap<T>(x: T, f: T -> Void) -> T {
  f(x)
  return x
}