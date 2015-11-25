import Foundation

// parsers for header

let parseReference = createParser("^X:\\s*(\\d+)$\n?", op: { m -> Header in
  Reference(number: Int(m[1].match)!)
})

let parseTuneTitle = createParser("^T:\\s*(.+)$\n?", op: { m -> Header in
  TuneTitle(title: m[1].match)
})

let parseComposer = createParser("^C:\\s*(.+)$\n?", op: { m -> Header in
  Composer(name: m[1].match)
})

let parseMeter = createParser("^M:\\s*((?:\\d+/\\d+)|C\\||C)$\n?", op: { matches -> Header in
  var (num, den) = (4, 4)
  let body = matches[1].match
  switch body {
  case "C|":
    (num, den) = (2, 2)
  case "C":
    (num, den) = (4, 4)
  default:
    let m = body.matchesWithPattern("(\\d+)/(\\d+)")
    num = Int(m[1].match)!
    den = Int(m[2].match)!
  }
  return Meter(numerator: num, denominator: den)
})

let parseUnitNoteLength = createParser("^L:\\s*1/(\\d+)$\n?", op: { m -> Header in
  let den = Int(m[1].match)!
  return UnitNoteLength(denominator: UnitDenominator(rawValue: den) ?? .Quarter)
})

let parseTempo = createParser("^Q:\\s*(\\d+)/(\\d+)=(\\d+)$\n?", op: { m -> Header in
  let num = Int(m[1].match)!
  let den = Int(m[2].match)!
  let bpm = Int(m[3].match)!

  return Tempo(bpm: bpm, inLength: NoteLength(numerator: num, denominator: den))
})

let parseKey = createParser("^K:\\s*([ABCDEFG][#b]?m?)\\s*(?:octave=(-?\\d))?$\n?", op: { m -> Header in
  var sig: KeySignature

  switch m[1].match {
  case "C", "Am": sig = .Zero
  case "G", "Em": sig = .Sharp1
  case "D", "Bm": sig = .Sharp2
  case "A", "F#m": sig = .Sharp3
  case "E", "C#m": sig = .Sharp4
  case "B", "G#m": sig = .Sharp5
  case "F#", "D#m": sig = .Sharp6
  case "C#", "A#m": sig = .Sharp7
  case "F", "Dm": sig = .Flat1
  case "Bb", "Gm": sig = .Flat2
  case "Eb", "Cm": sig = .Flat3
  case "Ab", "Fm": sig = .Flat4
  case "Db", "Bbm": sig = .Flat5
  case "Gb", "Ebm": sig = .Flat6
  case "Cb", "Abm": sig = .Flat7
  default: sig = .Zero
  }

  if m.count > 2 {
    return Key(keySignature: sig, octave: Int(m[2].match)!)
  } else {
    return Key(keySignature: sig)
  }
})

let parseVoiceHeader = createParser("^V:\\s*(\\w+)\\s*(?:clef=(\\w+))?$\n?", op: { m -> Header in
  let id = m[1].match
  if m.count < 3 {
    return VoiceHeader(id: id, clef: Clef(clefName: .Treble))
  } else {
    let clefName = ClefName(rawValue: m[2].match) ?? .Treble
    return VoiceHeader(id: id, clef: Clef(clefName: clefName))
  }
})

let eatComment = eatPattern("^%.*$\n?")

let eatEmptyLine = eatPattern("^\\s.*$\n?")

let parseHeader =
parseReference ||
  parseTuneTitle ||
  parseComposer ||
  parseMeter ||
  parseUnitNoteLength ||
  parseTempo ||
  parseKey ||
parseVoiceHeader

// parsers for element

let parseDoubleBarLine = createParser("\\|\\|", op: { m -> MusicalElement in
  Simple.DoubleBarLine
})

let parseRepeatStart = createParser("\\|:", op: { m -> MusicalElement in
  Simple.RepeatStart
})

let parseRepeatEnd = createParser(":\\|", op: { m -> MusicalElement in
  Simple.RepeatEnd
})

let parseBarLine = createParser("\\|", op: { m -> MusicalElement in
  Simple.BarLine
})

let parseSlurStart = createParser("\\(", op: { m -> MusicalElement in
  Simple.SlurStart
})

let parseSlurEnd = createParser("\\)", op: { m -> MusicalElement in
  Simple.SlurEnd
})

let parseSpace = createParser("\\s+", op: { m -> MusicalElement in
  Simple.Space
})

let parseTie = createParser("-", op: { m -> MusicalElement in
  Simple.Tie
})

let parseLineBreak = createParser("\n", op: { m -> MusicalElement in
  Simple.LineBreak
})

