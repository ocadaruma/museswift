import Foundation

extension Optional {
  public func foreach(f: Wrapped -> Void) -> Void {
    if let a = self {
      f(a)
    }
  }
}
