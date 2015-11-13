import Foundation

extension UIView {
  var size: (CGFloat, CGFloat) {
    get {
      return (bounds.size.width, bounds.size.height)
    }
  }
}