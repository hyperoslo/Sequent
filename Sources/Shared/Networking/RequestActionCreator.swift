import ReactiveReSwift
import RxSwift
import Malibu
import When

public protocol RequestActionCreator: Requestable, ObservableConvertibleType {
  associatedtype ActionType: DynamicAction
  var networking: String { get }

  func transform(ride: Ride) -> Promise<ActionType.DataType>
  func buildAction(payload: Output<ActionType.DataType>) -> ActionType
}

public extension RequestActionCreator {

  func buildAction(payload: Output<ActionType.DataType>) -> ActionType {
    return ActionType(payload: payload)
  }

  func asObservable() -> Observable<ActionType> {
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
  func dispatch<C: RequestActionCreator>(_ creator: C) where C.E: Action {
    dispatch(creator.asObservable())
  }
}
