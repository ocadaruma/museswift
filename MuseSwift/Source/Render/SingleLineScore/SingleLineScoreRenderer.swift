import Foundation

class SingleLineScoreRenderer {
  let unitDenominator: UnitDenominator
  let layout: SingleLineScoreLayout
  let bounds: CGRect

  init(
    unitDenominator: UnitDenominator,
    layout: SingleLineScoreLayout,
    bounds: CGRect) {
      self.unitDenominator = unitDenominator
      self.layout = layout
      self.bounds = bounds
  }

  var staffTop: CGFloat {
    return (bounds.height - layout.staffHeight) / 2
  }

  private var BOn3rdStave: Pitch {
    return Pitch(name: .B, accidental: nil, octave: 0)
  }

  private var AAbove1stStave: Pitch {
    return Pitch(name: .A, accidental: nil, octave: 1)
  }

  private var MiddleC: Pitch {
    return Pitch(name: .C, accidental: nil, octave: 0)
  }

  private enum NoteHeadColumn {
    case Left, Right
    var invert: NoteHeadColumn {
      return self == .Left ? .Right : .Left
    }
  }

  private func noteHeadTop(pitch: Pitch) -> CGFloat {
    let noteInterval = layout.staffInterval / 2
    let c0 = staffTop + noteInterval * 9

    return c0 - CGFloat(7 * pitch.octave + pitch.name.rawValue) * noteInterval
  }

  private func createDotFrame(pitch: Pitch, x: CGFloat) -> CGRect {
    let step = 7 * pitch.octave + pitch.name.rawValue
    let noteInterval = layout.staffInterval / 2
    let y = staffTop + noteInterval * 9 - CGFloat(step + (step + 1) % 2) * noteInterval

    let d = layout.staffLineWidth * 5
    return CGRect(x: x + layout.dotMarginLeft, y: y + noteInterval - d / 2, width: d, height: d)
  }

  private func createDots(pitch: Pitch, x: CGFloat, length: Float, denominator: Float) -> [EllipseElement] {
    var result = [EllipseElement]()
    let length1 = length - denominator
    let denom1 = denominator / 2
    if length1 >= denom1 {
      let dot1 = EllipseElement(frame: createDotFrame(pitch, x: x))
      result.append(dot1)

      let length2 = length1 - denom1
      let denom2 = denom1 / 2
      if length2 >= denom2 {
        result.append(
          EllipseElement(frame: dot1.frame.withX(dot1.frame.x + dot1.frame.width + layout.staffLineWidth)))
      }
    }

    return result
  }

  private func createDotsForRest(x: CGFloat, length: Float, denominator: Float) -> [EllipseElement] {
    return createDots(Pitch(name: .C, accidental: nil, octave: 1), x: x, length: length, denominator: denominator)
  }

  private func createNoteHeadFrame(pitch: Pitch, xOffset: CGFloat) -> CGRect {
    let width = layout.noteHeadSize.width
    return CGRect(x: xOffset, y: noteHeadTop(pitch), width: width, height: layout.noteHeadSize.height)
  }

  private func createFillingStaff(xOffset: CGFloat, pitch: Pitch) -> [RectElement] {
    let step = pitch.step
    let upperBound = AAbove1stStave.step
    let lowerBound = MiddleC.step
    let frame = createNoteHeadFrame(pitch, xOffset: xOffset)
    var staff = [RectElement]()

    let x = frame.x - (layout.outsideStaffLineXLength - frame.width) / 2
    if step >= upperBound {
      for i in 1...(1 + (step - upperBound).abs / 2) {
        let y = staffTop - (CGFloat(i) * layout.staffInterval)
        staff.append(RectElement(frame: CGRect(x: x, y: y, width: layout.outsideStaffLineXLength, height: layout.outsideStaffLineWidth)))
      }
    } else if step <= lowerBound {
      for i in 1...(1 + (step - lowerBound).abs / 2) {
        let y = staffTop + layout.staffHeight - layout.staffLineWidth + (CGFloat(i) * layout.staffInterval)
        staff.append(RectElement(frame: CGRect(x: x, y: y, width: layout.outsideStaffLineXLength, height: layout.outsideStaffLineWidth)))
      }
    }

    return staff
  }

