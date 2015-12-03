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

  private func createDots(pitch: Pitch, x: CGFloat, length: Float, denominator: Denominator) -> [EllipseElement] {
    var result = [EllipseElement]()
    let length1 = length - denominator.value
    let denom1 = denominator.value / 2
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

  private func createDotsForRest(x: CGFloat, length: Float, denominator: Denominator) -> [EllipseElement] {
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

    let x = frame.x - (layout.fillingStaffLineXLength - frame.width) / 2
    if step >= upperBound {
      for i in 1...(1 + (step - upperBound).abs / 2) {
        let y = staffTop - (CGFloat(i) * layout.staffInterval)
        staff.append(RectElement(frame: CGRect(x: x, y: y, width: layout.fillingStaffLineXLength, height: layout.fillingStaffLineWidth)))
      }
    } else if step <= lowerBound {
      for i in 1...(1 + (step - lowerBound).abs / 2) {
        let y = staffTop + layout.staffHeight - layout.staffLineWidth + (CGFloat(i) * layout.staffInterval)
        staff.append(RectElement(frame: CGRect(x: x, y: y, width: layout.fillingStaffLineXLength, height: layout.fillingStaffLineWidth)))
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

    return calcDenominator(noteLength.absoluteLength(unitDenominator)).flagConstructorWithFrame(flagFrame, invert)
  }

  private func createUnitsInTuplet(xOffset: CGFloat, tuplet: Tuplet) -> [(offset: CGFloat, unit: Either<NoteUnit, RestUnit>)] {
    let ratio = CGFloat(tuplet.time) / CGFloat(tuplet.notes)

    var offset = xOffset
    var units = [(offset: CGFloat, unit: Either<NoteUnit, RestUnit>)]()
    for e in tuplet.elements {
      switch e {
      case let note as Note:
        let noteUnit = createNoteUnit(offset, note: note)
        units.append(
          (offset: offset, unit: .Left(left: noteUnit))
        )
        offset += rendereredWidthForNoteLength(note.length) * ratio
      case let chord as Chord:
        let noteUnit = createNoteUnit(offset, chord: chord)
        units.append(
          (offset: offset, unit: .Left(left: noteUnit))
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

  private func createStem(noteHeads: [ScoreElement], invert: Bool, sparse: Bool) -> RectElement {
    let noteHeadFrames = noteHeads.map({$0.frame})
    let bottomFrame = noteHeadFrames.maxBy({$0.y})!
    let topFrame = noteHeadFrames.minBy({$0.y})!
    let upperBound = staffTop - layout.staffInterval
    let lowerBound = staffTop + layout.staffHeight + layout.staffInterval

    let stem = RectElement()
    let stemHeight = layout.staffInterval * 3
    let x = sparse && invert ? topFrame.x : noteHeadFrames.map({$0.maxX}).minElement()!

    if invert {
      let stemBottom = max(upperBound + stemHeight, bottomFrame.maxY + stemHeight)
      let y = topFrame.y + topFrame.height * 0.6
      stem.frame = CGRect(
        x: x,
        y: y,
        width: layout.stemWidth,
        height: stemBottom - y)
    } else {
      let y = min(lowerBound - stemHeight, topFrame.y - stemHeight)
      stem.frame = CGRect(
        x: x - layout.stemWidth,
        y: y,
        width: layout.stemWidth,
        height: topFrame.y - y + bottomFrame.height * 0.4)
    }

    return stem
  }

  private func shouldInvert(chord: Chord) -> Bool {
    return chord.pitches.map({$0.step}).sum() / chord.pitches.count >= BOn3rdStave.step
  }

  private func shouldInvert(note: Note) -> Bool {
    return note.pitch.step >= BOn3rdStave.step
  }

  private func createNoteUnit(
    xOffset: CGFloat,
    note: Note,
    forceInvert: Bool?,
    autoStem: Bool,
    forceStem: RectElement?,
    forceFlag: ScoreElement?) -> NoteUnit
  {
    return createNoteUnit(
      xOffset,
      chord: Chord(length: note.length, pitches: [note.pitch]),
      forceInvert: forceInvert,
      autoStem: autoStem,
      forceStem: forceStem,
      forceFlag: forceFlag)
  }

  private func createNoteUnit(
    xOffset: CGFloat,
    chord: Chord,
    forceInvert: Bool?,
    autoStem: Bool,
    forceStem: RectElement?,
    forceFlag: ScoreElement?) -> NoteUnit
  {
    let invert = forceInvert ?? shouldInvert(chord)
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
    var fillingStaff = [RectElement]()

    let length = chord.length.absoluteLength(unitDenominator)
    let denom = calcDenominator(length)
    var stem: RectElement? = nil
    var flag: ScoreElement? = nil

    for (pitch, frame, column) in noteHeadFrames {
      let noteHead: ScoreElement
      let shouldAddDots = denom != .Whole && (sparce || column == .Right)
      var d = [EllipseElement]()

      noteHead = denom.constructor()
      switch denom {
      case .Whole, .Half: ()
      default:
        if shouldAddDots { d += createDots(pitch, x: frame.maxX, length: length, denominator: denom) }
      }

      fillingStaff += createFillingStaff(frame.minX, pitch: pitch)
      createAccidental(pitch, xOffset: xOffset).foreach({accidentals.append($0)})

      noteHead.frame = frame
      noteHeads.append(noteHead)
      dots += d
    }

    if autoStem {
      if denom.hasStem {
        let s = createStem(noteHeads, invert: invert, sparse: sparce)
        stem = s
        if denom.hasFlag {
          flag = createFlag(chord.length, stemFrame: s.frame, invert: invert)
        }
      }
    } else {
      stem = forceStem
      flag = forceFlag
    }

    return NoteUnit(
      dots: dots,
      noteHeads: noteHeads,
      accidentals: accidentals,
      fillingStaff: fillingStaff,
      stem: stem,
      flag: flag,
      sparse: sparce,
      invert: invert,
      xOffset: xOffset)
  }

  func rendereredWidthForNoteLength(noteLength: NoteLength) -> CGFloat {
    return layout.widthPerUnitNoteLength * CGFloat(noteLength.numerator) / CGFloat(noteLength.denominator)
  }

  func createRestUnit(xOffset: CGFloat, rest: Rest) -> RestUnit {
    let length = rest.length.absoluteLength(unitDenominator)

    var restView: ScoreElement! = nil
    var dots = [EllipseElement]()

    switch calcDenominator(length) {
    case .Whole:
      restView = RectElement()
      let width = layout.staffInterval * 1.5
      restView.frame = CGRect(
        x: xOffset + rendereredWidthForNoteLength(rest.length) / 2 - (width / 2),
        y: staffTop + layout.staffInterval,
        width: width,
        height: layout.staffInterval * 0.6)
    case .Half:
      restView = RectElement()
      let width = layout.staffInterval * 1.5
      let height = layout.staffInterval * 0.6
      restView.frame = CGRect(
        x: xOffset + rendereredWidthForNoteLength(rest.length) / 2 - (width / 2),
        y: staffTop + layout.staffInterval * 2 - height,
        width: width,
        height: height)
      dots += createDotsForRest(restView.frame.maxX, length: length, denominator: .Half)
    case .Quarter:
      restView = QuarterRestElement()
      restView.frame = CGRect(
        x: xOffset,
        y: staffTop + layout.staffInterval / 2,
        width: layout.staffInterval * 1.1,
        height: layout.staffInterval * 2.5)
      dots += createDotsForRest(restView.frame.maxX, length: length, denominator: .Quarter)
    case .Eighth:
      restView = EighthRestElement()
      restView.frame = CGRect(
        x: xOffset,
        y: staffTop + layout.staffInterval + layout.staffLineWidth,
        width: layout.staffInterval * 1.3,
        height: layout.staffInterval * 2)
      dots += createDotsForRest(restView.frame.maxX, length: length, denominator: .Eighth)
    case .Sixteenth:
      restView = SixteenthRestElement()
      restView.frame = CGRect(
        x: xOffset,
        y: staffTop + layout.staffInterval + layout.staffLineWidth,
        width: layout.staffInterval * 1.3,
        height: layout.staffInterval * 3)
      dots += createDotsForRest(restView.frame.maxX, length: length, denominator: .Sixteenth)
    default: ()
    }

    return RestUnit(dots: dots, restView: restView, xOffset: xOffset)
  }

  func createNoteUnit(xOffset: CGFloat, note: Note) -> NoteUnit {
    return createNoteUnit(
      xOffset,
      chord: Chord(length: note.length, pitches: [note.pitch]),
      forceInvert: nil,
      autoStem: true,
      forceStem: nil,
      forceFlag: nil)
  }

  func createNoteUnit(xOffset: CGFloat, chord: Chord) -> NoteUnit {
    return createNoteUnit(
      xOffset,
      chord: chord,
      forceInvert: nil,
      autoStem: true,
      forceStem: nil,
      forceFlag: nil)
  }

  func createTupletUnit(tuplet: Tuplet, xOffset: CGFloat) -> TupletUnit {
    // assume that all elements in tuplet are same length
    let length = tuplet.elements.first!.length.absoluteLength(unitDenominator)
    let denom = calcDenominator(length)
    var renderUnits = [RenderUnit]()
    var bracket: BracketElement! = nil
    var invert: Bool = false

    if denom == .Whole {
      // unsupported
    } else if denom == .Half || denom == .Quarter {
      let units = createUnitsInTuplet(xOffset, tuplet: tuplet)
      for u in units {
        switch u.unit {
        case .Left(let n): renderUnits.append(n)
        case .Right(let r): renderUnits.append(r)
        }
      }

      let (inverted, notInverted) = units.flatMap({$0.unit.left.toArray()}).partitionBy({$0.invert})
      invert = inverted.count > notInverted.count

      if (invert) {
        let upperBound = staffTop + layout.staffHeight
        let envelope = units.map({ pair -> CGPoint in
          switch pair.unit {
          case .Left(let n):
            let frames = n.noteHeads.map({$0.frame}) + n.stem.toArray().map({$0.frame})
            return CGPoint(
              x: n.stem!.frame.x,
              y: max(frames.maxY!, upperBound))
          case .Right(let r): return CGPoint(x: r.restView.frame.midX, y: upperBound)
          }
        })

        let pointAtLowest = envelope.maxBy({$0.y})!
        bracket = createBracketElement(tuplet.notes, envelope: envelope, point: pointAtLowest, invert: invert)
      } else {
        let lowerBound = staffTop
        let envelope = units.map({ pair -> CGPoint in
          switch pair.unit {
          case .Left(let n):
            let frames = n.noteHeads.map({$0.frame}) + n.stem.toArray().map({$0.frame})
            return CGPoint(
              x: n.stem!.frame.x,
              y: min(frames.minY!, lowerBound))
          case .Right(let r): return CGPoint(x: r.restView.frame.midX, y: lowerBound)
          }
        })

        let pointAtHighest = envelope.minBy({$0.y})!
        bracket = createBracketElement(tuplet.notes, envelope: envelope, point: pointAtHighest, invert: invert)
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
        case .Left(let b): renderUnits.append(b)
        case .Right(let r): renderUnits.append(r)
        }
      }

      let (inverted, notInverted) = units.flatMap({$0.unit.left.toArray()}).partitionBy({$0.invert})
      invert = inverted.count > notInverted.count

      if (invert) {
        let upperBound = staffTop + layout.staffHeight
        let envelope = units.flatMap({ (pair) -> [CGPoint] in
          switch pair.unit {
          case .Left(let b):
            return b.noteUnits.map({
              let frames = ($0.noteHeads.map({$0.frame}) + $0.stem.toArray().map({$0.frame}))
              return CGPoint(x: $0.stem!.frame.x, y: max(frames.maxY!, upperBound))
            })
          case .Right(let r): return [CGPoint(x: r.restView.frame.midX, y: upperBound)]
          }
        })

        let pointAtLowest = envelope.maxBy({$0.y})!
        bracket = createBracketElement(tuplet.notes, envelope: envelope, point: pointAtLowest, invert: invert)
      } else {
        let lowerBound = staffTop
        let envelope = units.flatMap({ (pair) -> [CGPoint] in
          switch pair.unit {
          case .Left(let b):
            return b.noteUnits.map({
              let frames = ($0.noteHeads.map({$0.frame}) + $0.stem.toArray().map({$0.frame}))
              return CGPoint(x: $0.stem!.frame.x, y: min(frames.minY!, lowerBound))
            })
          case .Right(let r): return [CGPoint(x: r.restView.frame.midX, y: lowerBound)]
          }
        })

        let pointAtHighest = envelope.minBy({$0.y})!
        bracket = createBracketElement(tuplet.notes, envelope: envelope, point: pointAtHighest, invert: invert)
      }
    }

    return TupletUnit(
      units: renderUnits,
      bracket: bracket,
      invert: invert
    )
  }

  func createBeamUnit(elementsInBeam: [(xOffset: CGFloat, element: BeamMember)], groupedBy: Int = 4) -> [BeamUnit] {
    var result = [BeamUnit]()

    for pairs in elementsInBeam.grouped(groupedBy) {
      for group in pairs.spanBy({$0.element.length}) {
        if group.count == 1 {
          let (xOffset, element) = group.first!

          let noteUnit: NoteUnit?

          switch element {
          case let note as Note:
            noteUnit = createNoteUnit(xOffset, note: note)
          case let chord as Chord:
            noteUnit = createNoteUnit(xOffset, chord: chord)
          default:
            noteUnit = nil
          }

          noteUnit.foreach({
            result.append(BeamUnit(noteUnits: [$0], beams: [], invert: $0.invert))
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
              y: min(highestFrame.y - layout.minStemHeight, staffTop + layout.staffHeight - layout.minStemHeight)))
          let lowerF = linearFunction(lowerSlope,
            point: Point2D(
              x: lowestElement.sortedPitches.sparse ? lowestFrame.x : lowestFrame.maxX,
              y: max(lowestFrame.maxY + layout.minStemHeight, staffTop - layout.staffInterval + layout.minStemHeight)))

          let staffYCenter = staffTop + layout.staffInterval * 2
          let upperDiff = group.map({ abs(staffYCenter - upperF($0.xOffset + layout.noteHeadSize.width)) }).sum()
          let lowerDiff = group.map({ abs(staffYCenter - lowerF($0.element.sortedPitches.sparse ? $0.xOffset : $0.xOffset + layout.noteHeadSize.width)) }).sum()

          let beam = BeamElement()
          beam.lineWidth = layout.beamLineWidth

          if (upperDiff < lowerDiff) {
            let invert = false
            var noteUnits = [NoteUnit]()
            var beams = [BeamElement]()

            for (xOffset, element) in group {
              let x = xOffset + layout.noteHeadSize.width - layout.stemWidth
              let y = upperF(x)

              switch element {
              case let note as Note:
                let stem = RectElement(frame:
                  CGRect(x: x, y: y, width: layout.stemWidth, height: noteHeadTop(note.pitch) - y + layout.noteHeadSize.height * 0.4))
                noteUnits.append(createNoteUnit(xOffset, note: note, forceInvert: invert, autoStem: false, forceStem: stem, forceFlag: nil))
              case let chord as Chord:
                let stem = RectElement(frame:
                  CGRect(x: x, y: y, width: layout.stemWidth, height: noteHeadTop(chord.minPitch) - y + layout.noteHeadSize.height * 0.4))
                noteUnits.append(createNoteUnit(xOffset, chord: chord, forceInvert: invert, autoStem: false, forceStem: stem, forceFlag: nil))
              default: ()
              }
            }

            // add beam
            let x1 = first.xOffset + layout.noteHeadSize.width - layout.stemWidth
            let y1 = upperF(x1)
            let x2 = last.xOffset + layout.noteHeadSize.width
            let y2 = upperF(x2)
            beam.rightDown = y1 < y2
            beam.frame = CGRectMake(x1, min(y1, y2), x2 - x1, max(abs(y1 - y2), layout.beamLineWidth))
            beams.append(beam)

            if calcDenominator(first.element.length.absoluteLength(unitDenominator)) == .Sixteenth {
              let beam2 = BeamElement(frame: beam.frame.withY(beam.frame.y + beam.lineWidth * 1.5))
              beam2.lineWidth = beam.lineWidth
              beam2.rightDown = beam.rightDown
              beams.append(beam2)
            }
            result.append(BeamUnit(noteUnits: noteUnits, beams: beams, invert: invert))
          } else {
            let invert = true
            var noteUnits = [NoteUnit]()
            var beams = [BeamElement]()

            for (xOffset, element) in group {
              let x = ((element as? Chord)?.pitches.sparse ?? true) ? xOffset : xOffset + layout.noteHeadSize.width
              let bottomY = lowerF(x)

              switch element {
              case let note as Note:
                let top = noteHeadTop(note.pitch)
                let y = top + layout.noteHeadSize.height * 0.6
                let stem = RectElement(frame:
                  CGRect(x: x, y: y, width: layout.stemWidth, height: bottomY - y))
                noteUnits.append(createNoteUnit(xOffset, note: note, forceInvert: invert, autoStem: false, forceStem: stem, forceFlag: nil))
              case let chord as Chord:
                let top = noteHeadTop(chord.maxPitch)
                let y = top + layout.noteHeadSize.height * 0.6
                let stem = RectElement(frame:
                  CGRect(x: x, y: y, width: layout.stemWidth, height: bottomY - y))
                noteUnits.append(createNoteUnit(xOffset, chord: chord, forceInvert: invert, autoStem: false, forceStem: stem, forceFlag: nil))
              default: ()
              }
            }

            // add beam
            let x1 = first.xOffset + (first.element.sortedPitches.sparse ? 0 : layout.noteHeadSize.width)
            let y1 = lowerF(x1)
            let x2 = last.xOffset + (last.element.sortedPitches.sparse ? 0 : layout.noteHeadSize.width) + layout.stemWidth
            let y2 = lowerF(x2)

            beam.rightDown = y1 < y2
            beam.frame = CGRectMake(x1, min(y1, y2), x2 - x1, max(abs(y1 - y2), layout.beamLineWidth))
            beams.append(beam)

            if calcDenominator(first.element.length.absoluteLength(unitDenominator)) == .Sixteenth {
              let beam2 = BeamElement(frame: beam.frame.withY(beam.frame.y - beam.lineWidth * 1.5))
              beam2.lineWidth = beam.lineWidth
              beam2.rightDown = beam.rightDown
              beams.append(beam2)
            }
            result.append(BeamUnit(noteUnits: noteUnits, beams: beams, invert: invert))
          }
        }
      }
    }

    return result
  }
}
