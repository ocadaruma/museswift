//: Playground - noun: a place where people can play

import Foundation
import MuseSwift
import UIKit

var str = "Hello, playground"

class A {
  var a: Int = 0
  func bar() {
    foo()
  }
}

extension A {
  func foo() {
    a
  }
}

[1,2,3].prefix(2)