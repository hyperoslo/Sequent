import ReactiveReSwift
import RxSwift

extension Variable: ObservablePropertyType {
  public typealias ValueType = Element
  public typealias DisposableType = DisposableWrapper

  public func subscribe(_ function: @escaping (Element) -> Void) -> DisposableWrapper? {
    return DisposableWrapper(disposable: asObservable().subscribe(onNext: function))
  }
}

extension Observable: StreamType {
  public typealias ValueType = Element
  public typealias DisposableType = DisposableWrapper

  public func subscribe(_ function: @escaping (Element) -> Void) -> DisposableWrapper? {
    return DisposableWrapper(disposable: subscribe(onNext: function))
  }
}

public struct DisposableWrapper: SubscriptionReferenceType {
  let disposable: Disposable

  public func dispose() {
    disposable.dispose()
  }
}
