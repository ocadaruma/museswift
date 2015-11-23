import Foundation

@IBDesignable public class SingleLineScore: UIView {
  public var layout: ScoreLayout = ScoreLayout.defaultLayout {
    didSet {
      setNeedsDisplay()
    }
  }

  private var staffTop: CGFloat {
    get {
      return (bounds.size.height - layout.staffHeight) / 2
    }
  }

  private var staffInterval: CGFloat {
    get {
      return layout.staffHeight / CGFloat(staffNum - 1)
    }
  }

  /// score elemeents will be added to this view.
  private var _canvas: UIView! = nil
  public var canvas: UIView { get {return _canvas} }

  public func loadVoice(tuneHeader: TuneHeader, voiceHeader: VoiceHeader, voice: Voice) -> Void {
    if let c = _canvas { c.removeFromSuperview() }
    _canvas = UIView(frame: bounds)
    addSubview(canvas)

    let renderer = SingleLineScoreRenderer(
      unitDenominator: tuneHeader.unitNoteLength.denominator, layout: layout, bounds: bounds)

    var elementsInBeam: [(xOffset: CGFloat, element: BeamMember)] = []
    var xOffset: CGFloat = 0
    var currentPositionIsInBeam: Bool

    for element in voice.elements {
      currentPositionIsInBeam = false

      switch element {
      case let simple as Simple:
        switch simple {
        case .BarLine:
          canvas.addSubview(
            Block(frame:
              CGRect(
                x: xOffset - layout.barMarginRight,
                y: staffTop,
                width: layout.stemWidth,
                height: layout.staffHeight)))
        case .DoubleBarLine:
          canvas.addSubview(
            DoubleBar(frame:
              CGRect(
                x: xOffset - layout.barMarginRight,
                y: staffTop,
                width: layout.stemWidth * 3,
                height: layout.staffHeight)))
        case .Space: break
        case .LineBreak: break
        case .RepeatEnd: break //TODO
        case .RepeatStart: break //TODO
        case .Tie: break //TODO
        case .SlurEnd: break //TODO
        case .SlurStart: break //TODO
        case .End: break
        }
      case let note as Note:
        let length = note.length.actualLength(renderer.unitDenominator)
        let invert = renderer.shouldInvert(note)
        let noteUnit = renderer.createNoteUnit(xOffset, note: note, invert: invert)

        if length >= Whole {
          noteUnit.renderToView(canvas)
        } else if length >= Quarter {
          noteUnit.renderToView(canvas)
          let stem = renderer.createStem(noteUnit)
          canvas.addSubview(stem)
        } else {
          currentPositionIsInBeam = true
          elementsInBeam.append((xOffset: xOffset, element: note))
        }

        xOffset += renderer.noteLengthToWidth(note.length)
      case let chord as Chord:
        let length = chord.length.actualLength(renderer.unitDenominator)
        let invert = renderer.shouldInvert(chord)
        let noteUnit = renderer.createNoteUnit(xOffset, chord: chord, invert: invert)

        if length >= Whole {
          noteUnit.renderToView(canvas)
        } else if length >= Quarter {
          noteUnit.renderToView(canvas)
          let stem = renderer.createStem(noteUnit)
          canvas.addSubview(stem)
        } else {
          currentPositionIsInBeam = true
          elementsInBeam.append((xOffset: xOffset, element: chord))
        }

        xOffset += renderer.noteLengthToWidth(chord.length)
      case let tuplet as Tuplet:
        var notes = [(rect: CGRect, note: Note)]()
        let ratio = CGFloat(tuplet.time) / CGFloat(tuplet.notes)
        var offset: CGFloat = xOffset
        for element in tuplet.elements {
          switch element {
          case let note as Note:
//            let noteHeadFrame = noteHeadFrameFor(note.pitch, xOffset: offset)
//            notes.append((noteHeadFrame, note: note))
//            canvas.addSubview(BlackNote(frame: noteHeadFrame))
            offset += renderer.noteLengthToWidth(note.length) * ratio
          case let chord as Chord:
            offset += renderer.noteLengthToWidth(chord.length) * ratio
          case let rest as Rest:
            offset += renderer.noteLengthToWidth(rest.length) * ratio
          default: break
          }
        }
//        renderElementsInBeam(notes, unitDenominator: tuneHeader.unitNoteLength.denominator, groupedBy: tuplet.notes)

        xOffset = offset
      case let rest as Rest:
        renderer.createRestUnit(xOffset, rest: rest).renderToView(canvas)
        xOffset += renderer.noteLengthToWidth(rest.length)
      case let rest as MultiMeasureRest:
        xOffset += renderer.noteLengthToWidth(NoteLength(numerator: rest.num, denominator: 1))
      default: break
      }

      if !currentPositionIsInBeam {
        for e in renderer.createViewsFromBeamElements(elementsInBeam) { canvas.addSubview(e) }
        elementsInBeam = []
      }
    }

    if elementsInBeam.nonEmpty { for e in renderer.createViewsFromBeamElements(elementsInBeam) { canvas.addSubview(e) } }
  }

  private func drawStaff() {
    let width = bounds.size.width
    let top = staffTop
    let ctx = UIGraphicsGetCurrentContext()

    CGContextSetLineWidth(ctx, layout.staffLineWidth)
    CGContextSetStrokeColorWithColor(ctx, UIColor.lightGrayColor().CGColor)
    for i in 0..<staffNum {
      let offset = staffInterval * CGFloat(i)

      CGContextMoveToPoint(ctx, 0, top + offset)
      CGContextAddLineToPoint(ctx, width, top + offset)
      CGContextStrokePath(ctx)
    }
  }

  public override func drawRect(rect: CGRect) {
    drawStaff()
  }
}