  private func createAccidental(pitch: Pitch, xOffset: CGFloat) -> ScoreElement? {
    let noteHeadFrame = createNoteHeadFrame(pitch, xOffset: xOffset)
    var view: ScoreElement? = nil

    switch pitch.accidental {
    case .Some(.DoubleFlat):
      view = DoubleFlatElement(frame:
        CGRect(
          x: noteHeadFrame.x - layout.staffInterval * 1.5,
          y: noteHeadFrame.y - layout.staffInterval * 1.2,
          width: layout.staffInterval * 1.2,
          height: layout.staffInterval * 1.2 + noteHeadFrame.height))
    case .Some(.Flat):
      view = FlatElement(frame:
        CGRect(
          x: noteHeadFrame.x - layout.staffInterval,
          y: noteHeadFrame.y - layout.staffInterval * 1.2,
          width: layout.staffInterval * 0.8,
          height: layout.staffInterval * 1.2 + noteHeadFrame.height))
    case .Some(.Natural):
      view = NaturalElement(frame:
        CGRect(
          x: noteHeadFrame.x - layout.staffInterval,
          y: noteHeadFrame.y - layout.staffInterval * 0.5,
          width: layout.staffInterval * 0.6,
          height: layout.staffInterval * 2))
    case .Some(.Sharp):
      view = SharpElement(frame:
        CGRect(
          x: noteHeadFrame.x - layout.staffInterval,
          y: noteHeadFrame.y - layout.staffInterval * 0.5,
          width: layout.staffInterval * 0.8,
          height: layout.staffInterval * 2))
    case .Some(.DoubleSharp):
      view = DoubleSharpElement(frame:
        CGRect(
          x: noteHeadFrame.x - layout.staffInterval * 1.2,
          y: noteHeadFrame.y,
          width: layout.staffInterval,
          height: layout.staffInterval))
    default: break
    }

    return view
  }

  private func createFlag(noteLength: NoteLength, stemFrame: CGRect, invert: Bool) -> ScoreElement {
    let flagFrame: CGRect
    if (invert) {
      flagFrame = CGRect(
        x: stemFrame.x,
        y: stemFrame.maxY - layout.staffInterval * 3,
        width: layout.noteHeadSize.width,
        height: layout.staffInterval * 3)
    } else {
      flagFrame = CGRect(
        x: stemFrame.maxX,
        y: stemFrame.y,
        width: layout.noteHeadSize.width,
        height: layout.staffInterval * 3)
    }

    let length = noteLength.actualLength(unitDenominator)
    var element: ScoreElement! = nil
    if length >= Eighth {
      let flag = FlagEighthElement(frame: flagFrame)
      flag.invert = invert
      element = flag
    } else if length >= Sixteenth {
      let flag = FlagSixteenthElement(frame: flagFrame)
      flag.invert = invert
      element = flag
    }

    return element
  }

  private func createUnits(xOffset: CGFloat, tuplet: Tuplet) -> [(offset: CGFloat, unit: Either<(noteUnit: NoteUnit, stem: RectElement), RestUnit>)] {
    let ratio = CGFloat(tuplet.time) / CGFloat(tuplet.notes)

    var offset = xOffset
    var units = [(offset: CGFloat, unit: Either<(noteUnit: NoteUnit, stem: RectElement), RestUnit>)]()
    for e in tuplet.elements {
      switch e {
      case let note as Note:
        let noteUnit = createNoteUnit(offset, note: note, invert: shouldInvert(note))
        let stem = createStem(noteUnit)
        units.append(
          (offset: offset, unit: .Left(left: (noteUnit: noteUnit, stem: stem)))
        )
        offset += rendereredWidthForNoteLength(note.length) * ratio
      case let chord as Chord:
        let noteUnit = createNoteUnit(offset, chord: chord, invert: shouldInvert(chord))
        let stem = createStem(noteUnit)
        units.append(
          (offset: offset, unit: .Left(left: (noteUnit: noteUnit, stem: stem)))
        )
        offset += rendereredWidthForNoteLength(chord.length) * ratio
      case let rest as Rest:
        let restUnit = createRestUnit(offset, rest: rest)
        units.append(
          (offset: offset, unit: .Right(right: restUnit))
        )
        offset += rendereredWidthForNoteLength(rest.length) * ratio
      default: break
      }
    }

    return units
  }

