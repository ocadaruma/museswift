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

  public func loadVoice(tuneHeader: TuneHeader, voiceHeader: VoiceHeader, voice: Voice, initialOffset: CGFloat = 0) -> Void {
    if let c = _canvas { c.removeFromSuperview() }
    _canvas = UIView(frame: bounds)
    addSubview(canvas)

    let renderer = SingleLineScoreRenderer(
      unitDenominator: tuneHeader.unitNoteLength.denominator, layout: layout, bounds: bounds)

    var noteUnitMap = [CGFloat:NoteUnit]()
    var tieLocations = [CGFloat]()

    var elementsInBeam: [(xOffset: CGFloat, element: BeamMember)] = []
    var xOffset: CGFloat = initialOffset
    var beamContinue = false

    // render clef
    let clef = renderer.createClef(xOffset, clef: voiceHeader.clef)
    canvas.addSubview(clef)
    xOffset += clef.frame.width

    // render key signature
    let keySignature = renderer.createKeySignature(xOffset, key: tuneHeader.key)
    if keySignature.nonEmpty {
      for k in keySignature { canvas.addSubview(k) }
      xOffset = keySignature.map({$0.frame.maxX}).maxElement()!
    }

    // render meter
    let meter = renderer.createMeter(xOffset, meter: tuneHeader.meter)
    canvas.addSubview(meter)
    xOffset += meter.frame.width

    print("start offset : \(xOffset)")

    // render voice
    for element in voice.elements {
      beamContinue = false

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
        case .Tie:
          tieLocations.append(xOffset)

        case .SlurEnd: break //TODO
        case .SlurStart: break //TODO
        case .End: break
        }

      case let note as Note:
        switch calcDenominator(note.length.absoluteLength(renderer.unitDenominator)) {
        case .Whole, .Half, .Quarter:
          let unit = renderer.createNoteUnit(xOffset, note: note)
          unit.renderToView(canvas)
//          let x1 = unit.allElements.map{$0.frame}.minX!
//          let y1 = unit.allElements.map{$0.frame}.minY!
//          let x2 = unit.allElements.map{$0.frame}.maxX!
//          let y2 = unit.allElements.map{$0.frame}.maxY!
//          let rect = CGRect(x: x1, y: y1, width: x2 - x1, height: y2 - y1)
//          let v = UIView(frame: rect)
//          for e in unit.allElements {
//            e.frame = v.convertRect(e.frame, fromView: canvas)
//            v.addSubview(e)
//          }

          noteUnitMap[unit.xOffset] = unit
        default:
          elementsInBeam.append((xOffset: xOffset, element: note))
          beamContinue = true
        }

        xOffset += renderer.rendereredWidthForNoteLength(note.length)

      case let chord as Chord:
        switch calcDenominator(chord.length.absoluteLength(renderer.unitDenominator)) {
        case .Whole, .Half, .Quarter:
          let unit = renderer.createNoteUnit(xOffset, chord: chord)
          unit.renderToView(canvas)
          noteUnitMap[unit.xOffset] = unit
        default:
          elementsInBeam.append((xOffset: xOffset, element: chord))
          beamContinue = true
        }

        xOffset += renderer.rendereredWidthForNoteLength(chord.length)

      case let tuplet as Tuplet:
        let tupletUnit = renderer.createTupletUnit(tuplet, xOffset: xOffset)
        tupletUnit.renderToView(canvas)
        for unit in tupletUnit.toNoteUnits() { noteUnitMap[unit.xOffset] = unit }
        xOffset += tuplet.elements.map({renderer.rendereredWidthForNoteLength($0.length) * CGFloat(tuplet.ratio)}).sum()

      case let rest as Rest:
        renderer.createRestUnit(xOffset, rest: rest).renderToView(canvas)
        xOffset += renderer.rendereredWidthForNoteLength(rest.length)

      case let rest as MultiMeasureRest:
        xOffset += renderer.rendereredWidthForNoteLength(NoteLength(numerator: rest.num, denominator: 1))

      default: break
      }

      if !beamContinue && elementsInBeam.nonEmpty {
        for beam in renderer.createBeamUnit(elementsInBeam) {
          beam.renderToView(canvas)
          for unit in beam.toNoteUnits() { noteUnitMap[unit.xOffset] = unit }
        }
        elementsInBeam = []
      }
    }

    if elementsInBeam.nonEmpty {
      for beam in renderer.createBeamUnit(elementsInBeam) {
        beam.renderToView(canvas)
        for unit in beam.toNoteUnits() { noteUnitMap[unit.xOffset] = unit }
      }
    }

    let noteUnitLocations = noteUnitMap.keys.sort()
    for x in tieLocations {
      if let i = noteUnitLocations.indexOf(x) {
        let start = noteUnitLocations.get(i - 1).flatMap({noteUnitMap[$0]})
        let end = noteUnitMap[x]

        renderer.createTie(start, end: end).foreach({self.canvas.addSubview($0)})
      }
    }

//    let maxX = canvas.subviews.maxBy{$0.frame.x}!.frame.x
//    canvas.frame = canvas.frame.withWidth(maxX)
////    canvas.layer.sublayerTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeScale(3, 3))
//    let man = NSFileManager.defaultManager()
//    let image = canvas.toImage()
//    man.createFileAtPath("/Users/hokada/Desktop/images/sheet.png", contents: UIImagePNGRepresentation(image), attributes: nil)


//    var array = [[String:AnyObject]]()
//    let man = NSFileManager.defaultManager()
//    for (i, v) in canvas.subviews.enumerate() {
//      let image = v.toImage()
//      let filepath = "/Users/hokada/Desktop/images/\(i).png"
//      man.createFileAtPath(filepath, contents: UIImagePNGRepresentation(image), attributes: nil)
//      array.append([
//        "name" : String(i),
//        "x" : v.frame.x,
//        "y" : v.frame.y,
//        "width" : v.frame.width,
//        "height" : v.frame.height])
//    }
//
//    let data = try! NSJSONSerialization.dataWithJSONObject(array, options: NSJSONWritingOptions(rawValue: 0))
//    man.createFileAtPath("/Users/hokada/Desktop/images/song.json", contents: data, attributes: nil)

    print(canvas.frame)
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


