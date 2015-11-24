import Foundation

public class StringScanner {
  private var string: String

  public init(string: String) {
    self.string = string
  }

  public var result: String { return string }

  public var eos: Bool { return string.characters.count <= 0 }

  public func scan(pattern: String) -> [MatchResult] {
    let results = string.matchesWithPattern(pattern)
    if let r = results.first {
      string.removeRange(r.range)
    }
    return results
  }
}