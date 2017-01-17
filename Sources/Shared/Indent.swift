import ReactiveReSwift
import RxSwift

public protocol Intent {
  func buildAction() -> Action
}

public protocol ObservableIntent: ObservableConvertibleType {
  associatedtype E: Action
}
