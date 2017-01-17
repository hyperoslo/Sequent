import ReactiveReSwift
import RxSwift
import Malibu
import When

public protocol DynamicAction: Action {
  associatedtype Data
  var payload: Output<Data> { get set }
  init(payload: Output<Data>)
}

public protocol Intent {
  func buildAction() -> Action
}

public protocol ObservableIntent: ObservableConvertibleType {
  associatedtype E: Action
}
