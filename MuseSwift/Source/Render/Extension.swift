import Foundation

extension CGPoint {
  public func withX(x: CGFloat) -> CGPoint {
    return CGPoint(x: x, y: self.y)
  }

  public func withY(y: CGFloat) -> CGPoint {
    return CGPoint(x: self.x, y: y)
  }
}

public func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

public func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

public prefix func -(point: CGPoint) -> CGPoint {
  return CGPoint(x: -point.x, y: -point.y)
}

extension CGRect {
  public var x: CGFloat {
    return self.origin.x
  }

  public var y: CGFloat {
    return self.origin.y
  }

  public var width: CGFloat {
    return self.size.width
  }

  public var height: CGFloat {
    return self.size.height
  }

  public func withOrigin(origin: CGPoint) -> CGRect {
    return CGRect(origin: origin, size: self.size)
  }

  public func withSize(size: CGSize) -> CGRect {
    return CGRect(origin: self.origin, size: size)
  }

  public func withX(x: CGFloat) -> CGRect {
    return CGRect(x: x, y: self.y, width: self.width, height: self.height)
  }

  public func withY(y: CGFloat) -> CGRect {
    return CGRect(x: self.x, y: y, width: self.width, height: self.height)
  }

  public func withWidth(width: CGFloat) -> CGRect {
    return CGRect(x: self.x, y: self.y, width: width, height: self.height)
  }

  public func withHeight(height: CGFloat) -> CGRect {
    return CGRect(x: self.x, y: self.y, width: self.width, height: height)
  }
}

public func +(lhs: CGRect, rhs: CGPoint) -> CGRect {
  return CGRect(origin: lhs.origin + rhs, size: lhs.size)
}

public func -(lhs: CGRect, rhs: CGPoint) -> CGRect {
  return CGRect(origin: lhs.origin - rhs, size: lhs.size)
}
