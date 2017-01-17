import ReactiveReSwift
import RxSwift
import Malibu
import When

public protocol Intent {
  associatedtype E: Action
}

public protocol DynamicIntent: Intent {
  associatedtype E: DynamicAction
}

public protocol RequestIntent: DynamicIntent, Requestable {
  var networking: String { get }
  func transform(ride: Ride) -> Promise<E.DataType>
}

public extension RequestIntent {

  func asObservable() -> Observable<E> {
    return Observable.create({ observer in
      let ride = Malibu.networking(self.networking)
        .execute(self)

      self.transform(ride: ride)
        .done({ data in
          let action = E(payload: Output.data(data))
          observer.onNext(action)
        })
        .fail({ error in
          observer.onNext(E(payload: .error(error)))
        })
        .always({ _ in
          observer.on(.completed)
        })

      return Disposables.create {
        ride.cancel()
      }
    }).startWith(E(payload: .progress))
  }
}

public extension Store {
  func dispatch<I: RequestIntent>(_ intent: I) {
    dispatch(intent.asObservable())
  }
}
