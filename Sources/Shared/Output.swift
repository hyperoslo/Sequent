import Foundation

public enum Output<T> {
  case progress
  case data(T)
  case error(Error)

  public var data: T? {
    switch self {
    case .data(let data):
      return data
    default:
      return nil
    }
  }

  public var error: Error? {
    switch self {
    case .error(let error):
      return error
    default:
      return nil
    }
  }

  public var inProgress: Bool {
    switch self {
    case .progress:
      return true
    default:
      return false
    }
  }
}

public func ==<T: Equatable>(lhs: Output<T>, rhs: Output<T>) -> Bool {
  return lhs.data == rhs.data && lhs.inProgress == rhs.inProgress && (lhs.error as? NSError == rhs.error as? NSError)
}
