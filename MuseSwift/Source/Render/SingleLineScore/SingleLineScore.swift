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

    let noteUnitBuffer = SortedArray<NoteUnit, CGFloat>(keySelector: {$0.xOffset})
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
            RectElement(frame:
              CGRect(
                x: xOffset - layout.barMarginRight,
                y: staffTop,
                width: layout.stemWidth,
                height: layout.staffHeight)))
        case .DoubleBarLine:
          canvas.addSubview(
            DoubleBarElement(frame:
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
        switch calcDenominator(note.length.absoluteLength(renderer.unitDenominator)) {
        case .Whole, .Half, .Quarter:
          tap(renderer.createNoteUnit(xOffset, note: note))(f: {
            $0.renderToView(self.canvas)
            noteUnitBuffer.insert($0)
          })
        default:
          elementsInBeam.append((xOffset: xOffset, element: note))
          currentPositionIsInBeam = true
        }

        xOffset += renderer.rendereredWidthForNoteLength(note.length)

      case let chord as Chord:
        switch calcDenominator(chord.length.absoluteLength(renderer.unitDenominator)) {
        case .Whole, .Half, .Quarter:
          tap(renderer.createNoteUnit(xOffset, chord: chord))(f: {
            $0.renderToView(self.canvas)
            noteUnitBuffer.insert($0)
          })
        default:
          elementsInBeam.append((xOffset: xOffset, element: chord))
          currentPositionIsInBeam = true
        }

        xOffset += renderer.rendereredWidthForNoteLength(chord.length)

      case let tuplet as Tuplet:
        renderer.createTupletUnit(tuplet, xOffset: xOffset).renderToView(canvas)
        xOffset += tuplet.elements.map({renderer.rendereredWidthForNoteLength($0.length) * CGFloat(tuplet.ratio)}).sum()

      case let rest as Rest:
        renderer.createRestUnit(xOffset, rest: rest).renderToView(canvas)
        xOffset += renderer.rendereredWidthForNoteLength(rest.length)

      case let rest as MultiMeasureRest:
        xOffset += renderer.rendereredWidthForNoteLength(NoteLength(numerator: rest.num, denominator: 1))

      default: break
      }

      if !currentPositionIsInBeam && elementsInBeam.nonEmpty {
        for beam in renderer.createBeamUnit(elementsInBeam) { beam.renderToView(canvas) }

        let unit = renderer.createBeamUnit(elementsInBeam).first!

        let slur = SlurElement()
        let firstNoteHead = unit.noteUnits.first!.noteHeads.maxBy({$0.frame.y})!
        let lastNoteHead = unit.noteUnits.last!.noteHeads.maxBy({$0.frame.y})!

        slur.frame = CGRect(x: firstNoteHead.frame.x, y: canvas.frame.y, width: lastNoteHead.frame.x - firstNoteHead.frame.x, height: canvas.frame.height)
        slur.start = firstNoteHead.frame.origin
        slur.end = lastNoteHead.frame.origin
        canvas.addSubview(slur)

        elementsInBeam = []
      }
    }

    if elementsInBeam.nonEmpty {
      for beam in renderer.createBeamUnit(elementsInBeam) { beam.renderToView(canvas) }
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