  private func createBracketElement(notes: Int, envelope: [CGPoint], point: CGPoint, invert: Bool) -> BracketElement {
    let firstPoint = envelope.first!
    let lastPoint = envelope.last!

    let a = (lastPoint.y - firstPoint.y) / (lastPoint.x - firstPoint.x)
    let slope = a.abs < layout.maxBeamSlope ? a : layout.maxBeamSlope * a.sign
    let f = linearFunction(slope,
      point: Point2D(
        x: point.x,
        y: point.y))

    let (x1, y1) = (firstPoint.x, f(firstPoint.x))
    let (x2, y2) = (lastPoint.x, f(lastPoint.x))

    let height = max(y2 - y1, layout.tupletFontSize)
    let bracket = BracketElement(frame: CGRect(
      x: x1,
      y: invert ? y1 : y1 - height,
      width: x2 - x1,
      height: height)
    )

    bracket.invert = invert
    bracket.notes = notes
    bracket.fontSize = layout.tupletFontSize
    bracket.rightDown = y2 > y1

    return bracket
  }

  func rendereredWidthForNoteLength(noteLength: NoteLength) -> CGFloat {
    return layout.widthPerUnitNoteLength * CGFloat(noteLength.numerator) / CGFloat(noteLength.denominator)
  }

  func shouldInvert(chord: Chord) -> Bool {
    return chord.pitches.map({$0.step}).sum() / chord.pitches.count >= BOn3rdStave.step
  }

  func shouldInvert(note: Note) -> Bool {
    return note.pitch.step >= BOn3rdStave.step
  }

  func createRestUnit(xOffset: CGFloat, rest: Rest) -> RestUnit {
    let length = rest.length.actualLength(unitDenominator)

    var restView: ScoreElement! = nil
    var dots = [EllipseElement]()

    if (length >= Whole) {
      restView = RectElement()
      let width = layout.staffInterval * 1.5
      restView.frame = CGRect(
        x: xOffset + rendereredWidthForNoteLength(rest.length) / 2 - (width / 2),
        y: staffTop + layout.staffInterval,
        width: width,
        height: layout.staffInterval * 0.6)
    } else if (length >= Half) {
      restView = RectElement()
      let width = layout.staffInterval * 1.5
      let height = layout.staffInterval * 0.6
      restView.frame = CGRect(
        x: xOffset + rendereredWidthForNoteLength(rest.length) / 2 - (width / 2),
        y: staffTop + layout.staffInterval * 2 - height,
        width: width,
        height: height)
      dots += createDotsForRest(restView.frame.maxX, length: length, denominator: Half)
    } else if (length >= Quarter) {
      restView = QuarterRestElement()
      restView.frame = CGRect(
        x: xOffset,
        y: staffTop + layout.staffInterval / 2,
        width: layout.staffInterval * 1.1,
        height: layout.staffInterval * 2.5)
      dots += createDotsForRest(restView.frame.maxX, length: length, denominator: Quarter)
    } else if (length >= Eighth) {
      restView = EighthRestElement()
      restView.frame = CGRect(
        x: xOffset,
        y: staffTop + layout.staffInterval + layout.staffLineWidth,
        width: layout.staffInterval * 1.3,
        height: layout.staffInterval * 2)
      dots += createDotsForRest(restView.frame.maxX, length: length, denominator: Eighth)
    } else if (length >= Sixteenth) {
      restView = SixteenthRestElement()
      restView.frame = CGRect(
        x: xOffset,
        y: staffTop + layout.staffInterval + layout.staffLineWidth,
        width: layout.staffInterval * 1.3,
        height: layout.staffInterval * 3)
      dots += createDotsForRest(restView.frame.maxX, length: length, denominator: Sixteenth)
    }

    return RestUnit(dots: dots, restView: restView, xOffset: xOffset)
  }

