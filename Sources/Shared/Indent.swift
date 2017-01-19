import RxSwift
import ReSwift

public protocol Intent {
  func buildAction() -> Action
}

public protocol ObservableIntent: ObservableConvertibleType {
  associatedtype E: Action
}
