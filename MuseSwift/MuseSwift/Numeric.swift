import Foundation

public extension Double {
  public var degree: Double {
    get { return self / M_PI * 180 }
  }

  public var rad: Double {
    get { return self * M_PI / 180 }
  }
}