  func createStem(noteUnit: NoteUnit) -> RectElement {
    let noteHeadFrames = noteUnit.noteHeads.map({$0.frame})
    let bottomFrame = noteHeadFrames.maxBy({$0.y})!
    let topFrame = noteHeadFrames.minBy({$0.y})!

    let stem = RectElement()
    let stemHeight = layout.staffInterval * 3
    let x = noteUnit.singleColumn && noteUnit.invert ? topFrame.x : noteHeadFrames.map({$0.maxX}).minElement()!

    if noteUnit.invert {
      stem.frame = CGRect(
        x: x,
        y: topFrame.y + topFrame.height * 0.6,
        width: layout.stemWidth,
        height: stemHeight + bottomFrame.y - topFrame.y)
    } else {
      stem.frame = CGRect(
        x: x - layout.stemWidth,
        y: topFrame.y - stemHeight,
        width: layout.stemWidth,
        height: stemHeight + bottomFrame.y - topFrame.y + bottomFrame.height * 0.4)
    }

    return stem
  }

  func createNoteUnit(xOffset: CGFloat, note: Note, invert: Bool) -> NoteUnit {
    return createNoteUnit(xOffset, chord: Chord(length: note.length, pitches: [note.pitch]), invert: invert)
  }

  func createNoteUnit(xOffset: CGFloat, chord: Chord, invert: Bool) -> NoteUnit {
    let sortedPitches = invert ? chord.pitches.sortBy({$0.step}).reverse() : chord.pitches.sortBy({$0.step})
    let sparce = sortedPitches.sparse

    var noteHeadFrames = [(pitch: Pitch, frame: CGRect, column: NoteHeadColumn)]()
    var previousPitch: Pitch? = nil

    if sparce {
      for pitch in sortedPitches {
        noteHeadFrames.append((pitch: pitch, frame: createNoteHeadFrame(pitch, xOffset: xOffset), column: .Left))
      }
    } else {
      var column = invert ? NoteHeadColumn.Right : .Left
      for pitch in sortedPitches {
        if let p = previousPitch {
          if (pitch.step - p.step).abs < 2 {
            column = column.invert
          }
        }

        noteHeadFrames.append((
          pitch: pitch,
          frame: createNoteHeadFrame(pitch, xOffset: xOffset).offsetBy(dx: column == .Right ? layout.noteHeadSize.width : 0, dy: 0),
          column: column))
        previousPitch = pitch
      }
    }

    var dots = [EllipseElement]()
    var noteHeads = [ScoreElement]()
    var accidentals = [ScoreElement]()
    var outsideStaff = [RectElement]()

    let length = chord.length.actualLength(unitDenominator)


    for (pitch, frame, column) in noteHeadFrames {
      let noteHead: ScoreElement
      let shouldAddDots = length < Whole && (sparce || column == .Right)
      var d = [EllipseElement]()

      if (length >= Whole) { // whole note
        noteHead = WholeNoteElement()
      } else if (length >= Half) { // half note
        noteHead = WhiteNoteElement()
        if shouldAddDots { d += createDots(pitch, x: frame.maxX, length: length, denominator: Half) }
      } else {
        noteHead = BlackNoteElement()
        if (length >= Quarter) { // quarter note
          if shouldAddDots { d += createDots(pitch, x: frame.maxX, length: length, denominator: Quarter) }
        } else if (length >= Eighth) { // eighth note
          if shouldAddDots { d += createDots(pitch, x: frame.maxX, length: length, denominator: Eighth) }
        } else if (length >= Sixteenth) { // sixteenth note
          if shouldAddDots { d += createDots(pitch, x: frame.maxX, length: length, denominator: Sixteenth) }
        }
      }

      outsideStaff += createFillingStaff(frame.minX, pitch: pitch)
      createAccidental(pitch, xOffset: xOffset).foreach({accidentals.append($0)})

      noteHead.frame = frame
      noteHeads.append(noteHead)
      dots += d
    }

    return NoteUnit(
      dots: dots,
      noteHeads: noteHeads,
      accidentals: accidentals,
      outsideStaff: outsideStaff,
      singleColumn: sparce,
      invert: invert,
      xOffset: xOffset)
  }

