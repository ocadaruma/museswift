import Foundation

@IBDesignable public class SlurElement: ScoreElement {
  @IBInspectable var start: CGPoint = CGPointZero
  @IBInspectable var end: CGPoint = CGPointZero
  @IBInspectable var invert: Bool = false
  @IBInspectable var thickness: CGFloat = 2

  public override func drawRect(rect: CGRect) {
    let start = self.convertPoint(self.start, fromView: superview)
    let end = self.convertPoint(self.end, fromView: superview)

    let path = UIBezierPath()

    let x1 = start.x
    let x2 = end.x

    let y1 = start.y
    let y2 = end.y

    let dx = x2 - x1
    let dy = y2 - y1

    let distance = sqrt(dx * dx + dy * dy)
    let ux = dx / distance
    let uy = dy / distance

    let flatten = distance / 3.5
    let curve = (invert ? -1 : 1) * min(25, max(4, flatten))

    let controlx1 = x1 + flatten * ux - curve * uy
    let controly1 = y1 + flatten * uy + curve * ux
    let controlx2 = x2 - flatten * ux - curve * uy
    let controly2 = y2 - flatten * uy + curve * ux

    path.moveToPoint(CGPoint(x: x1, y: y1))
    path.addCurveToPoint(CGPoint(x: x2, y: y2), controlPoint1: CGPoint(x: controlx1, y: controly1), controlPoint2: CGPoint(x: controlx2, y: controly2))
    path.addCurveToPoint(CGPoint(x: x1, y: y1), controlPoint1: CGPoint(x: controlx2 - thickness * uy, y: controly2 + thickness * ux), controlPoint2: CGPoint(x: controlx1 - thickness * uy, y: controly1 + thickness * ux))
    path.closePath()

    tintColor.setFill()
    path.fill()
  }
}