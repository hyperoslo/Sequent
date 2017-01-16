import ReactiveReSwift
import RxSwift
import Malibu
import When

public protocol Intent: ObservableConvertibleType {
  associatedtype E: DynamicAction

  func buildAction(payload: Output<E.DataType>) -> E
}

public protocol RequestIntent: Intent, Requestable {
  var networking: String { get }
  func transform(ride: Ride) -> Promise<E.DataType>
}

public extension RequestIntent {

  func buildAction(payload: Output<E.DataType>) -> E {
    return E(payload: payload)
  }

  func asObservable() -> Observable<E> {
    return Observable.create({ observer in
      let ride = Malibu.networking(self.networking)
        .execute(self)

      self.transform(ride: ride)
        .done({ data in
          let action = self.buildAction(payload: Output.data(data))
          observer.onNext(action)
        })
        .fail({ error in
          observer.onNext(self.buildAction(payload: .error(error)))
        })
        .always({ _ in
          observer.on(.completed)
        })

      return Disposables.create {
        ride.cancel()
      }
    }).startWith(buildAction(payload: .progress))
  }
}

public extension Store {
  func dispatch<I: Intent>(_ intent: I) {
    dispatch(intent.asObservable())
  }
}