  func createElementsForTuplet(tuplet: Tuplet, xOffset: CGFloat) -> [ScoreElement] {
    // assume that all elements in tuplet are same length
    let length = tuplet.elements.first!.length.actualLength(unitDenominator)
    var result = [ScoreElement]()

    if length >= Whole {
      // unsupported
    } else if length >= Quarter {
      let units = createUnits(xOffset, tuplet: tuplet)
      result += units.flatMap({ u -> [ScoreElement] in
        switch u.unit {
        case .Left(let n): return n.noteUnit.allElements + [n.stem]
        case .Right(let r): return r.allElements
        }
      })

      let (inverted, notInverted) = units.flatMap({$0.unit.left.toArray()}).partitionBy({$0.noteUnit.invert})
      let invert = inverted.count > notInverted.count

      if (invert) {
        let upperBound = staffTop + layout.staffHeight
        let envelope = units.map({ pair -> CGPoint in
          switch pair.unit {
          case .Left(let n):
            let frames = (n.noteUnit.noteHeads + [n.stem]).map({$0.frame})
            return CGPoint(
              x: frames.midX!,
              y: max(frames.maxY!, upperBound))
          case .Right(let r): return CGPoint(x: r.restView.frame.midX, y: upperBound)
          }
        })

        let pointAtLowest = envelope.maxBy({$0.y})!
        result.append(createBracketElement(tuplet.notes, envelope: envelope, point: pointAtLowest, invert: invert))
      } else {
        let lowerBound = staffTop
        let envelope = units.map({ pair -> CGPoint in
          switch pair.unit {
          case .Left(let n):
            let frames = (n.noteUnit.noteHeads + [n.stem]).map({$0.frame})
            return CGPoint(
              x: frames.midX!,
              y: min(frames.minY!, lowerBound))
          case .Right(let r): return CGPoint(x: r.restView.frame.midX, y: lowerBound)
          }
        })

        let pointAtHighest = envelope.minBy({$0.y})!
        result.append(createBracketElement(tuplet.notes, envelope: envelope, point: pointAtHighest, invert: invert))
      }
    } else {
      let ratio = CGFloat(tuplet.ratio)
      var offset = xOffset
      var units = [(offset: CGFloat, unit: Either<BeamUnit, RestUnit>)]()
      var elements = [(xOffset: CGFloat, element: BeamMember)]()

      for e in tuplet.elements {
        var beamContinue = false
        switch e {
        case let note as Note:
          elements.append((xOffset: offset, element: note))
          beamContinue = true
        case let chord as Chord:
          elements.append((xOffset: offset, element: chord))
          beamContinue = true
        case let rest as Rest:
          units.append((offset: offset, unit: .Right(right: createRestUnit(offset, rest: rest))))
          beamContinue = false
        default: break
        }
        offset += rendereredWidthForNoteLength(e.length) * ratio
        if !beamContinue {
          for b in createBeamUnit(elements, groupedBy: tuplet.notes) { units.append((offset: elements.first!.xOffset, unit: .Left(left: b))) }
          elements = []
        }
      }
      if elements.nonEmpty {
        for b in createBeamUnit(elements, groupedBy: tuplet.notes) { units.append((offset: elements.first!.xOffset, unit: .Left(left: b))) }
      }
      units = units.sortBy({$0.offset})

      for (_, unit) in units {
        switch unit {
        case .Left(let b): result += b.allElements
        case .Right(let r): result += r.allElements
        }
      }

      let (inverted, notInverted) = units.flatMap({$0.unit.left.toArray()}).partitionBy({$0.invert})
      let invert = inverted.count > notInverted.count

      if (invert) {
        let upperBound = staffTop + layout.staffHeight
        let envelope = units.flatMap({ (pair) -> [CGPoint] in
          switch pair.unit {
          case .Left(let b):
            return zip(b.noteUnits, b.stems).map({ z -> CGPoint in
              let (noteUnit, stem) = z
              let frames = (noteUnit.noteHeads + [stem]).map({$0.frame})
              return CGPoint(x: frames.midX!, y: max(frames.maxY!, upperBound))
            })
          case .Right(let r): return [CGPoint(x: r.restView.frame.midX, y: upperBound)]
          }
        })

        let pointAtLowest = envelope.maxBy({$0.y})!
        result.append(createBracketElement(tuplet.notes, envelope: envelope, point: pointAtLowest, invert: invert))
      } else {
        let lowerBound = staffTop
        let envelope = units.flatMap({ (pair) -> [CGPoint] in
          switch pair.unit {
          case .Left(let b):
            return zip(b.noteUnits, b.stems).map({ z -> CGPoint in
              let (noteUnit, stem) = z
              let frames = (noteUnit.noteHeads + [stem]).map({$0.frame})
              return CGPoint(x: frames.midX!, y: min(frames.minY!, lowerBound))
            })
          case .Right(let r): return [CGPoint(x: r.restView.frame.midX, y: lowerBound)]
          }
        })

        let pointAtHighest = envelope.minBy({$0.y})!
        result.append(createBracketElement(tuplet.notes, envelope: envelope, point: pointAtHighest, invert: invert))
      }
    }

    return result
  }

