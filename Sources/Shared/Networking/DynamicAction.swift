import ReactiveReSwift

public enum Output<T> {
  case progress
  case data(T)
  case error(Error)
}

public protocol DynamicAction: Action {
  associatedtype DataType
  var payload: Output<DataType> { get set }
  init(payload: Output<DataType>)
}
