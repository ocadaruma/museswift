import Foundation

@IBDesignable public class SingleLineScore: UIView {
  public var layout: SingleLineScoreLayout = SingleLineScoreLayout.defaultLayout {
    didSet {
      setNeedsDisplay()
    }
  }

  private var staffTop: CGFloat {
    return (bounds.size.height - layout.staffHeight) / 2
  }

  private var staffInterval: CGFloat {
    return layout.staffHeight / CGFloat(staffNum - 1)
  }

  /// score elemeents will be added to this view.
  private var _canvas: UIView! = nil
  public var canvas: UIView { return _canvas }

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

        xOffset += renderer.rendereredWidthForNoteLength(note.length)

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

        xOffset += renderer.rendereredWidthForNoteLength(chord.length)

      case let tuplet as Tuplet:
        let ratio = CGFloat(tuplet.ratio)
        for v in renderer.createElementsForTuplet(tuplet, xOffset: xOffset) { canvas.addSubview(v) }
        xOffset += tuplet.elements.map({renderer.rendereredWidthForNoteLength($0.length) * ratio}).sum()

      case let rest as Rest:
        renderer.createRestUnit(xOffset, rest: rest).renderToView(canvas)
        xOffset += renderer.rendereredWidthForNoteLength(rest.length)

      case let rest as MultiMeasureRest:
        xOffset += renderer.rendereredWidthForNoteLength(NoteLength(numerator: rest.num, denominator: 1))

      default: break
      }

      if !currentPositionIsInBeam {
        for e in renderer.createBeamUnit(elementsInBeam).flatMap({$0.allElements}) { canvas.addSubview(e) }
        elementsInBeam = []
      }
    }

    if elementsInBeam.nonEmpty {
      for e in renderer.createBeamUnit(elementsInBeam).flatMap({$0.allElements}) { canvas.addSubview(e) }
    }
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