  func createBeamUnit(elementsInBeam: [(xOffset: CGFloat, element: BeamMember)], groupedBy: Int = 4) -> [BeamUnit] {
    var result = [BeamUnit]()

    for pairs in elementsInBeam.grouped(groupedBy) {
      for group in pairs.spanBy({$0.element.length}) {
        if group.count == 1 {
          let (xOffset, element) = group.first!

          let noteUnit: NoteUnit?
          let noteLength: NoteLength!

          switch element {
          case let note as Note:
            noteUnit = createNoteUnit(xOffset, note: note, invert: shouldInvert(note))
            noteLength = note.length
          case let chord as Chord:
            noteUnit = createNoteUnit(xOffset, chord: chord, invert: shouldInvert(chord))
            noteLength = chord.length
          default:
            noteUnit = nil
            noteLength = nil
          }

          noteUnit.foreach({
            let stem = self.createStem($0)
            let flag = self.createFlag(noteLength, stemFrame: stem.frame, invert: $0.invert)
            result.append(BeamUnit(noteUnits: [$0], stems: [stem], flagOrBeams: .Left(left: flag), invert: $0.invert))
          })

        } else {
          let (offsetAtHighest, highestElement) = group.maxBy({$0.element.maxPitch.step})!
          let (offsetAtLowest, lowestElement) = group.minBy({$0.element.minPitch.step})!

          let highestFrame = createNoteHeadFrame(highestElement.maxPitch, xOffset: offsetAtHighest)
          let lowestFrame = createNoteHeadFrame(lowestElement.minPitch, xOffset: offsetAtLowest)

          let (first, last) = (group.first!, group.last!)
          let lowestFrameInFirst = createNoteHeadFrame(first.element.minPitch, xOffset: first.xOffset)
          let highestFrameInFirst = createNoteHeadFrame(first.element.maxPitch, xOffset: first.xOffset)
          let lowestFrameInLast = createNoteHeadFrame(last.element.minPitch, xOffset: last.xOffset)
          let highestFrameInLast = createNoteHeadFrame(last.element.maxPitch, xOffset: last.xOffset)

          let upperA = (highestFrameInLast.y - highestFrameInFirst.y) / (highestFrameInLast.x - highestFrameInFirst.x)
          let lowerA = (lowestFrameInLast.y - lowestFrameInFirst.y) / (lowestFrameInLast.x - lowestFrameInFirst.x)

          let upperSlope = upperA.abs < layout.maxBeamSlope ? upperA : layout.maxBeamSlope * upperA.sign
          let lowerSlope = lowerA.abs < layout.maxBeamSlope ? lowerA : layout.maxBeamSlope * lowerA.sign

          let upperF = linearFunction(upperSlope,
            point: Point2D(
              x: highestFrame.maxX,
              y: highestFrame.y - layout.minStemHeight))
          let lowerF = linearFunction(lowerSlope,
            point: Point2D(
              x: lowestElement.sortedPitches.sparse ? lowestFrame.x : lowestFrame.maxX,
              y: lowestFrame.maxY + layout.minStemHeight))

          let staffYCenter = staffTop + layout.staffInterval * 2
          let upperDiff = group.map({ abs(staffYCenter - upperF($0.xOffset + layout.noteHeadSize.width)) }).sum()
          let lowerDiff = group.map({ abs(staffYCenter - lowerF($0.element.sortedPitches.sparse ? $0.xOffset : $0.xOffset + layout.noteHeadSize.width)) }).sum()

          let beam = BeamElement()
          beam.lineWidth = layout.beamLineWidth

          if (upperDiff < lowerDiff) {
            let invert = false
            var noteUnits = [NoteUnit]()
            var stems = [RectElement]()
            var beams = [BeamElement]()

            for (xOffset, element) in group {
              let noteUnit: NoteUnit!
              switch element {
              case let note as Note: noteUnit = createNoteUnit(xOffset, note: note, invert: invert)
              case let chord as Chord: noteUnit = createNoteUnit(xOffset, chord: chord, invert: invert)
              default: noteUnit = nil
              }

              noteUnits.append(noteUnit)
              let noteHeadFrames = noteUnit.noteHeads.map({$0.frame})
              let bottomFrame = noteHeadFrames.maxBy({$0.y})!

              // add stem
              let stem = RectElement()
              let x = xOffset + layout.noteHeadSize.width - layout.stemWidth
              let y = upperF(x)
              stem.frame = CGRect(
                x: x,
                y: y,
                width: layout.stemWidth,
                height: bottomFrame.y - y + layout.noteHeadSize.height * 0.4
              )
              stems.append(stem)
            }

            // add beam
            let x1 = first.xOffset + layout.noteHeadSize.width - layout.stemWidth
            let y1 = upperF(x1)
            let x2 = last.xOffset + layout.noteHeadSize.width
            let y2 = upperF(x2)
            beam.rightDown = y1 < y2
            beam.frame = CGRectMake(x1, min(y1, y2), x2 - x1, max(abs(y1 - y2), layout.beamLineWidth))
            beams.append(beam)

            if first.element.length.actualLength(unitDenominator) <= Sixteenth {
              let beam2 = BeamElement(frame: beam.frame.withY(beam.frame.y + beam.lineWidth * 1.5))
              beam2.lineWidth = beam.lineWidth
              beam2.rightDown = beam.rightDown
              beams.append(beam2)
            }
            result.append(BeamUnit(noteUnits: noteUnits, stems: stems, flagOrBeams: .Right(right: beams), invert: invert))
          } else {
            let invert = true
            var noteUnits = [NoteUnit]()
            var stems = [RectElement]()
            var beams = [BeamElement]()

            for (xOffset, element) in group {
              let noteUnit: NoteUnit!
              switch element {
              case let note as Note: noteUnit = createNoteUnit(xOffset, note: note, invert: invert)
              case let chord as Chord: noteUnit = createNoteUnit(xOffset, chord: chord, invert: invert)
              default: noteUnit = nil
              }
              noteUnits.append(noteUnit)
              let noteHeadFrames = noteUnit.noteHeads.map({$0.frame})
              let topFrame = noteHeadFrames.minBy({$0.y})!

              // add stem
              let stem = RectElement()
              let x = noteUnit.singleColumn ? xOffset : xOffset + layout.noteHeadSize.width
              let bottomY = lowerF(x)
              let y = topFrame.y + layout.noteHeadSize.height * 0.6
              stem.frame = CGRect(
                x: x,
                y: y,
                width: layout.stemWidth,
                height: bottomY - y
              )
              stems.append(stem)
            }

            // add beam
            let x1 = first.xOffset + (first.element.sortedPitches.sparse ? 0 : layout.noteHeadSize.width)
            let y1 = lowerF(x1)
            let x2 = last.xOffset + (last.element.sortedPitches.sparse ? 0 : layout.noteHeadSize.width) + layout.stemWidth
            let y2 = lowerF(x2)

            beam.rightDown = y1 < y2
            beam.frame = CGRectMake(x1, min(y1, y2), x2 - x1, max(abs(y1 - y2), layout.beamLineWidth))
            beams.append(beam)

            if first.element.length.actualLength(unitDenominator) <= Sixteenth {
              let beam2 = BeamElement(frame: beam.frame.withY(beam.frame.y - beam.lineWidth * 1.5))
              beam2.lineWidth = beam.lineWidth
              beam2.rightDown = beam.rightDown
              beams.append(beam2)
            }
            result.append(BeamUnit(noteUnits: noteUnits, stems: stems, flagOrBeams: .Right(right: beams), invert: invert))
          }
        }
      }
    }

    return result
  }
}

