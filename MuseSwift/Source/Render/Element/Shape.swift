import Foundation

@IBDesignable public class RectElement: ScoreElement {
  public override func drawRect(rect: CGRect) {
    let ctx = UIGraphicsGetCurrentContext()
    tintColor.setFill()
    CGContextFillRect(ctx, bounds)
  }
}

@IBDesignable public class EllipseElement: ScoreElement {
  public override func drawRect(rect: CGRect) {
    let ctx = UIGraphicsGetCurrentContext()
    tintColor.setFill()
    CGContextFillEllipseInRect(ctx, bounds)
  }
}