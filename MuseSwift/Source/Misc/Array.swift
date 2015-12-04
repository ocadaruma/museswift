import Foundation

extension Array {
  public func get(index: Int) -> Generator.Element? {
    if 0 <= index && index < count {
      return self[index]
    } else {
      return nil
    }
  }
}