let parseVoiceId = createParser("^\\[V:\\s*(\\w+)\\]", op: { m -> MusicalElement in
  VoiceId(id: m[1].match)
})

let parsePitch = createParser("(\\^{0,2}|_{0,2}|=?)([a-g]|[A-G])([',]*)", op: { m -> Pitch in
  var accidental: Accidental?
  var pitchName: PitchName
  var octave: Int = 0

  switch m[1].match {
  case "^^": accidental = .DoubleSharp
  case "^": accidental = .Sharp
  case "=": accidental = .Natural
  case "_": accidental = .Flat
  case "__": accidental = .DoubleFlat
  default: accidental = nil
  }

  switch m[2].match {
  case "C": pitchName = .C
  case "c": pitchName = .C; octave = 1
  case "D": pitchName = .D
  case "d": pitchName = .D; octave = 1
  case "E": pitchName = .E
  case "e": pitchName = .E; octave = 1
  case "F": pitchName = .F
  case "f": pitchName = .F; octave = 1
  case "G": pitchName = .G
  case "g": pitchName = .G; octave = 1
  case "A": pitchName = .A
  case "a": pitchName = .A; octave = 1
  case "B": pitchName = .B
  case "b": pitchName = .B; octave = 1
  default: pitchName = .C
  }

  octave += m[3].match.characters.filter({ $0 == "'" }).count
  octave -= m[3].match.characters.filter({ $0 == "," }).count

  return Pitch(
    name: pitchName,
    accidental: accidental,
    octave: octave)
})

let parseNoteLength = createParser("(\\d*)/(\\d+)", op: { m -> NoteLength in
  var num: Int
  if m[1].match.isEmpty {
    num = 1
  } else {
    num = Int(m[1].match)!
  }

  var den: Int
  if m[2].match.isEmpty {
    den = 1
  } else {
    den = Int(m[2].match)!
  }

  return NoteLength(numerator: num, denominator: den)
}) || createParser("(\\d*)(/*)", op: { m -> NoteLength in
  var num: Int
  if m[1].match.isEmpty {
    num = 1
  } else {
    num = Int(m[1].match)!
  }

  var den = 1
  for i in 0..<m[2].match.characters.count {
    den *= 2
  }

  return NoteLength(numerator: num, denominator: den)
})

let parseNote = { (s: String) -> (ParseResult<MusicalElement>, String) in
  let (pitchOpt, lengthOpt, rest) = (parsePitch && parseNoteLength)(s)
  var note: Note?
  if let pitch = pitchOpt.result, length = lengthOpt.result {
    note = Note(length: length, pitch: pitch)
  } else {
    note = nil
  }

  return (ParseResult(result: note, ateLength: pitchOpt.ateLength + lengthOpt.ateLength), rest)
}

let parseRest = { (s: String) -> (ParseResult<MusicalElement>, String) in
  let (lengthOpt, rest) = (eatPattern("z") &> parseNoteLength)(s)
  var r: Rest?
  if let length = lengthOpt.result {
    r = Rest(length: length)
  } else {
    r = nil
  }
  return (ParseResult(result: r, ateLength: lengthOpt.ateLength), rest)
}

let parseMultiMeasureRest = createParser("Z(\\d*)", op: { m -> MusicalElement in
  MultiMeasureRest(num: Int(m[1].match)!)
})

let parseChord = { (s: String) -> (ParseResult<MusicalElement>, String) in
  let (pitchResult, rest) = (eatPattern("\\[") &> many(parsePitch) &< eatPattern("\\]"))(s)
  if pitchResult.isEmpty {
    return (emptyParseResult(), s)
  } else {
    let (lengthResult, lRest) = parseNoteLength(rest)
    if let l = lengthResult.result {
      return (ParseResult(result: Chord(length: l, pitches: pitchResult.result),
        ateLength: pitchResult.ateLength + lengthResult.ateLength), lRest)
    } else {
      return (emptyParseResult(), s)
    }
  }
}

func parseTuplet(s: String) -> (ParseResult<MusicalElement>, String) {
  let (nOpt, rest) = (createParser("\\(([2-9])", op: { m -> Int in
    Int(m[1].match)!
  }))(s)

  if let n = nOpt.result {
    let (elems, eR) = many(parseChord || parseNote || parseRest, n: n)(rest)
    if elems.isEmpty {
      return (emptyParseResult(), s)
    } else {
      return (ParseResult(result: Tuplet(notes: n, inTimeOf: nil, elements: elems.result.map { $0 as! TupletMember }), ateLength: nOpt.ateLength + elems.ateLength), eR)
    }
  } else {
    return (emptyParseResult(), s)
  }
}

