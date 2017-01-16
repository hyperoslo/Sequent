import ReactiveReSwift

public enum Output<T> {
  case progress
  case data(T)
  case error(Error)
}

public protocol AsyncAction: Action {
  associatedtype DataType
  var payload: Output<DataType> { get set }
  init(payload: Output<DataType>)
}