protocol RenderUnit {
  var allElements: [ScoreElement] { get }
}

extension RenderUnit {
  func renderToView(view: UIView) {
    for e in self.allElements { view.addSubview(e) }
  }
}

class NoteUnit: RenderUnit {
  let dots: [EllipseElement]
  let noteHeads: [ScoreElement]
  let accidentals: [ScoreElement]
  let outsideStaff: [ScoreElement]
  let singleColumn: Bool
  let invert: Bool
  let xOffset: CGFloat

  let allElements: [ScoreElement]

  init(
    dots: [EllipseElement] = [],
    noteHeads: [ScoreElement] = [],
    accidentals: [ScoreElement] = [],
    outsideStaff: [ScoreElement] = [],
    singleColumn: Bool = true,
    invert: Bool,
    xOffset: CGFloat) {
      self.dots = dots
      self.noteHeads = noteHeads
      self.accidentals = accidentals
      self.outsideStaff = outsideStaff
      self.singleColumn = singleColumn
      self.invert = invert
      self.xOffset = xOffset

      self.allElements = noteHeads + accidentals + outsideStaff + dots
  }
}

class RestUnit: RenderUnit {
  let dots: [EllipseElement]
  let restView: ScoreElement
  let xOffset: CGFloat

  let allElements: [ScoreElement]

  init(
    dots: [EllipseElement] = [],
    restView: ScoreElement,
    xOffset: CGFloat) {
      self.dots = dots
      self.restView = restView
      self.xOffset = xOffset

      self.allElements = [restView] + dots
  }
}

class BeamUnit: RenderUnit {
  let noteUnits: [NoteUnit]
  let stems: [RectElement]
  let flagOrBeams: Either<ScoreElement, [BeamElement]>
  let invert: Bool

  let allElements: [ScoreElement]

  init(
    noteUnits: [NoteUnit],
    stems: [RectElement],
    flagOrBeams: Either<ScoreElement, [BeamElement]>,
    invert: Bool
    ) {
      self.noteUnits = noteUnits
      self.stems = stems
      self.flagOrBeams = flagOrBeams
      self.invert = invert

      var elements = [ScoreElement]()
      elements += self.noteUnits.flatMap({$0.allElements})
      for stem in stems { elements.append(stem) }
      switch flagOrBeams {
      case .Left(let flag): elements.append(flag)
      case .Right(let beams): for beam in beams { elements.append(beam) }
      }

      self.allElements = elements
  }
}
