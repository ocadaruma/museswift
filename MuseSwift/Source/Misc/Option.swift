import Foundation

extension Optional {
  public func foreach(f: Wrapped -> Void) -> Void {
    if let a = self {
      f(a)
    }
  }

  public func toArray() -> [Wrapped] {
    if let a = self {
      return [a]
    } else {
      return []
    }
  }
}
