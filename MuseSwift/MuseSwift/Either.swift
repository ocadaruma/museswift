import Foundation

public enum Either<T, U> {
  case Left(left: T)
  case Right(right: U)
}
