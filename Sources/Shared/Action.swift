import ReactiveReSwift

public protocol DynamicAction: Action {
  associatedtype Data
  var payload: Output<Data> { get set }
  init(payload: Output<Data>)
}
