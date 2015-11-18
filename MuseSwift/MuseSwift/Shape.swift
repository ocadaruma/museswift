import Foundation

@IBDesignable public class Block: ScoreElement {
  public override func drawRect(rect: CGRect) {
    let ctx = UIGraphicsGetCurrentContext()
    tintColor.setFill()
    CGContextFillRect(ctx, bounds)
  }
}

@IBDesignable public class Oval: ScoreElement {
  public override func drawRect(rect: CGRect) {
    let ctx = UIGraphicsGetCurrentContext()
    tintColor.setFill()
    CGContextFillEllipseInRect(ctx, bounds)
  }
}