let parseElement = parseTuplet ||
  parseDoubleBarLine ||
  parseRepeatStart ||
  parseRepeatEnd ||
  parseBarLine ||
  parseSlurStart ||
  parseSlurEnd ||
  parseTie ||
  parseLineBreak ||
  parseSpace ||
  parseVoiceId ||
  parseNote ||
  parseRest ||
  parseMultiMeasureRest ||
parseChord

public struct TuneParseResult {
  public let tune: Tune?
  public let errorPosition: Int?

  public var errorMessage: String {
    return "parse error at : \(errorPosition)"
  }

  public init(tune: Tune?, errorPosition: Int?) {
    self.tune = tune
    self.errorPosition = errorPosition
  }
}

// parse string in subset of ABC notation to tune
public class ABCParser {
  private let string: String
  private static let defaultVoiceId = "default"

  public init(string: String) {
    self.string = string
  }

  private func buildTuneHeader(headers: [Header]) -> TuneHeader {
    var reference: Reference? = nil
    var tuneTitle: TuneTitle? = nil
    var composer: Composer? = nil
    var meter: Meter? = nil
    var unitNoteLength: UnitNoteLength? = nil
    var tempo: Tempo? = nil
    var key: Key? = nil
    var voiceHeaders: [VoiceHeader] = []

    for h in headers {
      switch h {
      case let r as Reference: reference = r
      case let t as TuneTitle: tuneTitle = t
      case let c as Composer: composer = c
      case let m as Meter: meter = m
      case let u as UnitNoteLength: unitNoteLength = u
      case let t as Tempo: tempo = t
      case let k as Key: key = k
      case let v as VoiceHeader: voiceHeaders.append(v)
      default: ()
      }
    }

    if voiceHeaders.isEmpty {
      voiceHeaders.append(VoiceHeader(id: ABCParser.defaultVoiceId, clef: Clef(clefName: .Treble)))
    }

    return TuneHeader(
      reference: reference,
      tuneTitle: tuneTitle,
      composer: composer,
      meter: meter ?? Meter(numerator: 4, denominator: 4),
      unitNoteLength: unitNoteLength ?? UnitNoteLength(denominator: .Quarter),
      tempo: tempo ?? Tempo(bpm: 120, inLength: NoteLength(numerator: 1, denominator: 1)),
      key: key ?? Key(keySignature: .Zero),
      voiceHeaders: voiceHeaders)
  }

  private func buildTuneBody(elems: [MusicalElement]) -> TuneBody {
    var voiceIdElementsMap: [String : [MusicalElement]] = [:]
    var currentVoiceId = ABCParser.defaultVoiceId
    voiceIdElementsMap[currentVoiceId] = []

    for m in elems {
      switch m {
      case let v as VoiceId:
        currentVoiceId = v.id
        if voiceIdElementsMap[currentVoiceId] == nil {
          voiceIdElementsMap[currentVoiceId] = []
        }

      default: voiceIdElementsMap[currentVoiceId]?.append(m)
      }
    }

    if voiceIdElementsMap[ABCParser.defaultVoiceId]!.isEmpty {
      voiceIdElementsMap.removeValueForKey(ABCParser.defaultVoiceId)
    }

    var voices: [Voice] = []
    for (id, elements) in voiceIdElementsMap {
      voices.append(Voice(id: id, elements: elements))
    }

    return TuneBody(voices: voices)
  }

  private func buildResult(headers: [Header], elems: [MusicalElement]) -> Tune {
    let header = buildTuneHeader(headers)
    let body = buildTuneBody(elems)

    return Tune(tuneHeader: header, tuneBody: body)
  }

  private func parseIter(string: String, position: Int, headers: [Header], elems: [MusicalElement]) -> TuneParseResult {
    var ateLength = 0

    var (r, str) = many(eatComment)(string)
    ateLength += r.ateLength

    (r, str) = many(eatEmptyLine)(str)
    ateLength += r.ateLength

    if (str.isEmpty) {
      return TuneParseResult(tune: buildResult(headers, elems: elems), errorPosition: nil)
    } else {
      var nextHeaders = headers
      var nextElements = elems
      var (hOpt, rest) = parseHeader(str)
      ateLength += hOpt.ateLength

      if let h = hOpt.result {
        nextHeaders.append(h)
      } else {
        let (es, eRest) = many(parseElement)(str)
        ateLength += es.ateLength

        rest = eRest
        if !es.isEmpty {
          nextElements.appendContentsOf(es.result)
        }
      }

      if ateLength == 0 {
        return TuneParseResult(tune: nil, errorPosition: position)
      } else {
        return parseIter(rest, position: position + ateLength, headers: nextHeaders, elems: nextElements)
      }
    }
  }
  
  public func parse() -> TuneParseResult {
    return parseIter(string, position: 0, headers: [], elems: [])
  }
}
