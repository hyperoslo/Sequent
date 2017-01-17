import ReactiveReSwift
import RxSwift
import Malibu
import When
import Spots

public protocol NetworkIntent: ObservableIntent {
  associatedtype E: DynamicAction
  func asNetworkObservable() -> NetworkObservable<E>
}

public extension NetworkIntent {

  func asObservable() -> Observable<E> {
    return asNetworkObservable().asObservable()
  }
}

public struct NetworkObservable<A: DynamicAction>: ObservableConvertibleType {
  public typealias Transform = (Ride) -> Promise<A.Data>
  public let networking: String
  public let request: Requestable
  public let transform: (Ride) -> Promise<A.Data>

  public init(networking: String, request: Requestable, _ transform: @escaping Transform) {
    self.networking = networking
    self.request = request
    self.transform = transform
  }

  public func asObservable() -> Observable<A> {
    return Observable.create({ observer in
      let ride = Malibu.networking(self.networking).execute(self.request)

      self.transform(ride)
        .done({ data in
          let action = A(payload: Output.data(data))
          observer.onNext(action)
        })
        .fail({ error in
          observer.onNext(A(payload: .error(error)))
        })
        .always({ _ in
          observer.onCompleted()
        })

      return Disposables.create {
        ride.cancel()
      }
    }).startWith(A(payload: .progress))
  }
}

public extension Store {
  func dispatch<T: NetworkIntent>(_ intent: T) {
    dispatch(intent.asObservable())
  }
}
