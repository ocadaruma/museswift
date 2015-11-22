import Foundation

public protocol MusicalElement {}
public protocol HasLength {
  var length: NoteLength { get }
}
public protocol TupletMember : MusicalElement, HasLength {}
public protocol BeamMember: MusicalElement, HasLength {}

public enum Simple : MusicalElement {
  case BarLine
  case DoubleBarLine
  case SlurStart
  case SlurEnd
  case RepeatStart
  case RepeatEnd
  case Tie
  case Space
  case LineBreak
  case End
}

public struct Note : TupletMember, BeamMember, Equatable {
  public let length: NoteLength
  public let pitch: Pitch
  public init(length: NoteLength, pitch: Pitch) {
    self.length = length
    self.pitch = pitch
  }
}

public func ==(lhs: Note, rhs: Note) -> Bool {
  return lhs.length == rhs.length &&
    lhs.pitch == rhs.pitch
}

public struct Rest: TupletMember, Equatable {
  public let length: NoteLength
  public init(length: NoteLength) {
    self.length = length
  }
}

public func ==(lhs: Rest, rhs: Rest) -> Bool {
  return lhs.length == rhs.length
}

public struct MultiMeasureRest : MusicalElement, Equatable {
  public let num: Int
}

public func ==(lhs: MultiMeasureRest, rhs: MultiMeasureRest) -> Bool {
  return lhs.num == rhs.num
}

public struct Chord : TupletMember, BeamMember, Equatable {
  public let length: NoteLength
  public let pitches: [Pitch]
  public init(length: NoteLength, pitches: [Pitch]) {
    self.length = length
    self.pitches = pitches
  }
}

public func ==(lhs: Chord, rhs: Chord) -> Bool {
  return lhs.length == rhs.length &&
    lhs.pitches == rhs.pitches
}

public struct VoiceId : MusicalElement, Equatable {
  public let id: String
}

public func ==(lhs: VoiceId, rhs: VoiceId) -> Bool {
  return lhs.id == rhs.id
}

public struct Tuplet : MusicalElement {
  public let notes: Int
  public let inTimeOf: Int?
  private let defaultTime: Int = 3

  public let elements: [TupletMember]

  public var time: Int {
    get {
      if let t = inTimeOf {
        return t
      } else {
        switch notes {
        case 2, 4, 8: return 3
        case 3, 6: return 2
        default: return self.defaultTime
        }
      }
    }
  }
}
