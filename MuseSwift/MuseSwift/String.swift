import Foundation

public struct MatchResult {
  public let match: String
  public let range: Range<String.Index>
}

public extension String {
  public var range: NSRange {
    get {
      return NSMakeRange(0, self.characters.count)
    }
  }

  public func matchesWithPattern(pattern: String) -> [MatchResult] {
    let regex = try? NSRegularExpression(pattern: pattern, options: .AnchorsMatchLines)

    let match = regex?.firstMatchInString(self,
      options: .Anchored,
      range: self.range)

    if let m = match {
      let n = m.numberOfRanges
      var matches: [MatchResult] = []
      for i in 0..<n {
        let r = m.rangeAtIndex(i)
        if r.location != NSNotFound {
          let start = self.startIndex.advancedBy(r.location)
          let end = start.advancedBy(r.length)
          let range = start..<end

          let result = MatchResult(
            match: self.substringWithRange(range),
            range: range)

          matches.append(result)
        }
      }
      return matches
    } else {
      return []
    }
  }
}