import XCTest
@testable import MuseSwift

class ParserTests: XCTestCase {
  func testParseEntireSong() {
    let path = NSBundle(forClass: ParserTests.self).pathForResource("song", ofType: "txt")!
    let string = try! String(contentsOfFile: path)
    let parser = ABCParser(string: string)
    let tune = parser.parse().tune!

    //tune header
    let header = tune.tuneHeader
    XCTAssertEqual(header.reference!.number, 1)
    XCTAssertEqual(header.tuneTitle!.title, "Zocharti Loch")
    XCTAssertEqual(header.composer!.name, "Louis Lewandowski (1821-1894)")
    XCTAssertEqual(header.meter.numerator, 4)
    XCTAssertEqual(header.meter.denominator, 4)
    XCTAssertEqual(header.tempo.bpm, 76)
    XCTAssertEqual(header.tempo.inLength.numerator, 1)
    XCTAssertEqual(header.tempo.inLength.denominator, 4)

    let v1 = header.voiceHeaders[0]
    let v2 = header.voiceHeaders[1]

    XCTAssertEqual(v1.id, "T1")
    XCTAssertEqual(v1.clef.clefName, ClefName.Treble)

    XCTAssertEqual(v2.id, "B1")
    XCTAssertEqual(v2.clef.clefName, ClefName.Bass)

    XCTAssertEqual(header.key.keySignature, KeySignature.Flat2)
    XCTAssertEqual(header.key.octave, -1)
    XCTAssertEqual(header.unitNoteLength.denominator, UnitDenominator.Quarter)

    //tune body
    let voice1 = tune.tuneBody.voices[0]
    XCTAssertEqual(voice1.id, "T1")
    XCTAssertEqual(voice1.elements.count, 31)
    XCTAssertEqual(voice1.elements[0] as? Simple, .Space)
    XCTAssertEqual(voice1.elements[1] as? Simple, .SlurStart)
    XCTAssertEqual(voice1.elements[2] as? Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .B, accidental: nil, offset: 0)))
    XCTAssertEqual(voice1.elements[3] as? Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .C, accidental: nil, offset: 1)))
    XCTAssertEqual(voice1.elements[4] as? Simple, .Space)
    XCTAssertEqual(voice1.elements[5] as? Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .D, accidental: nil, offset: 1)))
    XCTAssertEqual(voice1.elements[6] as? Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .G, accidental: nil, offset: 1)))
    XCTAssertEqual(voice1.elements[7] as? Simple, .SlurEnd)
    XCTAssertEqual(voice1.elements[8] as? Simple, .Space)
    XCTAssertEqual(voice1.elements[9] as? Simple, .BarLine)
    XCTAssertEqual(voice1.elements[10] as? Simple, .Space)
    XCTAssertEqual(voice1.elements[11] as? Note,
      Note(
        length: NoteLength(numerator: 6, denominator: 1),
        pitch: Pitch(name: .F, accidental: nil, offset: 1)))
    XCTAssertEqual(voice1.elements[12] as? Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .E, accidental: nil, offset: 1)))
    XCTAssertEqual(voice1.elements[13] as? Simple, .Space)
    XCTAssertEqual(voice1.elements[14] as? Simple, .BarLine)
    XCTAssertEqual(voice1.elements[15] as? Simple, .LineBreak)
    XCTAssertEqual(voice1.elements[16] as? Simple, .Space)
    XCTAssertEqual(voice1.elements[17] as? Simple, .SlurStart)
    XCTAssertEqual(voice1.elements[18] as? Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .B, accidental: nil, offset: 0)))
    XCTAssertEqual(voice1.elements[19] as? Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .C, accidental: nil, offset: 1)))
    XCTAssertEqual(voice1.elements[20] as? Simple, .Space)
    XCTAssertEqual(voice1.elements[21] as? Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .D, accidental: nil, offset: 1)))
    XCTAssertEqual(voice1.elements[22] as? Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .G, accidental: nil, offset: 1)))
    XCTAssertEqual(voice1.elements[23] as? Simple, .SlurEnd)
    XCTAssertEqual(voice1.elements[24] as? Simple, .Space)
    XCTAssertEqual(voice1.elements[25] as? Simple, .BarLine)
    XCTAssertEqual(voice1.elements[26] as? Simple, .Space)
    XCTAssertEqual(voice1.elements[27] as? Note,
      Note(
        length: NoteLength(numerator: 8, denominator: 1),
        pitch: Pitch(name: .F, accidental: nil, offset: 1)))
    XCTAssertEqual(voice1.elements[28] as? Simple, .Space)
    XCTAssertEqual(voice1.elements[29] as? Simple, .BarLine)
    XCTAssertEqual(voice1.elements[30] as? Simple, .LineBreak)

    //voice 2
    let voice2 = tune.tuneBody.voices[1]
    XCTAssertEqual(voice2.id, "B1")
    XCTAssertEqual(voice2.elements.count, 28)
    XCTAssertEqual(voice2.elements[0] as? Simple, .Space)
    XCTAssertEqual(voice2.elements[1] as? Rest, Rest(length: NoteLength(numerator: 8, denominator: 1)))
    XCTAssertEqual(voice2.elements[2] as? Simple, .Space)
    XCTAssertEqual(voice2.elements[3] as? Simple, .BarLine)
    XCTAssertEqual(voice2.elements[4] as? Simple, .Space)
    XCTAssertEqual(voice2.elements[5] as? Rest, Rest(length: NoteLength(numerator: 2, denominator: 1)))
    XCTAssertEqual(voice2.elements[6] as? Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .F, accidental: nil, offset: 1)))
    XCTAssertEqual(voice2.elements[7] as? Simple, .Space)
    XCTAssertEqual(voice2.elements[8] as? Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .G, accidental: nil, offset: 1)))
    XCTAssertEqual(voice2.elements[9] as? Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .A, accidental: nil, offset: 1)))
    XCTAssertEqual(voice2.elements[10] as? Simple, .Space)
    XCTAssertEqual(voice2.elements[11] as? Simple, .BarLine)
    XCTAssertEqual(voice2.elements[12] as? Simple, .LineBreak)
    XCTAssertEqual(voice2.elements[13] as? Simple, .Space)
    XCTAssertEqual(voice2.elements[14] as? Simple, .SlurStart)
    XCTAssertEqual(voice2.elements[15] as? Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .D, accidental: nil, offset: 1)))
    XCTAssertEqual(voice2.elements[16] as? Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .F, accidental: nil, offset: 1)))
    XCTAssertEqual(voice2.elements[17] as? Simple, .Space)
    XCTAssertEqual(voice2.elements[18] as? Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .B, accidental: nil, offset: 1)))
    XCTAssertEqual(voice2.elements[19] as? Note,
      Note(
        length: NoteLength(numerator: 2, denominator: 1),
        pitch: Pitch(name: .E, accidental: nil, offset: 2)))
    XCTAssertEqual(voice2.elements[20] as? Simple, .SlurEnd)
    XCTAssertEqual(voice2.elements[21] as? Simple, .Space)
    XCTAssertEqual(voice2.elements[22] as? Simple, .BarLine)
    XCTAssertEqual(voice2.elements[23] as? Simple, .Space)
    XCTAssertEqual(voice2.elements[24] as? Note,
      Note(
        length: NoteLength(numerator: 8, denominator: 1),
        pitch: Pitch(name: .D, accidental: nil, offset: 2)))
    XCTAssertEqual(voice2.elements[25] as? Simple, .Space)
    XCTAssertEqual(voice2.elements[26] as? Simple, .BarLine)
    XCTAssertEqual(voice2.elements[27] as? Simple, .LineBreak)
  }

  func testParseSimpleSong() {
    let parser = ABCParser(string: "|(3ABA (3[c,^e,g,,]zB|")
    let tune = parser.parse().tune!

    let voice = tune.tuneBody.voices[0]

    XCTAssertEqual(voice.id, "default")
    XCTAssertEqual(voice.elements[0] as? Simple, .BarLine)
    let t1 = voice.elements[1] as! Tuplet
    XCTAssertEqual(t1.time, 2)
    XCTAssertEqual(t1.notes, 3)
    XCTAssertEqual(t1.elements[0] as? Note,
      Note(
        length: NoteLength(numerator: 1, denominator: 1),
        pitch: Pitch(name: .A, accidental: nil, offset: 0)))
    XCTAssertEqual(t1.elements[1] as? Note,
      Note(
        length: NoteLength(numerator: 1, denominator: 1),
        pitch: Pitch(name: .B, accidental: nil, offset: 0)))
    XCTAssertEqual(t1.elements[2] as? Note,
      Note(
        length: NoteLength(numerator: 1, denominator: 1),
        pitch: Pitch(name: .A, accidental: nil, offset: 0)))
    XCTAssertEqual(voice.elements[2] as? Simple, .Space)
    let t2 = voice.elements[3] as! Tuplet
    XCTAssertEqual(t2.elements[0] as? Chord,
      Chord(
        length: NoteLength(numerator: 1, denominator: 1),
        pitches:
        [Pitch(name: .C, accidental: nil, offset: 0),
          Pitch(name: .E, accidental: .Sharp, offset: 0),
          Pitch(name: .G, accidental: nil, offset: -1)]))
    XCTAssertEqual(t2.elements[1] as? Rest,
      Rest(length: NoteLength(numerator: 1, denominator: 1)))
    XCTAssertEqual(t2.elements[2] as? Note,
      Note(
        length: NoteLength(numerator: 1, denominator: 1),
        pitch: Pitch(name: .B, accidental: nil, offset: 0)))
    XCTAssertEqual(voice.elements[4] as? Simple, .BarLine)
  }

  func testSyntaxError() {
    let parser = ABCParser(string: "ABCD~j~")
    let tune = parser.parse()
    print(tune.errorMessage)
    XCTAssert(tune.tune == nil)
  }
}