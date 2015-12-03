import Foundation

typealias Denominator = UnitDenominator

extension CGPoint {
  func withX(x: CGFloat) -> CGPoint {
    return CGPoint(x: x, y: self.y)
  }

  func withY(y: CGFloat) -> CGPoint {
    return CGPoint(x: self.x, y: y)
  }
}

func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

prefix func -(point: CGPoint) -> CGPoint {
  return CGPoint(x: -point.x, y: -point.y)
}

extension CGRect {
  var x: CGFloat {
    return self.origin.x
  }

  var y: CGFloat {
    return self.origin.y
  }

  var width: CGFloat {
    return self.size.width
  }

  var height: CGFloat {
    return self.size.height
  }

  func withOrigin(origin: CGPoint) -> CGRect {
    return CGRect(origin: origin, size: self.size)
  }

  func withSize(size: CGSize) -> CGRect {
    return CGRect(origin: self.origin, size: size)
  }

  func withX(x: CGFloat) -> CGRect {
    return CGRect(x: x, y: self.y, width: self.width, height: self.height)
  }

  func withY(y: CGFloat) -> CGRect {
    return CGRect(x: self.x, y: y, width: self.width, height: self.height)
  }

  func withWidth(width: CGFloat) -> CGRect {
    return CGRect(x: self.x, y: self.y, width: width, height: self.height)
  }

  func withHeight(height: CGFloat) -> CGRect {
    return CGRect(x: self.x, y: self.y, width: self.width, height: height)
  }
}

func +(lhs: CGRect, rhs: CGPoint) -> CGRect {
  return CGRect(origin: lhs.origin + rhs, size: lhs.size)
}

func -(lhs: CGRect, rhs: CGPoint) -> CGRect {
  return CGRect(origin: lhs.origin - rhs, size: lhs.size)
}


extension Pitch {
  var step: Int {
    return octave * 7 + name.rawValue
  }
}

extension BeamMember {
  var maxPitch: Pitch {
    let pitch: Pitch!
    switch self {
    case let note as Note: pitch = note.pitch
    case let chord as Chord: pitch = chord.pitches.maxBy({$0.step})
    default: pitch = nil
    }
    return pitch
  }

  var minPitch: Pitch {
    let pitch: Pitch!
    switch self {
    case let note as Note: pitch = note.pitch
    case let chord as Chord: pitch = chord.pitches.minBy({$0.step})!
    default: pitch = nil
    }
    return pitch
  }

  var sortedPitches: [Pitch] {
    switch self {
    case let note as Note: return  [note.pitch]
    case let chord as Chord: return chord.pitches.sortBy({$0.step})
    default: return []
    }
  }
}

extension Denominator {
  var hasStem: Bool {
    switch self {
    case .Whole: return false
    default: return true
    }
  }

  var hasFlag: Bool {
    switch self {
    case .Whole, .Half, .Quarter: return false
    default: return true
    }
  }

  var constructor: () -> ScoreElement {
    switch self {
    case .Whole: return { WholeNoteElement() }
    case .Half: return { WhiteNoteElement() }
    default: return { BlackNoteElement() }
    }
  }

  var constructorWithFrame: CGRect -> ScoreElement {
    switch self {
    case .Whole: return { WholeNoteElement(frame: $0) }
    case .Half: return { WhiteNoteElement(frame: $0) }
    default: return { BlackNoteElement(frame: $0) }
    }
  }

  var flagConstructor: Bool -> ScoreElement! {
    switch self {
    case .Eighth: return { i in tap(FlagEighthElement())(f: { $0.invert = i }) }
    case .Sixteenth: return { i in tap(FlagSixteenthElement())(f: { $0.invert = i }) }
    default: return { _ in nil }
    }
  }

  var flagConstructorWithFrame: (CGRect, Bool) -> ScoreElement! {
    switch self {
    case .Eighth: return { (f, i) in tap(FlagEighthElement(frame: f))(f: { $0.invert = i }) }
    case .Sixteenth: return { (f, i) in tap(FlagSixteenthElement(frame: f))(f: { $0.invert = i }) }
    default: return { _ in nil }
    }
  }
}

extension CollectionType where Generator.Element == Pitch {
  var sparse: Bool {
    let sortedPitches = self.sortBy({$0.step})
    var sparse = true
    var previousPitch: Pitch? = nil
    for pitch in sortedPitches {
      if let p = previousPitch {
        if (pitch.step - p.step).abs < 2 {
          sparse = false
          break
        }
      }
      previousPitch = pitch
    }

    return sparse
  }
}

extension CollectionType where Generator.Element == CGRect {
  var maxX: CGFloat? {
    return self.map({$0.maxX}).maxElement()
  }

  var maxY: CGFloat? {
    return self.map({$0.maxY}).maxElement()
  }

  var minX: CGFloat? {
    return self.map({$0.minX}).minElement()
  }

  var minY: CGFloat? {
    return self.map({$0.minY}).minElement()
  }

  var midX: CGFloat? {
    return maxX.flatMap({ x in
      return minX.map({(x + $0) / 2})
    })
  }
}
