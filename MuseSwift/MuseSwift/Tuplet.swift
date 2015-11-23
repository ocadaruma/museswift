import Foundation

@IBDesignable public class TupletBeam: ScoreElement {
  @IBInspectable var notes: Int = 3
  @IBInspectable var lineWidth: CGFloat = 1
  @IBInspectable var beamHeight: CGFloat = 5
  @IBInspectable var fontSize: CGFloat = 16
  @IBInspectable var rightDown: Bool = false
  @IBInspectable var invert: Bool = false

  public override func drawRect(rect: CGRect) {
    let (w, h) = size
    let ctx = UIGraphicsGetCurrentContext()

    tintColor.setStroke()
    CGContextSetLineWidth(ctx, lineWidth)

    if invert {
      if rightDown {
        CGContextMoveToPoint(ctx, lineWidth, lineWidth)
        CGContextAddLineToPoint(ctx, lineWidth, lineWidth + beamHeight)
        CGContextAddLineToPoint(ctx, w - lineWidth, h - lineWidth)
        CGContextAddLineToPoint(ctx, w - lineWidth, h - beamHeight - lineWidth)
      } else {
        CGContextMoveToPoint(ctx, lineWidth, h - beamHeight - lineWidth)
        CGContextAddLineToPoint(ctx, lineWidth, h - lineWidth)
        CGContextAddLineToPoint(ctx, w - lineWidth, beamHeight + lineWidth)
        CGContextAddLineToPoint(ctx, w - lineWidth, lineWidth)
      }
    } else {
      if rightDown {
        CGContextMoveToPoint(ctx, lineWidth, beamHeight + lineWidth)
        CGContextAddLineToPoint(ctx, lineWidth, lineWidth)
        CGContextAddLineToPoint(ctx, w - lineWidth, h - beamHeight - lineWidth)
        CGContextAddLineToPoint(ctx, w - lineWidth, h)
      } else {
        CGContextMoveToPoint(ctx, lineWidth, h)
        CGContextAddLineToPoint(ctx, lineWidth, h - beamHeight - lineWidth)
        CGContextAddLineToPoint(ctx, w - lineWidth, lineWidth)
        CGContextAddLineToPoint(ctx, w - lineWidth, beamHeight + lineWidth)
      }
    }

    CGContextStrokePath(ctx)

    let textRectSize = CGSize(width: fontSize, height: fontSize)
    let textRectOrigin = CGPoint(
      x: w / 2 - textRectSize.width / 2,
      y: invert ? min(h / 2 - fontSize / 2 + fontSize, h - fontSize) : max(h / 2 - fontSize / 2 - fontSize, 0))
    let textRect = CGRect(origin: textRectOrigin, size: textRectSize)

    let paraStyle = NSMutableParagraphStyle()
    paraStyle.alignment = .Center

    let font = UIFont(name: "Helvetica Neue", size: fontSize)
    let attributes: [String : AnyObject] = [
      NSForegroundColorAttributeName: tintColor,
      NSFontAttributeName: font!,
      NSParagraphStyleAttributeName: paraStyle
    ]

    CGContextSetBlendMode(ctx, .Clear)
    backgroundColor?.setFill()
    CGContextFillRect(ctx, textRect)
    CGContextSetBlendMode(ctx, .Normal)

    NSString(string: "\(notes)").drawInRect(textRect, withAttributes: attributes)
  }
}